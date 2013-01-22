Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3AVKPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:15:49 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58233 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3AVKPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:15:44 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7f6d6d000001620-b3-50fe66ce9ed2
Message-id: <50FE66C6.4040900@samsung.com>
Date: Tue, 22 Jan 2013 11:15:34 +0100
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
In-reply-to: <1358269008.10591.11.camel@dabdike.int.hansenpartnership.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4Zd1zaf8CDH590bLo2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0nZ3JXLBNseLuH40Gxj9SXYwcHBICJhKz36t0MXIC
	mWISF+6tZ+ti5OIQEljKKPFo8SYWkASvgKDEj8n3WEDqmQXkJY5cygYJMwuYSTxqWccMUd/M
	JPFq5Rqoei2J1Z8mM4PYLAKqEu+f97CB2GwChhJdb7vAbFGBUIm1+9aA1YgIWEt8WbWAEWQQ
	s8B1RontRyYzgSSEBRIlTl7YywKx4TOTxN+PX9lBEpwCXhLrtyxgnMAoMAvJgbMQDpyF5MAF
	jMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUIC8csOxsXHrA4xCnAwKvHwPrj/N0CINbGs
	uDL3EKMEB7OSCK9g8L8AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxRwdnH005+2H9xy0zOSKkJ
	Je3b938wK3w465PNM+cOA8el1o9rrv8VU39+qyfo9OR3st4R1fa96kJsVYeDts04sfP0M+WN
	9bF2swW/sNznqBcSunq7LzKpc3ME48Upi5MkhJZMPJ/rvlfr+JedngxiXE/L1ic8m5YpZze/
	oqvl1zL3G1FTDtorsRRnJBpqMRcVJwIAnpsc3iICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 1/15/2013 5:56 PM, James Bottomley wrote:
> On Tue, 2013-01-15 at 15:07 +0100, Marek Szyprowski wrote:
> > Hello,
> >
> > On 1/15/2013 10:13 AM, Geert Uytterhoeven wrote:
> > > Marek?
> > >
> > > On Tue, Jan 15, 2013 at 5:16 AM, Vineet Gupta
> > > <Vineet.Gupta1@synopsys.com> wrote:
> > > > On Monday 14 January 2013 09:07 PM, Mark Salter wrote:
> > > >> On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
> > > >>> c6x/allmodconfig (assumed):
> > > >>>
> > > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> > > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> > > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> > > >>> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> > > >>>
> > > >>> For architectures using dma_map_ops, dma_mmap_coherent() and
> > > >>> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
> > > >>>
> > > >>> C6x does not use dma_map_ops, hence it should implement them as inline
> > > >>> stubs using dma_common_mmap() and dma_common_get_sgtable().
> > > >>>
> > > >> So are dma_mmap_coherent() and dma_get_sgtable() part of the DMA API
> > > >> now? I don't them in Documentation/DMA*.txt anywhere.
> > > >>
> > > >> Why does the default dma_common_mmap() for !CONFIG_MMU return an
> > > >> error?
> > > >>
> > > >> Wouldn't it be better to provide default implementations that an arch
> > > >> could override rather than having to patch all "no dma_map_ops"
> > > >> architectures?
> > > >>
> > > > Speaking for the still-reviewed ARC Port, I completely agree with Mark.
> >
> > dma_mmap_coherent() was partially in the DMA mapping API for some time, but
> > it was available only on a few architectures (afair ARM, powerpc and avr32).
> > This caused significant problems for writing unified device drivers or some
> > device helper modules which were aimed to work on more than one
> > architecture.
> >
> > dma_get_sgtable() is an extension discussed during the Linaro meetings. It
> > is required to correctly implement buffer sharing between device driver
> > without hacks or any assumptions about memory layout in the device drivers.
> >
> > I have implemented some generic code for both of those two functions,
> > keeping
> > in mind that on some hardware architectures (like already mentioned VIVT)
> > it might be not possible to provide coherent mapping to userspace. It is
> > perfectly fine for those functions to return an error in such case.
>
> It's not possible on VIPT either.  This means that the API is unusable
> on quite a large number of architectures.  Surely, if we're starting to
> write drivers using this, we need to fix the API before more people try
> to use it.

I don't get this one. On ARM coherent mappings are implemented as 
non-cacheable,
both in userspace and kernel-space, so having a coherent mapping is 
possible on
VIPT architecture.

There are common, already defined and widely used user interfaces (like 
mentioned
fbdev, v4l2, alsa) which rely on mmaping coherent buffers to userspace. 
There are
drivers which use coherent buffers for those interfaces. It is already 
an issue
to implement mmap call for those drivers as it requires some architecture
specific assumptions. We wanted to remove those assumptions from the 
drivers and
move them to some common dma-mapping calls.

I agree that this might not be directly possible on non-mmu systems, 
where mmap
syscall is handled differently. Some architectures might also have some 
hardware
limitations, which prevents implementing such interface. That's ok, as 
probably
there is no drivers which will use this interface on this architecture.

> For PA-RISC (and all other VIPT, I assume) I need an API which allows me
> to remap the virtual address of the kernel component (probably using the
> kmap area) so the user space and kernel space addresses are congruent.

How such API would look like? What syscall might be used for it?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


