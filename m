Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbbAMTDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:03:12 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:5987 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbbAMTDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:03:10 -0500
Date: Tue, 13 Jan 2015 20:02:52 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150113200252.3dbfab14@armhf>
In-Reply-To: <20150113160313.GR12302@n2100.arm.linux.org.uk>
References: <20150109200127.GD12302@n2100.arm.linux.org.uk>
	<1421054728.3081.28.camel@pengutronix.de>
	<20150112122527.GF12302@n2100.arm.linux.org.uk>
	<1421071197.3081.44.camel@pengutronix.de>
	<20150112140456.GI12302@n2100.arm.linux.org.uk>
	<20150112181341.4a53ea24@armhf>
	<20150112175705.GN12302@n2100.arm.linux.org.uk>
	<1421151718.4519.24.camel@pengutronix.de>
	<20150113122715.GP12302@n2100.arm.linux.org.uk>
	<20150113165411.5469930d@armhf>
	<20150113160313.GR12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 16:03:13 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Tue, Jan 13, 2015 at 04:54:11PM +0100, Jean-Francois Moine wrote:
> > 4 streams on 4 different APs (sources) should work, but 4 streams from
> > a same source should be detailed.
> 
> I'd like to know how you intend to wire up four different I2S sources
> to the TDA998x.
> 
> Remember, an I2S source produces the I2S data and the word clock - that's
> two outputs.  You can't electronically wire the word clocks together.

>From the spec, the tda998x gets independently the serial clock and the
serial word select from each I2S (stereo) input channel (= audio pin),
so, you may have 4 audio chips giving 4 independent audio streams.
I don't know what can be the result in HDMI if these streams are actived
at the same time!

In the other configuration, an audio chip may have 4 synchronized stereo
channels (software PCMs). These ones may be considered as one link (one
port out from the audio chip to one port in to the tda998x), the AP
configuration being 0x1f.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
