Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3JCQOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:14:17 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:58583 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab3JCQOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:14:15 -0400
Date: Thu, 3 Oct 2013 18:17:16 +0200
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
Message-ID: <20131003181716.6d03d576@armhf>
In-Reply-To: <5246E747.6020103@gmail.com>
References: <20130828113521.35c53365@armhf>
	<521DCD80.9010105@gmail.com>
	<20130831125128.0e3a23c7@armhf>
	<140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com>
	<20130926101147.217015e1@armhf>
	<5243F0CE.9000301@gmail.com>
	<20130926132859.04ad4407@armhf>
	<5246E747.6020103@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep 2013 16:27:19 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> Jean-Francois,
> 
> I can confirm the following for CuBox:
> 
> AU1_EXTCLK is connected to si5351 clkout 2. For the _current_
> (v3.12-rc1) dove-cubox.dts that means that you'll have to exchange
> the properties for &i2c0/si5351/clkout[12]. If you leave it the way
> it is, clkout2 is not allowed to change the pll inside si5351 and
> only try to get close to the requested clk rate by using output
> dividers. Would be great if you can provide a corresponding patch
> for v3.12 (no need to Cc stable).
> 
> Also, as you seem to push kirkwood-i2s DT forward, please get back
> to clkout2 (<&si5351 2>) for the audio node as you did correctly in
> the first place.
> 
> With above changes, SPDIF_EN, and forcing kirkwood-i2s to always use
> extclk, I can play SPDIF audio with 44k1 and 48k. Other rates could
> also work, but my audio equipment ignores anything else.

Sebastian,

Thanks for your change. I can now get audio at 44.1, 32 and 22.05 kHz
on HDMI with the external clock (via i2s, but s/pdif and other rates
should work too).

	[snip]
> What I am wondering here is, why you want to use i2s at all? On CuBox,
> HDMI transmitter is connected to both i2s and spdif. IIRC, for the
> transmitter it makes no difference if you provide i2s or spdif audio,
> _but_ what you are loosing for sure is pass-through, i.e. sending
> compressed AC3 directly.
	[snip]

It seems that my patch about adding s/pdif to the kirkwood audio driver
has not been accepted yet...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
