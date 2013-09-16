Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3IPQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:14:36 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39677 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3IPQOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:14:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] [media] media/v4l2: VIDEO_RENESAS_VSP1 should depend on HAS_DMA
Date: Mon, 16 Sep 2013 18:14:36 +0200
Message-ID: <1824528.Vfxhey5Hfr@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMuHMdV6QrVcHfxwnS7EDQF6J6DjLTTZRNPP-VkWuJOv4HFweg@mail.gmail.com>
References: <1378471436-7045-1-git-send-email-geert@linux-m68k.org> <2886273.7m0Ub6qIMh@avalon> <CAMuHMdV6QrVcHfxwnS7EDQF6J6DjLTTZRNPP-VkWuJOv4HFweg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Friday 06 September 2013 19:07:50 Geert Uytterhoeven wrote:
> On Fri, Sep 6, 2013 at 5:20 PM, Laurent Pinchart wrote:
> > On Friday 06 September 2013 14:43:56 Geert Uytterhoeven wrote:
> >> If NO_DMA=y:
> >> 
> >> warning: (... && VIDEO_RENESAS_VSP1 && ...) selects VIDEOBUF2_DMA_CONTIG
> >> which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)
> >> 
> >> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function
> >> ‘vb2_dc_mmap’:
> >> drivers/media/v4l2-core/videobuf2-dma-contig.c:202: error: implicit
> >> declaration of function ‘dma_mmap_coherent’
> >> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function
> >> ‘vb2_dc_get_base_sgt’:
> >> drivers/media/v4l2-core/videobuf2-dma-contig.c:385:
> >> error: implicit declaration of function ‘dma_get_sgtable’ make[7]: ***
> >> [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1
> >> 
> >> VIDEO_RENESAS_VSP1 (which doesn't have a platform dependency) selects
> >> VIDEOBUF2_DMA_CONTIG, but the latter depends on HAS_DMA.
> >> 
> >> Make VIDEO_RENESAS_VSP1 depend on HAS_DMA to fix this.
> > 
> > Is there a chance we could fix the Kconfig infrastructure instead ? It
> > warns about the unmet dependency, shouldn't it disallow selecting the
> > driver in the first place ? I have a vague feeling that this topic has
> > been discussed before though.
> 
> This has come up several times before.
> Unfortunately "select" was "designed" to circumvent all dependencies of
> the target symbol.

I suppose that fixing this "design bug" (or feature, depending on how one sees 
it) has been discussed extensively in the past and that the behaviour will not 
change in the near future.

I'll take your patch in and push it to v3.12.

> > If that's not possible,
> > 
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

