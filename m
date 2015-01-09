Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbbAIMvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:51:55 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:28036 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbbAIMvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:51:54 -0500
Date: Fri, 9 Jan 2015 13:54:01 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jyri Sarha <jsarha@ti.com>, Mark Brown <broonie@kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150109135401.5b270d46@armhf>
In-Reply-To: <20150109114529.GH12302@n2100.arm.linux.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
	<0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
	<54AE99F5.1010404@ti.com>
	<20150108174257.557f7ea5@armhf>
	<54AFA9B0.6040405@ti.com>
	<20150109123036.4bc4bbf6@armhf>
	<20150109114529.GH12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 11:45:29 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Jan 09, 2015 at 12:30:36PM +0100, Jean-Francois Moine wrote:
> > In my original version, the audio-ports are a bitmap of the pins, the
> > bit 0 being the WS used for I2S. A fully wired tda998x would have been
> > as:
> > 
> > 	audio-ports = <0x03>, <0x04>, <0x09>, <0x11>;
> > 	audio-port-names = "i2s", "spdif", "i2s", "i2s";
> > 
> > With the new version, it would simply become:
> > 
> > 	audio-inputs = "i2s", "spdif", "i2s", "i2s";
> 
> How do you know which i2s inputs to enable?
> 
> Does it make sense for the audio inputs to be mixed like that?
> 
> You will need to enable one i2s for front L+R, and increasingly others
> for the additional channels.
> 
> I think we need to understand exactly how the 998x map I2S inputs to the
> HDMI channels to avoid making a mistake with the binding; remember, the
> binding isn't something that can be easily "bug fixed" at a later date
> as anything we come up with now has to be supported long term by the
> kernel.

The DT describes the hardware configuration.

A fully wired tda998x could be a chip with the audio pins connected to:
- a kirkwood-like audio device with one I2S and one S/PDIF output,
- two other audio devices with one I2S each.

The relation between an audio device and the associated pin is done by
the definition of the sound card.

With S/PDIF, only one stereo channel may be sent, but with I2S, up to 4
stereo channels may be sent. These channels are extracted by the
devices connected on the HDMI bus. There is no mixing.
An example could be the playing of a multi-language movie: each audio
channel carries one language. From the computer view, the playing
application sends each language to one sound card.

So, this means that the tda998x driver should check that S/PDIF and I2S
are not active at the same time, and it should also do a pin OR/AND on
I2S start/stop.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
