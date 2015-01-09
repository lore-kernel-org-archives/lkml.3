Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbbAILs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:48:26 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55103 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756419AbbAILsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:48:24 -0500
Date: Fri, 9 Jan 2015 11:48:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jyri Sarha <jsarha@ti.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20150109114812.GI12302@n2100.arm.linux.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
 <54AD4C77.5000401@arm.com>
 <20150107154138.GL12302@n2100.arm.linux.org.uk>
 <20150107190241.27ebac8b@armhf>
 <54AFAC4C.7010209@ti.com>
 <20150109111935.GF12302@n2100.arm.linux.org.uk>
 <20150109124531.493bece4@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109124531.493bece4@armhf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 12:45:31PM +0100, Jean-Francois Moine wrote:
> On Fri, 9 Jan 2015 11:19:35 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > Would it be more sensible to make SND_SOC_TDA998X depend on
> > DRM_I2C_NXP_TDA998X instead, maybe with a 'default y' - which is a
> > kinder way to have SND_SOC_TDA998X be enabled.  If SND_SOC_TDA998X
> > doesn't have a prompt, then it'll automatically enable itself too
> > this way when all its dependencies are satisfied.
> 
> You are right, I will set back the way I had in the version 3:
> 
> > diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
> > index b33b45d..747e387 100644
> > --- a/sound/soc/codecs/Kconfig
> > +++ b/sound/soc/codecs/Kconfig
> > @@ -352,6 +352,12 @@ config SND_SOC_STAC9766
> >  config SND_SOC_TAS5086
> >  	tristate
> >  
> > +config SND_SOC_TDA998X
> > +	tristate
> > +	default y if DRM_I2C_NXP_TDA998X=y
> > +	default m if DRM_I2C_NXP_TDA998X=m
> > +

An easier way to write this is:

	config SND_SOC_TDA998X
		def_tristate y
		depends on DRM_I2C_NXP_TDA998X

That's because internally, Kconfig knows how to do ternary operations.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
