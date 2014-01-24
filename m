Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaAXTa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:30:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42112 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaAXTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:30:58 -0500
Message-ID: <52E2BF5C.8060009@ti.com>
Date: Fri, 24 Jan 2014 14:30:36 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org> <1390590670-25901-4-git-send-email-yinghai@kernel.org> <20140124192536.GC17156@phenom.dumpdata.com>
In-Reply-To: <20140124192536.GC17156@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014 02:25 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jan 24, 2014 at 11:11:10AM -0800, Yinghai Lu wrote:
>> The new memblock_virt APIs are used to replaced old bootmem API.
>>
>> We need to allocate page below 4G for swiotlb.
>>
>> That should fix regression on Andrew's system that is using swiotlb.
> 
> Please include the title of the patch that caused the regression.
> I presume it is "mm/lib/swiotlb: Use memblock apis for early memory allocations"
> 
> Interestingly enough when I asked about it:
> 
> https://lkml.org/lkml/2013/11/9/280
> 
> 
> 	>> v_overflow_buffer = memblock_virt_alloc_align_nopanic(
> 	>> +						PAGE_ALIGN(io_tlb_overflow),
> 	>> +						PAGE_SIZE);
> 	> 
> 	> Does this guarantee that the pages will be allocated below 4GB?
> 	> 
> 	Yes. The memblock layer still allocates memory from lowmem. As I
> 	mentioned, there is no change in the behavior than what is today
> 	apart from just the interface change.
> 
> How did that happend? Was there another patch in the series that altered
> such assumption?
> 
Actually it didn't. It was the misunderstanding on my side about the
low_mem_max_addr being under 4GB, which is not always true especially
for 64-bit systems which have no addressing limitations. 

Regards,
Santosh

