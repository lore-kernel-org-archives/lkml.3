Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3HBKSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:18:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60358 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3HBKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:18:48 -0400
Date: Fri, 2 Aug 2013 11:18:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130802101824.GL9858@sirena.org.uk>
References: <1375431557-3096-1-git-send-email-zonque@gmail.com>
 <1375431557-3096-3-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HfXaGcT2/He5E1S"
Content-Disposition: inline
In-Reply-To: <1375431557-3096-3-git-send-email-zonque@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulators: max8660: add DT bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HfXaGcT2/He5E1S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 02, 2013 at 10:19:17AM +0200, Daniel Mack wrote:

> +Required properties:
> +- compatible: must be equal to "maxim,max8660"

This...

> +#ifdef CONFIG_OF
> +static const struct of_device_id max8660_dt_ids[] = {
> +	{ .compatible = "maxim,max8660", .data = (void *) MAX8660 },
> +	{ .compatible = "maxim,max8661", .data = (void *) MAX8661 },

...and this don't match up.

>  struct max8660_subdev_data {
>  	int				id;
> -	char				*name;
> +	const char			*name;
>  	struct regulator_init_data	*platform_data;
> +	struct device_node		*of_node;
>  };

Can't you just pass the of_node around while you need it?  Not that it
makes a big difference.

Otherwise looks good.

--+HfXaGcT2/He5E1S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+4dtAAoJELSic+t+oim9YE0P/AuMr8Ss9rqoQL4A7w/X7m2i
JE8zwWkZ3S6Q2ebGkUO4GTQiWapw7TsaY4nCw3rZckV5hhFT6REJQ9Afan5hQo9Y
8ow4qo77UIZxs0eQHwxRwLeTXETEdi50HP1khM35bXXczKjcqDWUpl5vzLOFx8/P
U8lXVHRkV3Xtz9ZHP31mg1PNQ/pi9+QxqOeQwQd6Ufg/spFg1AUjQCTyRoz/Hzzk
6yBO0Cbdr6MopZ3XYTrK5YsDyY/ltpCJhr31X1L/4o1t14+wNT8Kmg7jky2N7jpg
tOJdUIra4DqXluej6ZRQc8Ni8YCBYhvqhqVzni6S3Bb3Dmothlx1WO4MiTU+ZTHj
JT797fToa/s2TSWSTZrgQ9otE3WNlf11jaYrh99FEbnYzvrqxAD/SQ8e64DwlvvU
dEJlXfW/ISrFUkdmrI9l8IcvHCf/aq8f02QXSoi53or6cPtO//esEiS4O3mMyYTP
USCITIgL4Flknv2lfk1Zch0v/nK0FfVPriq7z+ZF6LLO0+Ls4cuGD+5dOl50hsge
4/LsPHvzme+0yTly2G+ageMCvsGdvVrXOb4cHfuJ6TUqYir0Cxun0j1u80hF7FTU
cGDK7J3/dMDZEMZEsGOE5rxyxMuWuOc+XY8gchialuqY0X4jt1/bw6tQhQ9ZiafB
57O++t8z/zvLr65pu15j
=gn7I
-----END PGP SIGNATURE-----

--+HfXaGcT2/He5E1S--
