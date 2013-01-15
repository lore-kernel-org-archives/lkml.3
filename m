Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3AOERO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:17:14 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:58183 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3AOERN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:17:13 -0500
Message-ID: <50F4D83A.7020803@synopsys.com>
Date: Tue, 15 Jan 2013 09:46:58 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Mark Salter <msalter@redhat.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-arch@vger.kernel.org>,
        <linux-c6x-dev@linux-c6x.org>, <linux-kernel@vger.kernel.org>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent()
 and dma_get_sgtable()
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>  <1358073890-3610-3-git-send-email-geert@linux-m68k.org> <1358177872.4357.53.camel@t520.localdomain>
In-Reply-To: <1358177872.4357.53.camel@t520.localdomain>
Content-Type: text/plain; charset="ISO-8859-7"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013 09:07 PM, Mark Salter wrote:
> On Sun, 2013-01-13 at 11:44 +0100, Geert Uytterhoeven wrote:
>> c6x/allmodconfig (assumed):
>>
>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ¡vb2_dc_mmap¢:
>> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ¡dma_mmap_coherent¢
>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ¡vb2_dc_get_base_sgt¢:
>> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ¡dma_get_sgtable¢
>>
>> For architectures using dma_map_ops, dma_mmap_coherent() and
>> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
>>
>> C6x does not use dma_map_ops, hence it should implement them as inline
>> stubs using dma_common_mmap() and dma_common_get_sgtable().
>>
> 
> So are dma_mmap_coherent() and dma_get_sgtable() part of the DMA API
> now? I don't them in Documentation/DMA*.txt anywhere.
> 
> Why does the default dma_common_mmap() for !CONFIG_MMU return an
> error?
> 
> Wouldn't it be better to provide default implementations that an arch
> could override rather than having to patch all "no dma_map_ops"
> architectures?
> 
> --Mark
> 
> 

Speaking for the still-reviewed ARC Port, I completely agree with Mark.

-Vineet
