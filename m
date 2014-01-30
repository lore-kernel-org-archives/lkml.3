Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaA3VC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:02:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33062 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaA3VCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:02:25 -0500
Date: Thu, 30 Jan 2014 21:02:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140130210208.GY22609@sirena.org.uk>
References: <cover.1391081933.git.moinejf@free.fr>
 <c638b6622f4e059987f075091716a2305217ee49.1391081934.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/mvwczta11gu4fnM"
Content-Disposition: inline
In-Reply-To: <c638b6622f4e059987f075091716a2305217ee49.1391081934.git.moinejf@free.fr>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/5] ASoC: tda998x: add a codec driver for TDA998x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/mvwczta11gu4fnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 07:45:36PM +0100, Jean-Francois Moine wrote:

> +static void tda_get_encoder(struct tda_priv *priv)
> +{
> +	struct snd_soc_codec *codec = priv->codec;
> +	struct device_node *np;
> +	struct i2c_client *i2c_client;
> +	static const struct of_device_id tda_dt[] = {
> +		{ .compatible = "nxp,tda998x" },
> +		{ },
> +	};
> +
> +	/* search the tda998x device */
> +	np = of_find_matching_node_and_match(NULL, tda_dt, NULL);
> +	if (!np || !of_device_is_available(np)) {
> +		dev_err(codec->dev, "No tda998x in DT\n");
> +		return;
> +	}
> +	i2c_client = of_find_i2c_device_by_node(np);

Like I said last time I'd really expect this to look like a MFD (or
generally a proper CODEC driver) so we don't get this weird probe
ordering stuff.  If you don't think that's sensible for some reason it'd
be helpful to understand why.

--/mvwczta11gu4fnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6r3MAAoJELSic+t+oim9lY0QAJU8vB/4fcWMhQXll+Ijq1u1
eVfno44p3qAB8Glfvguzc6G5/bvh5ue2VYqSBXX7GUlhXsiQwdaSCs/47o/3rE84
cSMAYFPjSQepcWsWYVfGYMTa5M0+9sddaOYjlLC3TjtMqWyK/zIDD00xZVcESCex
RkAI1Xt5/RwFB0G6tI7q5f4mr4pw0OLpxEyomHHu8gdMOhF5WN5sFibJATBdCT9+
VxzhAJqZmII5Bw4yClzsTxAYZWmzeuNBwRS4JTIa3WRqUxYmiokrDUt1zamV5xLn
BF1014J3wG4uG5KseH7p1whIU+tXE5r8Ms3hODdg33ai4Cfp5Upjva//KiFaxcG1
A8PBllGHbqeM3Bntv23KmIqBovtayw1l8UCnG4wM/zFP4rsf3ET0EcqYzp0BZ96f
07bg1CVYi31JYrYs/FN4YGDP9z73aZSWp0r7vZbDKz9wIrBYbs3hcHX+gN7YP4tE
yRq5wTapX6jqSUpmnJL3hEXflDJckuprP+6RzZNZfvpUjJklEW/OiR35E6rCovCh
aaSZf93EKbAnn4NNORGEq+J1xhQnA9cQ4HczSQmUBEoIh2GevcJFRox4K8UwjEhN
1oN24DN0xzpV2+AYoM5yz5hUUMQrFkdOsXWtbqjHET4FD0LoSJ0Cxiu2/M41dEVI
kI+sn6DgCrFLVNAoc/Ry
=R8Gs
-----END PGP SIGNATURE-----

--/mvwczta11gu4fnM--
