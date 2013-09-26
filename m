Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3IZL0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:26:50 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:41106 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab3IZL0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:26:48 -0400
Date: Thu, 26 Sep 2013 13:28:59 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Message-ID: <20130926132859.04ad4407@armhf>
In-Reply-To: <5243F0CE.9000301@gmail.com>
References: <20130828113521.35c53365@armhf>
	<521DCD80.9010105@gmail.com>
	<20130831125128.0e3a23c7@armhf>
	<140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com>
	<20130926101147.217015e1@armhf>
	<5243F0CE.9000301@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013 10:31:10 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> On 09/26/2013 10:11 AM, Jean-Francois Moine wrote:
> > In the Cubox, I changed the audio DT to:
> >
> > &i2s1 {
> > 	status = "okay";
> > 	clocks = <&gate_clk 13>, <&si5351 1>;
> > 	clock-names = "internal", "extclk";
> > 	pinctrl-0 = <&pmx_audio1_i2s1_spdifo &pmx_gpio_13_audio1>;
> 
> Have you checked that pinmux was configured correctly?
> 
> You are missing a
> 
> pinctrl-names = "default";
> 
> to actually execute the above pinmux setting.

Thanks, the pinmux was not set correctly, and I added the "default".

	[snip]
> What about trying to get 48kHz working first? Does it work with
> internal DCO and 48kHz? External audio clock should be 256*fs as stated
> in dove datasheet.

I have no input with 48kHz.

> > For more information, I use i2s input in the tda998x with audio rate
> > 96kHz on HDMI output. The sound is fine with the internal dco (tested
> > with 44.1kHz only).
> 
> Sorry, I don't understand the above "information". How can you have a
> different input audio rate tested with 44k1 output rate?

The internal dco permits only 44.1, 44 and 96 kHz, so, vlc translates
the input rates smaller than 44.1 kHz to 44.1 kHz.

> Have you ever tested your audio equipment with something different than
> 48k and 44k1 SPDIF PCM? Are you actually sure it works at all, i.e. do
> you have different audio source with SPDIF >48kHz? Can you try optical
> SPDIF instead of HDMI?
> 
> Just try to narrow it down, currently I cannot see why this behavior
> should be limited to either si5351 or dove audio alone.

I have no optical S/PDIF.

Well, I did more tests:

- i2s or s/pdif input by the tda998x work fine with the internal dco

- the pinmux seems correct:

device f10b4000.audio-controller
state default
type MUX_GROUP (2)
controlling device f10d0200.pin-ctrl
group mpp_audio1
function i2s1/spdifo

device f10b4000.audio-controller
state default
type MUX_GROUP (2)
controlling device f10d0200.pin-ctrl
group mpp13
function audio1

- I tried both <&si5351 1> and <&si5351 2>, and I get no sound with the
  external clock.

- when running vlc with the external clock, the flux towards the
  kirkwood driver is blocked and there is no sound interrupt.

 47:          0  main-interrupt-ctrl  21  kirkwood-i2s

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
