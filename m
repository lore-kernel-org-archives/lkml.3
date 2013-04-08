Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935763Ab3DHThg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:37:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47919 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935713Ab3DHThf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:37:35 -0400
Message-ID: <51631C70.8010404@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 12:37:20 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: fixup changers of per cpu pageset's ->high and
 ->batch
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <5160CC94.6040909@gmail.com>
In-Reply-To: <5160CC94.6040909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040819-7182-0000-0000-000006247C0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 06:32 PM, Simon Jeons wrote:
> Hi Cody,
> On 04/06/2013 04:33 AM, Cody P Schafer wrote:
>> In one case while modifying the ->high and ->batch fields of per cpu
>> pagesets
>> we're unneededly using stop_machine() (patches 1 & 2), and in another
>> we don't have any
>> syncronization at all (patch 3).
>
> Do you mean stop_machine() is used for syncronization between each
> online cpu?
>

I mean that it looks like synchronization between cpus is unneeded 
because of how per cpu pagesets are used, so stop_machine() (which does 
provide syncro between all cpus) is unnecessarily "strong".

