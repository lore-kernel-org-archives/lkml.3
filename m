Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbbALOAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:00:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52940 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbALOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:00:14 -0500
Message-ID: <1421071197.3081.44.camel@pengutronix.de>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 12 Jan 2015 14:59:57 +0100
In-Reply-To: <20150112122527.GF12302@n2100.arm.linux.org.uk>
References: <54AFA9B0.6040405@ti.com> <20150109123036.4bc4bbf6@armhf>
	 <20150109114529.GH12302@n2100.arm.linux.org.uk>
	 <20150109135401.5b270d46@armhf>
	 <20150109130725.GN12302@n2100.arm.linux.org.uk> <54AFDE8D.3000504@arm.com>
	 <20150109145741.GP12302@n2100.arm.linux.org.uk>
	 <20150109183857.53d701a4@armhf>
	 <20150109200127.GD12302@n2100.arm.linux.org.uk>
	 <1421054728.3081.28.camel@pengutronix.de>
	 <20150112122527.GF12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 12.01.2015, 12:25 +0000 schrieb Russell King - ARM Linux:
> On Mon, Jan 12, 2015 at 10:25:28AM +0100, Philipp Zabel wrote:
> > Jean-Francois' reply already reflects this, but the 'port' nodes should
> > correspond to physical ports of the device if possible. If you can
> > configure the device to have dedicated input pins for I2S, SPDIF0, and
> > SPDIF1 at the same time, they should appear in the device tree as
> > separate ports:
> > 
> > tda998x: hdmi-encoder {
> > 	port@0 { /* pixel data according to video-ports */
> > 		reg = <0x00>;
> > 	};
> > 	port@1 { /* AP1: SPDIF0 */
> > 		reg = <0x01>;
> > 	};
> > 	port@2 { /* AP2: SPDIF1 */
> > 		reg = <0x02>;
> > 	};
> > 	port@3 { /* AP3: I2S */
> > 		reg = <0x03>;
> > 	};
> > };
> > 
> > The tda998x binding would define how the ports are numbered, some
> > correspondence to the AP pin numbers would be good.
> 
> It's not quite that simple, because the SPDIF AP pins are multiplexed
> with the I2S pins - and there is variation between chip models and
> packages.
>
> So, it's probably best if port@0 is the video port, and then port@1..n
> can describe the audio inputs, including a property which specifies
> whether they are I2S or SPDIF, and the value to be programmed into
> the AP enable register (which is a bit field of the AP pins which
> should be unmasked.)  I guess we can re-use the reg= property for that
> value, since video will always be zero.

Note that of_graph_parse_endpoint interprets the port node's reg
property as port id. And the unit address part of the node name should
match the first address in the reg property.

regards
Philipp

