Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3GDBPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:15:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13383 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3GDBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:15:11 -0400
Message-ID: <51D4CC94.3020908@atmel.com>
Date: Thu, 4 Jul 2013 09:15:00 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC PATCH 01/13] misc: atmel_ssc: add device tree DMA support
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com> <1372667978-4718-2-git-send-email-richard.genoud@gmail.com> <51D24299.9050209@atmel.com> <CACQ1gAgcc=j3kmcpjp8bbdHhxr_k=h8jJs6R_paJbPUMv74uGg@mail.gmail.com> <51D29927.80900@atmel.com> <CACQ1gAhnDk-qSt_5xrsMakXqGGDO5pEbA-9UDWCJG=AABDc+zg@mail.gmail.com> <CACQ1gAgPaRm3gxxJNgfj9bR565Q0+SNY3+EcjA_mrh1N+yPzSA@mail.gmail.com>
In-Reply-To: <CACQ1gAgPaRm3gxxJNgfj9bR565Q0+SNY3+EcjA_mrh1N+yPzSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 7/3/2013 23:51, Richard Genoud wrote:
>> >but there's a violent hang (kernel stops, no trace) when I try the record :
>> >arecord -v -V stereo -Dplug:default -f cd -t wav -c 2 /tmp/toto.wav
>> >last thing I see is :
>> >dma dma0chan3: atc_control (3)

I don't meet this issue. Playback and recording works well on my side on 
at91sam9g35ek board.

>> >I'll try to trace that.
> I think it's DMA related.
> the last thing done by the kernel is:
>   i2c i2c-0: i2c_outb: 0x34 A
>   i2c i2c-0: i2c_outb: 0x0c A
>   i2c i2c-0: i2c_outb: 0x5a A
> meaning: enable power on, LINE IN, ADC, OSC, on the WM8731
> so, after that, data is comming from the codec to the SSC and then is
> handled by the DMA.
> there must be something nasty on the DMA bus to hang everything like that...

Will you try i2c without DMA support to test this issue?

> Richard.

Best Regards,
Bo Shen

