Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbbALRLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:11:43 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:59128 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbbALRLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:11:40 -0500
Date: Mon, 12 Jan 2015 18:13:41 +0100
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
Message-ID: <20150112181341.4a53ea24@armhf>
In-Reply-To: <20150112140456.GI12302@n2100.arm.linux.org.uk>
References: <20150109114529.GH12302@n2100.arm.linux.org.uk>
	<20150109135401.5b270d46@armhf>
	<20150109130725.GN12302@n2100.arm.linux.org.uk>
	<54AFDE8D.3000504@arm.com>
	<20150109145741.GP12302@n2100.arm.linux.org.uk>
	<20150109183857.53d701a4@armhf>
	<20150109200127.GD12302@n2100.arm.linux.org.uk>
	<1421054728.3081.28.camel@pengutronix.de>
	<20150112122527.GF12302@n2100.arm.linux.org.uk>
	<1421071197.3081.44.camel@pengutronix.de>
	<20150112140456.GI12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 14:04:56 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Jan 12, 2015 at 02:59:57PM +0100, Philipp Zabel wrote:
> > Am Montag, den 12.01.2015, 12:25 +0000 schrieb Russell King - ARM Linux:
> > > It's not quite that simple, because the SPDIF AP pins are multiplexed
> > > with the I2S pins - and there is variation between chip models and
> > > packages.
> > >
> > > So, it's probably best if port@0 is the video port, and then port@1..n
> > > can describe the audio inputs, including a property which specifies
> > > whether they are I2S or SPDIF, and the value to be programmed into
> > > the AP enable register (which is a bit field of the AP pins which
> > > should be unmasked.)  I guess we can re-use the reg= property for that
> > > value, since video will always be zero.
> > 
> > Note that of_graph_parse_endpoint interprets the port node's reg
> > property as port id. And the unit address part of the node name should
> > match the first address in the reg property.

This is not the case in vexpress-v2p-ca15_a7.dts.

> So that's not going to work very well... because the AP register is a
> bitmask.
> 
> I guess we could specify a node unit and reg, which the code otherwise
> ignores, and specify a philipps,ap-mask = property for the audio ports
> instead.

Also, the video and audio ports must be distinguished. They could be
defined in different port groups.

Example from the Cubox:

	video-ports: ports@0 {
		port {
			tda998x_video: endpoint {
				remote-endpoint = <&lcd0_0>;
				nxp,video-port = <0x230145>;
			};
		};
	};
	audio-ports: ports@1 {
		port@0 {			/* AP1 = I2S */
			tda998x_i2s: endpoint@0 {
				remote-endpoint = <&audio1_i2s>;
				nxp,audio-port = <0x03>;
			};
		};
		port@1 {			 /* AP2 = S/PDIF */
			tda998x_spdif: endpoint@1 {
				remote-endpoint = <&audio1_spdif1>;
				nxp,audio-port = <0x04>;
			};
		};
	};

The port type is identified by the bit AP0.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
