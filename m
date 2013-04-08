Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab3DHRfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:35:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51664 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763332Ab3DHRfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:35:23 -0400
Message-ID: <5162FFB2.9010201@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 10:34:42 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: when handling percpu_pagelist_fraction, use on_each_cpu()
 to set percpu pageset fields.
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com> <5160D242.4010404@gmail.com>
In-Reply-To: <5160D242.4010404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040817-9360-0000-0000-000011A57CCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 06:56 PM, Simon Jeons wrote:
> Hi Cody,
> On 04/06/2013 04:33 AM, Cody P Schafer wrote:
>> In free_hot_cold_page(), we rely on pcp->batch remaining stable.
>> Updating it without being on the cpu owning the percpu pageset
>> potentially destroys this stability.
>
> If cpu is off, can its pcp pageset be used in free_hot_code_page()?
>

I don't expect it to be as we use this_cpu_ptr() to access the pcp 
pageset. Unless there is some crazy mode where we can override the cpu a 
task believes it is running on...

