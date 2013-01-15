Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3AOJNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:13:50 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:42338 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3AOJNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:13:47 -0500
MIME-Version: 1.0
In-Reply-To: <50F4D83A.7020803@synopsys.com>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
	<1358073890-3610-3-git-send-email-geert@linux-m68k.org>
	<1358177872.4357.53.camel@t520.localdomain>
	<50F4D83A.7020803@synopsys.com>
Date: Tue, 15 Jan 2013 10:13:46 +0100
X-Google-Sender-Auth: pxnUGf7glbDFBVNPamhGy8fcXHc
Message-ID: <CAMuHMdWjZAY19GPpjoXKfWb3pOp2RbZXDvb4nr5pMmjEMFuB4w@mail.gmail.com>
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent() and dma_get_sgtable()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mark Salter <msalter@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek?

On Tue, Jan 15, 2013 at 5:16 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> On Monday 14 January 2013 09:07 PM, Mark Salter wrote:
>> On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
>>> c6x/allmodconfig (assumed):
>>>
>>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
>>> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
>>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
>>> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
>>>
>>> For architectures using dma_map_ops, dma_mmap_coherent() and
>>> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
>>>
>>> C6x does not use dma_map_ops, hence it should implement them as inline
>>> stubs using dma_common_mmap() and dma_common_get_sgtable().
>>>
>>
>> So are dma_mmap_coherent() and dma_get_sgtable() part of the DMA API
>> now? I don't them in Documentation/DMA*.txt anywhere.
>>
>> Why does the default dma_common_mmap() for !CONFIG_MMU return an
>> error?
>>
>> Wouldn't it be better to provide default implementations that an arch
>> could override rather than having to patch all "no dma_map_ops"
>> architectures?
>>
>> --Mark
>>
>>
>
> Speaking for the still-reviewed ARC Port, I completely agree with Mark.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
