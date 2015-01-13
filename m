Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbbAMPyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:54:32 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:40338 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbbAMPya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:54:30 -0500
Date: Tue, 13 Jan 2015 16:54:11 +0100
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
Message-ID: <20150113165411.5469930d@armhf>
In-Reply-To: <20150113122715.GP12302@n2100.arm.linux.org.uk>
References: <20150109145741.GP12302@n2100.arm.linux.org.uk>
	<20150109183857.53d701a4@armhf>
	<20150109200127.GD12302@n2100.arm.linux.org.uk>
	<1421054728.3081.28.camel@pengutronix.de>
	<20150112122527.GF12302@n2100.arm.linux.org.uk>
	<1421071197.3081.44.camel@pengutronix.de>
	<20150112140456.GI12302@n2100.arm.linux.org.uk>
	<20150112181341.4a53ea24@armhf>
	<20150112175705.GN12302@n2100.arm.linux.org.uk>
	<1421151718.4519.24.camel@pengutronix.de>
	<20150113122715.GP12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 12:27:15 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Tue, Jan 13, 2015 at 01:21:58PM +0100, Philipp Zabel wrote:
> > I wonder if it wouldn't be nicer to have the AP# and type in the device
> > tree and then calculate the register value from that in the driver.
> > 
> > 	port@1 {
> > 		reg = <1>; /* AP1 */
> > 		nxp,audio-port = "i2s";
> > 		tda998x_i2s: endpoint {
> > 			remote-endpoint = <&audio1_i2s>;
> > 		};
> > 	};
> 
> What about the case where we have 4 I2S streams being supplied to the
> device on four separate AP inputs?

4 streams on 4 different APs (sources) should work, but 4 streams from
a same source should be detailed.

In an other way, the unit address (== first reg) does not need to be a
sequence number. It is the I/O base in most DTs.
So, it could be the port value: 

	port@230145 {
		port-type = "rgb";
		reg = <0x230145>;
		hdmi_0: endpoint {
			remote-endpoint = <&lcd0_0>;
		};
	};
	port@3 {			/* AP1 = I2S */
		port-type = "i2s";
		reg = <0x03>;
		tda998x_i2s: endpoint {
			remote-endpoint = <&audio1_i2s>;
		};
	};
	port@4 {			 /* AP2 = S/PDIF */
		port-type = "spdif";
		reg = <0x04>;
		tda998x_spdif: endpoint {
			remote-endpoint = <&audio1_spdif1>;
		};
	};

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
