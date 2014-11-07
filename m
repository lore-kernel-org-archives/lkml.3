Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaKGQV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:21:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49661 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaKGQV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:21:28 -0500
Date: Fri, 7 Nov 2014 15:07:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141107150743.GR8509@sirena.org.uk>
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415365205-27630-4-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ji10MhcQ4llII8Lj"
Content-Disposition: inline
In-Reply-To: <1415365205-27630-4-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 3/5] regulator: of: Add regulator desc param to
 of_get_regulator_init_data()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ji10MhcQ4llII8Lj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2014 at 02:00:03PM +0100, Javier Martinez Canillas wrote:

> -	initdata =3D of_get_regulator_init_data(dev, np);
>  	sreg =3D devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
>  	if (!sreg)
>  		return -ENOMEM;
> -	sreg->initdata =3D initdata;
>  	sreg->name =3D of_get_property(np, "regulator-name", NULL);
>  	rdesc =3D &sreg->rdesc;
> +	initdata =3D of_get_regulator_init_data(dev, np, rdesc);
> +	sreg->initdata =3D initdata;
>  	rdesc->name =3D sreg->name;
>  	rdesc->type =3D REGULATOR_VOLTAGE;
>  	rdesc->owner =3D THIS_MODULE;

This is using the regulator descriptor before it is initialized which
doesn't seem ideal...

> +++ b/include/linux/regulator/of_regulator.h
> @@ -6,6 +6,8 @@
>  #ifndef __LINUX_OF_REG_H
>  #define __LINUX_OF_REG_H
> =20
> +#include <linux/regulator/driver.h>
> +
>  struct of_regulator_match {
>  	const char *name;
>  	void *driver_data;
> @@ -16,14 +18,16 @@ struct of_regulator_match {
>  #if defined(CONFIG_OF)
>  extern struct regulator_init_data
>  	*of_get_regulator_init_data(struct device *dev,
> -				    struct device_node *node);
> +				    struct device_node *node,
> +				    const struct regulator_desc *desc);

This is just adding the include to get the declaration of regulator_desc
as far as I can see, add a forward declaration of it instead.

--ji10MhcQ4llII8Lj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXOA+AAoJECTWi3JdVIfQym0H/A0rtJd8H5YsHQ7oraSjw6d3
A2sqYgqaQgLMQEebo0uv4LNEsWyAjAU2T5nEMqPNl7r0aJN9TgJyLPGinwFtghW6
HiM+7qsXrtteJ/NwATIcg/kVjlMSxW/8pO515jxBSWMogOflO2W8ySwjpR1/COTj
mw0OKgzmt4b2by90nutp4RrwNC2lDLMRjuTw9SnK+zDuUGhSqKQMvDTw3rtiqNWT
CVZNu8QkcAll0qEPK7/sEYl001GVjV+lV4RtdaMhjZCRZWXoyfgbBJNUGxwrWMy4
zj0vYyb7bpqyM9/C5ZCAAFxKkhgevVAPNmNcanDApAqK0d1yIXwS/yuWn1cbzwI=
=f0Zj
-----END PGP SIGNATURE-----

--ji10MhcQ4llII8Lj--
