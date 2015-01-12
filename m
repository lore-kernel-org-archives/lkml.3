Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbbALOFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:05:16 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34426 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751879AbbALOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:05:13 -0500
Date: Mon, 12 Jan 2015 14:04:56 +0000
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
Message-ID: <20150112140456.GI12302@n2100.arm.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421071197.3081.44.camel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 02:59:57PM +0100, Philipp Zabel wrote:
> Am Montag, den 12.01.2015, 12:25 +0000 schrieb Russell King - ARM Linux:
> > It's not quite that simple, because the SPDIF AP pins are multiplexed
> > with the I2S pins - and there is variation between chip models and
> > packages.
> >
> > So, it's probably best if port@0 is the video port, and then port@1..n
> > can describe the audio inputs, including a property which specifies
> > whether they are I2S or SPDIF, and the value to be programmed into
> > the AP enable register (which is a bit field of the AP pins which
> > should be unmasked.)  I guess we can re-use the reg= property for that
> > value, since video will always be zero.
> 
> Note that of_graph_parse_endpoint interprets the port node's reg
> property as port id. And the unit address part of the node name should
> match the first address in the reg property.

So that's not going to work very well... because the AP register is a
bitmask.

I guess we could specify a node unit and reg, which the code otherwise
ignores, and specify a philipps,ap-mask = property for the audio ports
instead.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
