Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3AOOHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:07:13 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11922 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3AOOHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:07:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f4-b7f6d6d000001620-8e-50f5628ba2ec
Message-id: <50F56286.8070200@samsung.com>
Date: Tue, 15 Jan 2013 15:07:02 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Salter <msalter@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent() and
 dma_get_sgtable()
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
 <1358073890-3610-3-git-send-email-geert@linux-m68k.org>
 <1358177872.4357.53.camel@t520.localdomain> <50F4D83A.7020803@synopsys.com>
 <CAMuHMdWjZAY19GPpjoXKfWb3pOp2RbZXDvb4nr5pMmjEMFuB4w@mail.gmail.com>
In-reply-to: <CAMuHMdWjZAY19GPpjoXKfWb3pOp2RbZXDvb4nr5pMmjEMFuB4w@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4Zd3upK8BBremKlt07PrKYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ2Pp/HVtAoUdG5+RNbA+M74S5GTg4JAROJfzMms0LY
	YhIX7q1n62Lk4hASWMoo0X1pNliCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXMJB61rGOGqG9m
	krj4+jYTRL2WxJ2Oc2A2i4CqxJtjV8FsNgFDia63XWwgtqhAqMTafWuYQWaKCOhKzPnJBDFz
	FdDea/EgtrBAosTJC3tZIOZPYpL4ceYtO0iCUyBYYnH7S/YJjAKzkJw3C+G8WUjOW8DIvIpR
	NLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJBC/7GBcfMzqEKMAB6MSD6+hwZcAIdbEsuLK3EOM
	EhzMSiK8GkZfA4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUw+kc8re/+HLzsmdAd7rDPMV3utxnD
	Rbr6L+zalGPwsHNll4Xj/uCbf9Mer3RPWZmy8TL/o69eaw46HPJm7F3EpsmoO+1KveVtx18s
	vrNFtC/E7TPaWbFu6bIZRlrOQW8fVJxc9NnP5/ZH8Ywj9r/CdZeYLk5S6U244rNfmN/ew5b/
	1lfhF5POK7EUZyQaajEXFScCAA3Cr3EiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 1/15/2013 10:13 AM, Geert Uytterhoeven wrote:
> Marek?
>
> On Tue, Jan 15, 2013 at 5:16 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
> > On Monday 14 January 2013 09:07 PM, Mark Salter wrote:
> >> On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
> >>> c6x/allmodconfig (assumed):
> >>>
> >>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> >>> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> >>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> >>> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> >>>
> >>> For architectures using dma_map_ops, dma_mmap_coherent() and
> >>> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
> >>>
> >>> C6x does not use dma_map_ops, hence it should implement them as inline
> >>> stubs using dma_common_mmap() and dma_common_get_sgtable().
> >>>
> >> So are dma_mmap_coherent() and dma_get_sgtable() part of the DMA API
> >> now? I don't them in Documentation/DMA*.txt anywhere.
> >>
> >> Why does the default dma_common_mmap() for !CONFIG_MMU return an
> >> error?
> >>
> >> Wouldn't it be better to provide default implementations that an arch
> >> could override rather than having to patch all "no dma_map_ops"
> >> architectures?
> >>
> > Speaking for the still-reviewed ARC Port, I completely agree with Mark.

dma_mmap_coherent() was partially in the DMA mapping API for some time, but
it was available only on a few architectures (afair ARM, powerpc and avr32).
This caused significant problems for writing unified device drivers or some
device helper modules which were aimed to work on more than one 
architecture.

dma_get_sgtable() is an extension discussed during the Linaro meetings. It
is required to correctly implement buffer sharing between device driver
without hacks or any assumptions about memory layout in the device drivers.

I have implemented some generic code for both of those two functions, 
keeping
in mind that on some hardware architectures (like already mentioned VIVT)
it might be not possible to provide coherent mapping to userspace. It is
perfectly fine for those functions to return an error in such case.

My common implementation returns error for NOMMU systems because I was
convinced that remapping the pages to userspace is simply not possible
without the MMU.

I'm really sorry for skipping the non dma_map_ops based architectures, I had
a plan to cover them in one of the next updates, but in meantime the v4l2
updates requiring those interfaces has been merged and I got very busy with
other stuff, then Geert was faster fixing it.

I'm also working on updated DMA mapping documentation to cover those new
functions as well as some new DMA attributes introduced recently, I hope to
post them soon.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


