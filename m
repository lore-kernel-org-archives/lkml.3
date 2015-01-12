Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbbALMZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:25:45 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34195 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751054AbbALMZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:25:44 -0500
Date: Mon, 12 Jan 2015 12:25:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150112122527.GF12302@n2100.arm.linux.org.uk>
References: <54AFA9B0.6040405@ti.com>
 <20150109123036.4bc4bbf6@armhf>
 <20150109114529.GH12302@n2100.arm.linux.org.uk>
 <20150109135401.5b270d46@armhf>
 <20150109130725.GN12302@n2100.arm.linux.org.uk>
 <54AFDE8D.3000504@arm.com>
 <20150109145741.GP12302@n2100.arm.linux.org.uk>
 <20150109183857.53d701a4@armhf>
 <20150109200127.GD12302@n2100.arm.linux.org.uk>
 <1421054728.3081.28.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421054728.3081.28.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:25:28AM +0100, Philipp Zabel wrote:
> Jean-Francois' reply already reflects this, but the 'port' nodes should
> correspond to physical ports of the device if possible. If you can
> configure the device to have dedicated input pins for I2S, SPDIF0, and
> SPDIF1 at the same time, they should appear in the device tree as
> separate ports:
> 
> tda998x: hdmi-encoder {
> 	port@0 { /* pixel data according to video-ports */
> 		reg = <0x00>;
> 	};
> 	port@1 { /* AP1: SPDIF0 */
> 		reg = <0x01>;
> 	};
> 	port@2 { /* AP2: SPDIF1 */
> 		reg = <0x02>;
> 	};
> 	port@3 { /* AP3: I2S */
> 		reg = <0x03>;
> 	};
> };
> 
> The tda998x binding would define how the ports are numbered, some
> correspondence to the AP pin numbers would be good.

It's not quite that simple, because the SPDIF AP pins are multiplexed
with the I2S pins - and there is variation between chip models and
packages.

So, it's probably best if port@0 is the video port, and then port@1..n
can describe the audio inputs, including a property which specifies
whether they are I2S or SPDIF, and the value to be programmed into
the AP enable register (which is a bit field of the AP pins which
should be unmasked.)  I guess we can re-use the reg= property for that
value, since video will always be zero.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
