Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3ANPiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:38:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab3ANPiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:38:04 -0500
Message-ID: <1358177872.4357.53.camel@t520.localdomain>
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent()
 and dma_get_sgtable()
From: Mark Salter <msalter@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Mon, 14 Jan 2013 10:37:52 -0500
In-Reply-To: <1358073890-3610-3-git-send-email-geert@linux-m68k.org>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
	 <1358073890-3610-3-git-send-email-geert@linux-m68k.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="iso-8859-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
> c6x/allmodconfig (assumed):
> 
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ¡vb2_dc_mmap¢:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ¡dma_mmap_coherent¢
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ¡vb2_dc_get_base_sgt¢:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ¡dma_get_sgtable¢
> 
> For architectures using dma_map_ops, dma_mmap_coherent() and
> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
> 
> C6x does not use dma_map_ops, hence it should implement them as inline
> stubs using dma_common_mmap() and dma_common_get_sgtable().
> 

So are dma_mmap_coherent() and dma_get_sgtable() part of the DMA API
now? I don't them in Documentation/DMA*.txt anywhere.

Why does the default dma_common_mmap() for !CONFIG_MMU return an
error?

Wouldn't it be better to provide default implementations that an arch
could override rather than having to patch all "no dma_map_ops"
architectures?

--Mark


