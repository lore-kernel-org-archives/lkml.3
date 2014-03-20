Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaCTCil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:38:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:29235 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaCTCik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:38:40 -0400
Message-ID: <532A5481.6000008@atmel.com>
Date: Thu, 20 Mar 2014 10:37:53 +0800
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
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-8-git-send-email-voice.shen@atmel.com> <20140317115518.GD11706@sirena.org.uk> <532931C3.4080909@atmel.com> <20140319102800.GW11706@sirena.org.uk>
In-Reply-To: <20140319102800.GW11706@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 03/19/2014 06:28 PM, Mark Brown wrote:
> On Wed, Mar 19, 2014 at 01:57:23PM +0800, Bo Shen wrote:
>> On 03/17/2014 07:55 PM, Mark Brown wrote:
>
>>> If this is a clock for the CODEC it should be documented as part of the
>>> binding for the CODEC and connected to the CODEC in the device tree
>>> rather than being part of a machine driver binding.
>
>> This is a optional clock for CODEC which depends on hardware design. There
>> are 3 options for this clock, wm8904 as an example.
>> 1. Using internal FLL, so won't use this clock.
>> 2. Using external oscillator, no need to retrieve this clock.
>> 3. Using SoC provide this clock (we use this case).
>
>> After considering these 3 options, if we put this into CODEC driver to do
>> it, I think it will be more complicate to do logic judgement. Do you think
>> so?
>
> There shouldn't be any meaningful complexity from the above cases -
> cases 2 and 3 are the same and if the clock isn't used at all then it
> can be omitted.  If the FLL is clocked from MCLK then the CODEC driver
> should be able to work out how to configure it easily, the device isn't
> like a digital hub CODEC with lots of clocking options.

For this, in my mind, I think we need add following parameters in DT.
1. sysclk_src_from_fll --> we need do nothing.
2. sysclk_src_from_mclk
    2.1 use_external_xtal --> we need clock_frequency
    2.2 !use_external_xtal --> we need retrieve clock and clock_frequency.

So, the dt may looks like:
for case 1:
wm8904: wm8904@1a {
	reg = <0x1a>;
	sysclk_src_from_fll;
}

for case 2.1:
wm8904: wm8904@1a {
	reg = <0x1a>;
	sysclk_src_from_mclk;
	use_external_xtal;
	clock_frequency = 12000000;
}

for case 2.2:
wm8904: wm8904@1a {
	reg = <0x1a>;
	sysclk_src_from_mclk;
	clocks = <&pck0>;
	clock-names = "mclk";
	clock_frequency = 32768;
}

Does this acceptable? Or any other better suggestion for this?

Best Regards,
Bo Shen

