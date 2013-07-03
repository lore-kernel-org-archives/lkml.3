Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3GCMV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:21:28 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33731 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3GCMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <51D29927.80900@atmel.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
 <1372667978-4718-2-git-send-email-richard.genoud@gmail.com>
 <51D24299.9050209@atmel.com> <CACQ1gAgcc=j3kmcpjp8bbdHhxr_k=h8jJs6R_paJbPUMv74uGg@mail.gmail.com>
 <51D29927.80900@atmel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 3 Jul 2013 14:21:06 +0200
Message-ID: <CACQ1gAhnDk-qSt_5xrsMakXqGGDO5pEbA-9UDWCJG=AABDc+zg@mail.gmail.com>
Subject: Re: [RFC PATCH 01/13] misc: atmel_ssc: add device tree DMA support
To: Bo Shen <voice.shen@atmel.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/2 Bo Shen <voice.shen@atmel.com>:
> Hi Richard,
>
>
> On 7/2/2013 16:13, Richard Genoud wrote:
>>>
>>> Please hold on of this, as to the ASoC dmaengine will deal with this. So,
>>> we
>>> >not need do it manually.
>>> >
>>> >Now, I am working on it. And will send out the patch soon after testing
>>> > OK.
>>
>> Ok, I stay tuned !
>
>
> I think you can go on working with the two patches I send just now.
> [1]: ASoC: atmel_ssc_dai: move set dma data to startup callback
> https://patchwork.kernel.org/patch/2811241/
>
> [2]: ASoC: atmel-pcm: use generic dmaengine framework
> https://patchwork.kernel.org/patch/2811261/
>
> I use your patches 4 ~ 8 do a quick testing, it works. Please note the name
> of asound.state under /etc in your rootfs should the same with atmel,model
> in patch 6.

Thanks for testing !
I was just doing the same test, it works with
aplay  -Dplug:default  good_music.wav

but there's a violent hang (kernel stops, no trace) when I try the record :
arecord -v -V stereo -Dplug:default -f cd -t wav -c 2 /tmp/toto.wav
last thing I see is :
dma dma0chan3: atc_control (3)

I'll try to trace that.


Best regards,
Richard.
