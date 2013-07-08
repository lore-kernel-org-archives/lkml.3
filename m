Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3GHNxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:53:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:34484 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3GHNxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:53:45 -0400
Message-ID: <51DAC467.8060504@atmel.com>
Date: Mon, 8 Jul 2013 15:53:43 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>, Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 0/5] Sound support for at91sam9x5-wm8731 based boards
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 15:29, Richard Genoud :
> Hi,
>
> This patchset add sound on the at91sam9x5ek board.
> It's based on Nicolas Ferre's work in the 2.6.39 atmel patch for sam9x5:
> https://github.com/linux4sam/linux-at91/commit/0aa157c9e71ccccf3abc30fa37eb5c95b392978d
>
> It needs Bo Chen's patchset on the generic dmaengine (topic/atmel branch
> on Mark's sound tree) and the SSC interrupts disabled (cf
> http://www.spinics.net/lists/arm-kernel/msg256901.html)
>
>
> Tested on at91sam9g35ek.
>
> patches applies on next-20130708
>
> [I let the original signed-off from Nicolas and Uwe in place, I don't
> know if I should replace them by something like "originaly-signed-off-by"
> since the code has been changed.]

I am happy to give my "signed-off" to this patch. I guess that Uwe's one 
was more an integration signed-off when he imported the code to his git 
tree.

> [Sorry if it's too late for 3.11]

Do not be sorry. Good work is always appreciated at any time!

> Changes from V1-RFC:
>   * drop patches on SSC since Bo Chen already did the work
>   * reorder patches to have the machine driver first
>   * drop code already handled by the ASoC framework
>   * drop unneeded SND_ATMEL_SOC_PDC config selection
>   * use static snd_soc_card and  snd_soc_dai_link structures.
>
> Best regards,
> Richard.
>
> Nicolas Ferre (1):
>    sound: sam9x5_wm8731: machine driver for at91sam9x5 wm8731 boards
>
> Richard Genoud (4):
>    ARM: AT91: DTS: sam9x5: add SSC DMA parameters
>    ARM: AT91: DTS: sam9x5ek: add WM8731 codec
>    ARM: AT91: DTS: sam9x5ek: add sound configuration
>    ARM: AT91: DTS: sam9x5ek: enable SSC

Maybe we will have to split the series and let these DT patches go with 
arm-soc.

>   arch/arm/boot/dts/at91sam9x5.dtsi   |    3 +
>   arch/arm/boot/dts/at91sam9x5ek.dtsi |   27 +++++
>   sound/soc/atmel/Kconfig             |   10 ++
>   sound/soc/atmel/Makefile            |    2 +
>   sound/soc/atmel/sam9x5_wm8731.c     |  206 +++++++++++++++++++++++++++++++++++
>   5 files changed, 248 insertions(+)
>   create mode 100644 sound/soc/atmel/sam9x5_wm8731.c
>

Thanks, bye,
-- 
Nicolas Ferre
