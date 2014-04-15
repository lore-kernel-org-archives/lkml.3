Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaDOX6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:58:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38701 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaDOX6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:58:15 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: convert some level-less printks to pr_*
References: <1395942859-11611-1-git-send-email-mitchelh@codeaurora.org>
	<1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
	<20140414155526.96b0832bf4660c026bc3a1d9@linux-foundation.org>
Date: Tue, 15 Apr 2014 16:58:21 -0700
In-Reply-To: <20140414155526.96b0832bf4660c026bc3a1d9@linux-foundation.org>
	(Andrew Morton's message of "Mon, 14 Apr 2014 15:55:26 -0700")
Message-ID: <vnkwvbuaywki.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14 2014 at 03:55:26 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 27 Mar 2014 10:54:19 -0700 Mitchel Humpherys <mitchelh@codeaurora.org> wrote:
>>  #include <linux/mm.h>
>>  #include <linux/export.h>
>>  #include <linux/swap.h>
>> @@ -15,6 +17,7 @@
>>  #include <linux/hash.h>
>>  #include <linux/highmem.h>
>>  #include <linux/bootmem.h>
>> +#include <linux/printk.h>
>>  #include <asm/tlbflush.h>
>>  
>>  #include <trace/events/block.h>
>> @@ -34,7 +37,7 @@ static __init int init_emergency_pool(void)
>>  
>>  	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
>>  	BUG_ON(!page_pool);
>> -	printk("bounce pool size: %d pages\n", POOL_SIZE);
>> +	pr_info("bounce pool size: %d pages\n", POOL_SIZE);
>
> This used to print "bounce pool size: N pages" but will now print
> "bounce: bounce pool size: N pages".
>
> It isn't necessarily a *bad* change but perhaps a little more thought
> could be put into it.  In this example it would be better remove the
> redundancy by using 
>
> 	pr_info("pool size: %d pages\n"...);

Yes I noticed this in my boot-test... I'll change it to remove the
redundancy. The others all seem okay.

>
> And all of this should be described and justified in the changelog,
> please.

Will send a v3 shortly. Thanks for your comments.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
