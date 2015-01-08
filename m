Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbbAHQkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:40:46 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:33180 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbbAHQko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:40:44 -0500
Date: Thu, 8 Jan 2015 17:42:57 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150108174257.557f7ea5@armhf>
In-Reply-To: <54AE99F5.1010404@ti.com>
References: <cover.1420628786.git.moinejf@free.fr>
	<0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
	<54AE99F5.1010404@ti.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015 16:53:41 +0200
Jyri Sarha <jsarha@ti.com> wrote:

> > +  - audio-ports: must contain one or two values selecting the source
> > +	in the audio port.
> > +	The source type is given by the corresponding entry in
> > +	the audio-port-names property.
> > +  
> 
> This binding does not allow multi channel i2s setups with multiple i2s 
> pins. It would be nice to support that in the DT binding, even if the 
> code is not yet ready for it.
> 
> How about having these two optional properties instead of audio-ports 
> and audio-port-names:
> 
> audio-port-i2s: Upto 4 values for selecting pins for i2s port
> audio-port-spdif: Value for selecting input pin for spdif port
> 
> Presence of one of the properties would be mandatory and both are allowed.
> 
> Sorry to notice this only now, but I have not yet looked the drm side 
> changes too closely.

>From Andrew's datasheet, the TDA998x's which are handled by the tda998x
driver have only 4 input audio pins, the first two ones being either
S/PDIF or I2s, the last ones being I2S only.

So, the DT description could be reduced to a simple list indexed by
the pin number (= DAI number) and defining the protocol type.

Examples:

- for the Cubox:

	audio-inputs = "i2s", "spdif";

- for some other board with I2S on the pins 3 and 4 only:

	audio-inputs = "none", "none", "i2s", "i2s";

- for a fully wired TDA9983B (no driver yet):

	audio-inputs = "i2s", "i2s", "i2s", "i2s", "spdif";

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
