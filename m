Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3GCPwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:52:13 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58063 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3GCPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <CACQ1gAhnDk-qSt_5xrsMakXqGGDO5pEbA-9UDWCJG=AABDc+zg@mail.gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
 <1372667978-4718-2-git-send-email-richard.genoud@gmail.com>
 <51D24299.9050209@atmel.com> <CACQ1gAgcc=j3kmcpjp8bbdHhxr_k=h8jJs6R_paJbPUMv74uGg@mail.gmail.com>
 <51D29927.80900@atmel.com> <CACQ1gAhnDk-qSt_5xrsMakXqGGDO5pEbA-9UDWCJG=AABDc+zg@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 3 Jul 2013 17:51:49 +0200
Message-ID: <CACQ1gAgPaRm3gxxJNgfj9bR565Q0+SNY3+EcjA_mrh1N+yPzSA@mail.gmail.com>
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

2013/7/3 Richard Genoud <richard.genoud@gmail.com>:
> 2013/7/2 Bo Shen <voice.shen@atmel.com>:
>> Hi Richard,
>>
>>
>> On 7/2/2013 16:13, Richard Genoud wrote:
>>>>
>>>> Please hold on of this, as to the ASoC dmaengine will deal with this. So,
>>>> we
>>>> >not need do it manually.
>>>> >
>>>> >Now, I am working on it. And will send out the patch soon after testing
>>>> > OK.
>>>
>>> Ok, I stay tuned !
>>
>>
>> I think you can go on working with the two patches I send just now.
>> [1]: ASoC: atmel_ssc_dai: move set dma data to startup callback
>> https://patchwork.kernel.org/patch/2811241/
>>
>> [2]: ASoC: atmel-pcm: use generic dmaengine framework
>> https://patchwork.kernel.org/patch/2811261/
>>
>> I use your patches 4 ~ 8 do a quick testing, it works. Please note the name
>> of asound.state under /etc in your rootfs should the same with atmel,model
>> in patch 6.
>
> Thanks for testing !
> I was just doing the same test, it works with
> aplay  -Dplug:default  good_music.wav
>
> but there's a violent hang (kernel stops, no trace) when I try the record :
> arecord -v -V stereo -Dplug:default -f cd -t wav -c 2 /tmp/toto.wav
> last thing I see is :
> dma dma0chan3: atc_control (3)
>
> I'll try to trace that.
I think it's DMA related.
the last thing done by the kernel is:
 i2c i2c-0: i2c_outb: 0x34 A
 i2c i2c-0: i2c_outb: 0x0c A
 i2c i2c-0: i2c_outb: 0x5a A
meaning: enable power on, LINE IN, ADC, OSC, on the WM8731
so, after that, data is comming from the codec to the SSC and then is
handled by the DMA.
there must be something nasty on the DMA bus to hang everything like that...

Richard.
