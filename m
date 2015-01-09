Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbbAIL2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:28:30 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:55828 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbbAIL22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:28:28 -0500
Date: Fri, 9 Jan 2015 12:30:36 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150109123036.4bc4bbf6@armhf>
In-Reply-To: <54AFA9B0.6040405@ti.com>
References: <cover.1420628786.git.moinejf@free.fr>
	<0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
	<54AE99F5.1010404@ti.com>
	<20150108174257.557f7ea5@armhf>
	<54AFA9B0.6040405@ti.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 12:13:04 +0200
Jyri Sarha <jsarha@ti.com> wrote:

> On 01/08/2015 06:42 PM, Jean-Francois Moine wrote:
> >  From Andrew's datasheet, the TDA998x's which are handled by the tda998x
> > driver have only 4 input audio pins, the first two ones being either
> > S/PDIF or I2s, the last ones being I2S only.
> 
> AFAIK, SPDIF is always a single pin connection so only one pin needs to 
> be selected. But i2s need for pins for full 8 channel output.

There are 2 possible S/PDIF pins in the tda998x, and there may be many
audio chips with S/PDIF outputs.

> > So, the DT description could be reduced to a simple list indexed by
> > the pin number (= DAI number) and defining the protocol type.
> >
> > Examples:
> >
> > - for the Cubox:
> >
> > 	audio-inputs = "i2s", "spdif";
> >
> > - for some other board with I2S on the pins 3 and 4 only:
> >
> > 	audio-inputs = "none", "none", "i2s", "i2s";
> >
> > - for a fully wired TDA9983B (no driver yet):
> >
> > 	audio-inputs = "i2s", "i2s", "i2s", "i2s", "spdif";
> >
> 
> If you want to go closer to the original paradigm, then how about 
> defining following audio-port-names: i2s0, i2s1, i2s2, i2s3, and spdif. 
> With this approach we could go with your original binding with only 
> minor changes. A binding in your stereo i2s or spdif case would look 
> like this:
> 
> 	audio-ports = <0x04>, <0x03>;
> 	audio-port-names = "spdif", "i2s0";
> 
> A full 8 channel i2s or spdif output would look like this:
> 
> 	audio-ports = <0x04>, <0x03>, <0x02>, <0x01>, <0x00>;
> 	audio-port-names = "spdif", "i2s0", "i2s1", "i2s2", "i2s3";
> 
> This would also indicate the channel mapping to the audio pins (i2s0 for 
> first two channels, i2s1 for 3-4, etc.)
> 
> The code could for now just look for "i2s0" and the port names for 
> channels 3-8 could be ignored until they are needed.

In my original version, the audio-ports are a bitmap of the pins, the
bit 0 being the WS used for I2S. A fully wired tda998x would have been
as:

	audio-ports = <0x03>, <0x04>, <0x09>, <0x11>;
	audio-port-names = "i2s", "spdif", "i2s", "i2s";

With the new version, it would simply become:

	audio-inputs = "i2s", "spdif", "i2s", "i2s";

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
