Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaCSF5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:57:41 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:62696 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbaCSF5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:57:38 -0400
Message-ID: <532931C3.4080909@atmel.com>
Date: Wed, 19 Mar 2014 13:57:23 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-8-git-send-email-voice.shen@atmel.com> <20140317115518.GD11706@sirena.org.uk>
In-Reply-To: <20140317115518.GD11706@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 03/17/2014 07:55 PM, Mark Brown wrote:
> On Mon, Mar 17, 2014 at 05:45:40PM +0800, Bo Shen wrote:
>
>>     - compatible: "atmel,asoc-wm8904"
>>     - atmel,model: The user-visible name of this sound complex.
>> +  - clocks: A list of clocks needed by the wm8904 chip.
>> +  - clock-output-names: Driver related clock names. Shall contain "pck0".
>
> If this is a clock for the CODEC it should be documented as part of the
> binding for the CODEC and connected to the CODEC in the device tree
> rather than being part of a machine driver binding.

This is a optional clock for CODEC which depends on hardware design. 
There are 3 options for this clock, wm8904 as an example.
1. Using internal FLL, so won't use this clock.
2. Using external oscillator, no need to retrieve this clock.
3. Using SoC provide this clock (we use this case).

After considering these 3 options, if we put this into CODEC driver to 
do it, I think it will be more complicate to do logic judgement. Do you 
think so?

And, in machine driver, it will depends on the clock option to decide 
whether to call snd_soc_dai_set_pll and snd_soc_dai_set_sysclk.

And also the <Documentation/soud/alsa/soc/machine.txt> mentions the 
machine drivers responsibility (one is for clocking) as following:
--->8---
The ASoC machine (or board) driver is the code that glues together all the
component drivers (e.g. codecs, platforms and DAIs). It also describes the
relationships between each componnent which include audio paths, GPIOs,
interrupts, clocking, jacks and voltage regulators.
---8<---

So, I think put this into machine driver will be better. Do you have any 
other idea? Or if I misunderstand something, please point it out.

Thanks.

Best Regards,
Bo Shen
