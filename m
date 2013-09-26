Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3IZIJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:09:39 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:46280 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab3IZIJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:09:33 -0400
Date: Thu, 26 Sep 2013 10:11:47 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Message-ID: <20130926101147.217015e1@armhf>
In-Reply-To: <140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com>
References: <20130828113521.35c53365@armhf>
	<521DCD80.9010105@gmail.com>
	<20130831125128.0e3a23c7@armhf>
	<140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Sep 2013 11:26:54 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> Jean-Francois,
> Sorry for the messy reply, posting from mobile.
> 
> Can you please try <&si5351 1>, iirc audio ist connected to it. I will also 
> look it up later.

Sebastian,

In the Cubox, I changed the audio DT to:

&i2s1 {
	status = "okay";
	clocks = <&gate_clk 13>, <&si5351 1>;
	clock-names = "internal", "extclk";
	pinctrl-0 = <&pmx_audio1_i2s1_spdifo &pmx_gpio_13_audio1>;
};

and the sound does not get out correctly.

There is no sound at all, except when restarting playing which gives
some shrill sound for half a second at start time.

I lowered the rate in kirkwood-i2s, setting the clock by (* 128)
instead of (* 256), and, most of the time, this gives continuous shrill
and chopped sound at various sample rates (22.05, 32 and 44.1 kHz).
Lowering the clock to (* 64) gives no sound at all.

For more information, I use i2s input in the tda998x with audio rate
96kHz on HDMI output. The sound is fine with the internal dco (tested
with 44.1kHz only).

Some idea?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
