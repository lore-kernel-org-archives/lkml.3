Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaAXTef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:34:35 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48264 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaAXTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <20140124192536.GC17156@phenom.dumpdata.com>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<1390590670-25901-4-git-send-email-yinghai@kernel.org>
	<20140124192536.GC17156@phenom.dumpdata.com>
Date: Fri, 24 Jan 2014 11:34:28 -0800
X-Google-Sender-Auth: wyY-DaGgOR7NhU5Jrc3UTQYSB5Y
Message-ID: <CAE9FiQWOhc+kavN5dDNLjFkBiYQkaU0_Br2YVN+-7-Ls0RGV9A@mail.gmail.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 11:25 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
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
>         >> v_overflow_buffer = memblock_virt_alloc_align_nopanic(
>         >> +                                            PAGE_ALIGN(io_tlb_overflow),
>         >> +                                            PAGE_SIZE);
>         >
>         > Does this guarantee that the pages will be allocated below 4GB?
>         >
>         Yes. The memblock layer still allocates memory from lowmem. As I
>         mentioned, there is no change in the behavior than what is today
>         apart from just the interface change.
>
> How did that happend? Was there another patch in the series that altered
> such assumption?
>

Yes, that is one.

He chose to set memblock.current_limit to max_low_mapped. (that is under 4g).

but it broke big numa system as all boot mem is under 4G and system
with lots of memory will need to
have big chunk for vmemmap .

Before that patch, we need to add another API to make sure those
swiotlb under 4G.

Thanks

Yinghai
