Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbbAILnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:43:16 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:35128 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096AbbAILnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:43:15 -0500
Date: Fri, 9 Jan 2015 12:45:31 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jyri Sarha <jsarha@ti.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI
 transmitter
Message-ID: <20150109124531.493bece4@armhf>
In-Reply-To: <20150109111935.GF12302@n2100.arm.linux.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
	<23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
	<54AD4C77.5000401@arm.com>
	<20150107154138.GL12302@n2100.arm.linux.org.uk>
	<20150107190241.27ebac8b@armhf>
	<54AFAC4C.7010209@ti.com>
	<20150109111935.GF12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 11:19:35 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Would it be more sensible to make SND_SOC_TDA998X depend on
> DRM_I2C_NXP_TDA998X instead, maybe with a 'default y' - which is a
> kinder way to have SND_SOC_TDA998X be enabled.  If SND_SOC_TDA998X
> doesn't have a prompt, then it'll automatically enable itself too
> this way when all its dependencies are satisfied.

You are right, I will set back the way I had in the version 3:

> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
> index b33b45d..747e387 100644
> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -352,6 +352,12 @@ config SND_SOC_STAC9766
>  config SND_SOC_TAS5086
>  	tristate
>  
> +config SND_SOC_TDA998X
> +	tristate
> +	default y if DRM_I2C_NXP_TDA998X=y
> +	default m if DRM_I2C_NXP_TDA998X=m
> +

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
