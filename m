Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3AVKdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:33:18 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23803 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AVKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:33:15 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7f6d6d000001620-59-50fe6ae92480
Message-id: <50FE6AE8.4020504@samsung.com>
Date: Tue, 22 Jan 2013 11:33:12 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Salter <msalter@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent() and
 dma_get_sgtable()
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
 <1358073890-3610-3-git-send-email-geert@linux-m68k.org>
 <1358177872.4357.53.camel@t520.localdomain> <50F4D83A.7020803@synopsys.com>
 <CAMuHMdWjZAY19GPpjoXKfWb3pOp2RbZXDvb4nr5pMmjEMFuB4w@mail.gmail.com>
 <50F56286.8070200@samsung.com>
 <1358269008.10591.11.camel@dabdike.int.hansenpartnership.com>
 <CAMuHMdXk1mdkMViYqypvnXO0_1LdjbH8S7z8FNe97yDUW6BYRA@mail.gmail.com>
 <1358809159.3975.63.camel@dabdike.int.hansenpartnership.com>
 <1358849633.2387.11.camel@dabdike.int.hansenpartnership.com>
In-reply-to: <1358849633.2387.11.camel@dabdike.int.hansenpartnership.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xy7ovs/4FGGw7omPRsesri8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpY8HQHe0GbfsX5ni72BsYfKl2MHBwSAiYSq3/pdzFy
	ApliEhfurWfrYuTiEBJYyihx4coLdpAEr4CgxI/J91hA6pkF5CWOXMoGCTMLmEk8alnHDFHf
	zCSx+80xRoh6LYm9F5rBbBYBVYnHx7eygdhsAoYSXW+7wGxRgVCJtfvWMIPYIgLWEl9WLWAE
	GcQscJ1RYvuRyUwgCWGBRImTF/ayQGzYwSLRum8yWDengKfEp88/mCYwCsxCcuAshANnITlw
	ASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQUPyyg3HxMatDjAIcjEo8vA/u/w0QYk0s
	K67MPcQowcGsJMIrGPwvQIg3JbGyKrUoP76oNCe1+BAjEwenVAPjnKwmK63JpzzV1pbdrN+0
	2Lb6UpLxVCPjR31yk/abvCvm/mdebV5zNObC511X1n9R9s7RYWDvrp4Z/iB9sdemxTemSHl7
	+EaduK3FcjOsWGO9sfMjV9dz+RrtO8RYJUxe2Ktv3M54fmqhUaSI75ko7t7GQwWSpluubHO7
	xDLB988exz9OsyYpsRRnJBpqMRcVJwIAXYO4PCMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 1/22/2013 11:13 AM, James Bottomley wrote:
> On Mon, 2013-01-21 at 22:59 +0000, James Bottomley wrote:
> > On Mon, 2013-01-21 at 21:00 +0100, Geert Uytterhoeven wrote:
> > > On Tue, Jan 15, 2013 at 5:56 PM, James Bottomley
> > > <James.Bottomley@hansenpartnership.com> wrote:
> > > > On Tue, 2013-01-15 at 15:07 +0100, Marek Szyprowski wrote:
> > > >> On 1/15/2013 10:13 AM, Geert Uytterhoeven wrote:
> > > >> > Marek?
> > > >> >
> > > >> > On Tue, Jan 15, 2013 at 5:16 AM, Vineet Gupta
> > > >> > <Vineet.Gupta1@synopsys.com> wrote:
> > > >> > > On Monday 14 January 2013 09:07 PM, Mark Salter wrote:
> > > >> > >> On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
> > > >> > >>> c6x/allmodconfig (assumed):
> > > >> > >>>
> > > >> > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> > > >> > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> > > >> > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> > > >> > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> > > >> > >>>
> > > >> > >>> For architectures using dma_map_ops, dma_mmap_coherent() and
> > > >> > >>> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
> > > >> > >>>
> > > >> > >>> C6x does not use dma_map_ops, hence it should implement them as inline
> > > >> > >>> stubs using dma_common_mmap() and dma_common_get_sgtable().
> > > >> > >>>
> > > >> > >> So are dma_mmap_coherent() and dma_get_sgtable() part of the DMA API
> > > >> > >> now? I don't them in Documentation/DMA*.txt anywhere.
> > > >> > >>
> > > >> > >> Why does the default dma_common_mmap() for !CONFIG_MMU return an
> > > >> > >> error?
> > > >> > >>
> > > >> > >> Wouldn't it be better to provide default implementations that an arch
> > > >> > >> could override rather than having to patch all "no dma_map_ops"
> > > >> > >> architectures?
> > > >> > >>
> > > >> > > Speaking for the still-reviewed ARC Port, I completely agree with Mark.
> > > >>
> > > >> dma_mmap_coherent() was partially in the DMA mapping API for some time, but
> > > >> it was available only on a few architectures (afair ARM, powerpc and avr32).
> > > >> This caused significant problems for writing unified device drivers or some
> > > >> device helper modules which were aimed to work on more than one
> > > >> architecture.
> > > >>
> > > >> dma_get_sgtable() is an extension discussed during the Linaro meetings. It
> > > >> is required to correctly implement buffer sharing between device driver
> > > >> without hacks or any assumptions about memory layout in the device drivers.
> > > >>
> > > >> I have implemented some generic code for both of those two functions,
> > > >> keeping
> > > >> in mind that on some hardware architectures (like already mentioned VIVT)
> > > >> it might be not possible to provide coherent mapping to userspace. It is
> > > >> perfectly fine for those functions to return an error in such case.
> > > >
> > > > It's not possible on VIPT either.  This means that the API is unusable
> > > > on quite a large number of architectures.  Surely, if we're starting to
> > > > write drivers using this, we need to fix the API before more people try
> > > > to use it.
> > > >
> > > > For PA-RISC (and all other VIPT, I assume) I need an API which allows me
> > > > to remap the virtual address of the kernel component (probably using the
> > > > kmap area) so the user space and kernel space addresses are congruent.
> > >
> > > So what are we gonna do for 3.8? I'd like to get my allmodconfig build
> > > green again ;-)
> > >
> > > Change the API?
> >
> > Well, if we want the API to work universally, we have to.  As I said,
> > for VIPT systems, the only coherency mechanism we have is the virtual
> > address ... we have to fix that in the kernel to be congruent with the
> > userspace virtual address if we want coherency between the kernel and
> > userspace.
> >
> > However, if it only needs to work on ARM and x86, it can stay the way it
> > is and we could just pull it out of the generic core.
> >
> > Who actually wants to use this API, and what for?
> >
> > > Keep the API but do a best-effort fix to unbreak the builds?
> > >   - Apply my patches that got acks (avr32/blackfin/cris/m68k),
> > >   - Use static inlines that return -EINVAL for the rest
> > > (c6x/frv/mn10300/parisc/xtensa).
> > > I still have a few m68k fixes queued for 3.8, for which I've been postponing the
> > > pull request to get this sorted out, so I could include the above.
> > >
> > > Any other solution?
> >
> > If it's an API that only works on ARM and x86, there's not much point
> > pretending it's universal, so we should remove it from the generic arch
> > code and allow only those architectures which can use it.
>
> There might be a simple solution:  just replace void *cpu_addr with void
> **cpu_addr in the API.  This is a bit nasty since compilers think that
> void ** to void * conversion is quite legal, so it would be hard to pick
> up misuse of this (uint8_t ** would be better).  That way VIPT could
> remap the kernel pages to a coherent address.  This would probably have
> to change in the dma_mmap_attr() and dma_ops structures.

Frankly, I don't get this change.

The call sequence for the current api is following:

/* driver initialization */
dma_addr_t dmah;
void *cpu_ptr = dma_alloc_coherent(dev, size, &dmah, GFP_KERNEL);

/* mmap implementation */

return dma_mmap_coherent(dev, vma, cpu_addr, dmah, size);

/* cleanup */
dma_free_coherent(dev, size, cpu_addr, dmah);

I assume you want to let dma_mmap_coherent to change the cpu_addr returned
by dma_alloc_coherent()? I really don't see how this might help.


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


