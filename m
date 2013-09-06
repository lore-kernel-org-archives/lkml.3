Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3IFRHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:07:53 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59848 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3IFRHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:07:51 -0400
MIME-Version: 1.0
In-Reply-To: <2886273.7m0Ub6qIMh@avalon>
References: <1378471436-7045-1-git-send-email-geert@linux-m68k.org>
	<2886273.7m0Ub6qIMh@avalon>
Date: Fri, 6 Sep 2013 19:07:50 +0200
X-Google-Sender-Auth: f3RuGR1s2VfrrH2B4HjwX3PxURY
Message-ID: <CAMuHMdV6QrVcHfxwnS7EDQF6J6DjLTTZRNPP-VkWuJOv4HFweg@mail.gmail.com>
Subject: Re: [PATCH] [media] media/v4l2: VIDEO_RENESAS_VSP1 should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 5:20 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Friday 06 September 2013 14:43:56 Geert Uytterhoeven wrote:
>> If NO_DMA=y:
>>
>> warning: (... && VIDEO_RENESAS_VSP1 && ...) selects VIDEOBUF2_DMA_CONTIG
>> which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)
>>
>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
>> drivers/media/v4l2-core/videobuf2-dma-contig.c:202: error: implicit
>> declaration of function ‘dma_mmap_coherent’
>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function
>> ‘vb2_dc_get_base_sgt’: drivers/media/v4l2-core/videobuf2-dma-contig.c:385:
>> error: implicit declaration of function ‘dma_get_sgtable’ make[7]: ***
>> [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1
>>
>> VIDEO_RENESAS_VSP1 (which doesn't have a platform dependency) selects
>> VIDEOBUF2_DMA_CONTIG, but the latter depends on HAS_DMA.
>>
>> Make VIDEO_RENESAS_VSP1 depend on HAS_DMA to fix this.
>
> Is there a chance we could fix the Kconfig infrastructure instead ? It warns
> about the unmet dependency, shouldn't it disallow selecting the driver in the
> first place ? I have a vague feeling that this topic has been discussed before
> though.

This has come up several times before.
Unfortunately "select" was "designed" to circumvent all dependencies of
the target symbol.

> If that's not possible,
>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
>> ---
>>  drivers/media/platform/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 8068d7b..fbc0611 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -212,7 +212,7 @@ config VIDEO_SH_VEU
>>
>>  config VIDEO_RENESAS_VSP1
>>       tristate "Renesas VSP1 Video Processing Engine"
>> -     depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +     depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
>>       select VIDEOBUF2_DMA_CONTIG
>>       ---help---
>>         This is a V4L2 driver for the Renesas VSP1 video processing engine.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
