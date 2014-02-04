Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaBDNai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:30:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35182 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaBDNaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:30:35 -0500
Date: Tue, 4 Feb 2014 13:30:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140204133014.GA22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <ae68394f080f0ea5acaf3377cb1d18f29e42c646.1391274628.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y3YVtFU9bcHhbVJF"
Content-Disposition: inline
In-Reply-To: <ae68394f080f0ea5acaf3377cb1d18f29e42c646.1391274628.git.moinejf@free.fr>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] ASoC: tda998x: add a codec driver for the TDA998x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y3YVtFU9bcHhbVJF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 07:45:36PM +0100, Jean-Francois Moine wrote:

> +	/* load the optional CODEC */
> +	of_platform_populate(np, NULL, NULL, &client->dev);
> +

Why is this using of_platform_populate()?  That's a very odd way of
doing things.

> +config SND_SOC_TDA998X
> +	tristate
> +	depends on OF
> +	default y if DRM_I2C_NXP_TDA998X=y
> +	default m if DRM_I2C_NXP_TDA998X=m
> +

Make this visible if it can be selected from DT so it can be used with
generic cards.

> +static int tda_get_encoder(struct tda_priv *priv)
> +{
> +	struct snd_soc_codec *codec = priv->codec;
> +	struct device_node *np;
> +
> +	/* get the parent tda998x device */
> +	np = of_get_parent(codec->dev->of_node);
> +	if (!np || !of_device_is_compatible(np, "nxp,tda998x")) {
> +		dev_err(codec->dev, "no or bad parent!\n");
> +		return -EINVAL;
> +	}
> +	priv->i2c_client = of_find_i2c_device_by_node(np);
> +	of_node_put(np);
> +	return 0;
> +}

Why does this need to be checked like this?  We don't normally have this
sort of code to check that the parent is correct.

> +static int tda_start_stop(struct tda_priv *priv)
> +{
> +	int port;
> +
> +	/* give the audio parameters to the HDMI encoder */
> +	if (priv->dai_id == AFMT_I2S)
> +		port = priv->ports[0];
> +	else
> +		port = priv->ports[1];
> +	tda998x_audio_update(priv->i2c_client, priv->dai_id, port);
> +	return 0;
> +}

What does this actually do?  No information is being passed in to the
core function here, not even any information on if it's starting or
stopping.  Looking at the rest of the code I can't help thinking it
might be clearer to inline this possibly with a lookup helper, the code
is very small and the lack of parameters makes it hard to follow.

> +static const struct snd_soc_dapm_route tda_routes[] = {
> +	{ "hdmi-out", NULL, "HDMI I2S Playback" },
> +	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
> +};

S/PDIF.

--Y3YVtFU9bcHhbVJF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8OtjAAoJELSic+t+oim9bs4P/iJT+6VOJ9QSnwm/m8U0RIUS
qfim/SCriTfqXoxC+fDD/VoDzP4a/hh6zUDLkjP3Unmq9oy+NyKtH0f4K5mIyXxW
USgrkQho80hUtZhQzIKsmWtadwNyjFPTIB6N/XiphUhvROuLxHQP/0zHBjN93v4o
FWAr2H5Y6scjT/JGewS+IiUsSieMQVG0EblyQjsot9CTCwJTjOoEfq7lWBQIyhpe
ygf9vFtDRnbwsOH+Y/wF0TmJFHeJdHvuWymahUtKtlWl0yV3A/QYfCpifis6iedh
Maf9YAEFThLuwoZbZMnQY5fdkh46HtAZoNXaqBHq8qSo2aqVOkVPKsmeLtHqPqf8
JF66+54Tjw6pbv+1eDIy6AClZiin8Fr0BcKsCo6VMfNFOnQsMB57mzACc4M4WfgZ
DCQvj16bzSQzWKkBB+HKr3Lx4VxcZ0Y+04jS3HoJl6Ka2GXBsgqCDi7K+Z2gmlm8
Sb8sQPPm+FrmebYYtn1yI8qeraqpj+NGisxiNYx8j4NF/NqfszYFZemFW/JiFPpJ
KyzrYSbl4UaZawGbHoi/nV0PkjYDdhOdC6FJvCUFGIETXr9JE76LtxSkQ/RCf+xD
qZp+Gp4D4ELVOqfqUTQjioNpJgFUW1Z/+kCL03YI3WY+ojz3h3MBsIHiM4o8zbb6
hv9jTbckAjn5LAV8GiT0
=TKAW
-----END PGP SIGNATURE-----

--Y3YVtFU9bcHhbVJF--
