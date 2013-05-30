Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935492Ab3E3Qg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:36:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56274 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935436Ab3E3QgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:36:17 -0400
Message-ID: <51A77FF7.5090908@linux.vnet.ibm.com>
Date: Thu, 30 May 2013 09:36:07 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: sparse: use __aligned() instead of manual padding
 in mem_section
References: <1369869279-20155-1-git-send-email-cody@linux.vnet.ibm.com> <51A6A34B.6020907@gmail.com>
In-Reply-To: <51A6A34B.6020907@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053016-7182-0000-0000-00000706D820
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 05:54 PM, Jiang Liu wrote:
> On Thu 30 May 2013 07:14:39 AM CST, Cody P Schafer wrote:
>> Also, does anyone know what causes this alignment to be required here? I found
>> this was breaking things in a patchset I'm working on (WARNs in sysfs code
>> about duplicate filenames when initing mem_sections). Adding some documentation
>> for the reason would be appreciated.
> Hi Cody,
>          I think the alignment requirement is caused by the way the
> mem_section array is
> organized. Basically it requires that PAGE_SIZE could be divided by
> sizeof(struct mem_section).
> So your change seems risky too because it should be aligned to power of
> two instead
> of 2 * sizeof(long).

Well, if that's the case then this patch is wrong, and manual padding 
may be the only way to go. :(

