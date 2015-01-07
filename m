Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbbAGPl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:41:58 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49911 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753354AbbAGPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:41:56 -0500
Date: Wed, 7 Jan 2015 15:41:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20150107154138.GL12302@n2100.arm.linux.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
 <54AD4C77.5000401@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD4C77.5000401@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:10:47PM +0000, Andrew Jackson wrote:
> On 01/07/15 10:51, Jean-Francois Moine wrote:
> > diff --git a/drivers/gpu/drm/i2c/Kconfig b/drivers/gpu/drm/i2c/Kconfig
> > index 22c7ed6..24fc975 100644
> > --- a/drivers/gpu/drm/i2c/Kconfig
> > +++ b/drivers/gpu/drm/i2c/Kconfig
> > @@ -28,6 +28,7 @@ config DRM_I2C_SIL164
> >  config DRM_I2C_NXP_TDA998X
> >         tristate "NXP Semiconductors TDA998X HDMI encoder"
> >         default m if DRM_TILCDC
> > +       select SND_SOC_TDA998X
> 
> Do you need this since sound/soc/codecs/Kconfig conditionally brings in the
> CODEC driver?

More importantly, it's broken, because it'll cause Kconfig to complain
if you enable DRM_I2C_NXP_TDA998X, but have ASoC disabled.

Moreover, if you decide you want the sound and ASoC built as a module,
but want to build in DRM and TDA998x support (so you can get video
output working on boot before initramfs/rootfs), Kconfig may well
complain.

> > +static int __init tda998x_codec_init(void)
> > +{
> > +       return 0;
> > +}
> > +static void __exit tda998x_codec_exit(void)
> > +{
> > +}
> > +module_init(tda998x_codec_init);
> > +module_exit(tda998x_codec_exit);

There's no need for these if they remain as the above.  Modules can have
both init/exit functions, or neither, and they are still unloadable.
Only modules which provide only an init function get locked in on load.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
