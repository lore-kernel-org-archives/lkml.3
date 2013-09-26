Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3IZIbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:31:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45723 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3IZIbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:31:17 -0400
Message-ID: <5243F0CE.9000301@gmail.com>
Date: Thu, 26 Sep 2013 10:31:10 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
References: <20130828113521.35c53365@armhf> <521DCD80.9010105@gmail.com> <20130831125128.0e3a23c7@armhf> <140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com> <20130926101147.217015e1@armhf>
In-Reply-To: <20130926101147.217015e1@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 10:11 AM, Jean-Francois Moine wrote:
> In the Cubox, I changed the audio DT to:
>
> &i2s1 {
> 	status = "okay";
> 	clocks = <&gate_clk 13>, <&si5351 1>;
> 	clock-names = "internal", "extclk";
> 	pinctrl-0 = <&pmx_audio1_i2s1_spdifo &pmx_gpio_13_audio1>;

Have you checked that pinmux was configured correctly?

You are missing a

pinctrl-names = "default";

to actually execute the above pinmux setting.

> };
>
> and the sound does not get out correctly.
>
> There is no sound at all, except when restarting playing which gives
> some shrill sound for half a second at start time.

Could be clock setup stability issues on si5351. Will check that later
with a scope, maybe I also check spdif output rate with it too.

> I lowered the rate in kirkwood-i2s, setting the clock by (* 128)
> instead of (* 256), and, most of the time, this gives continuous shrill
> and chopped sound at various sample rates (22.05, 32 and 44.1 kHz).
> Lowering the clock to (* 64) gives no sound at all.

What about trying to get 48kHz working first? Does it work with
internal DCO and 48kHz? External audio clock should be 256*fs as stated
in dove datasheet.

> For more information, I use i2s input in the tda998x with audio rate
> 96kHz on HDMI output. The sound is fine with the internal dco (tested
> with 44.1kHz only).

Sorry, I don't understand the above "information". How can you have a
different input audio rate tested with 44k1 output rate?

> Some idea?

Have you ever tested your audio equipment with something different than
48k and 44k1 SPDIF PCM? Are you actually sure it works at all, i.e. do
you have different audio source with SPDIF >48kHz? Can you try optical
SPDIF instead of HDMI?

Just try to narrow it down, currently I cannot see why this behavior
should be limited to either si5351 or dove audio alone.

Sebastian
