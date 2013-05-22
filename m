Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3EVQO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:14:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59489 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3EVQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:14:57 -0400
Date: Wed, 22 May 2013 11:14:22 -0500
From: Mark Brown <broonie@kernel.org>
To: yizhang.mrvl@gmail.com
Cc: lgirdwood@gmail.com, cxie4@marvell.com, jett.zhou@marvell.com,
        linux-kernel@vger.kernel.org, Yi Zhang <yizhang@marvell.com>
Message-ID: <20130522161422.GP1627@sirena.org.uk>
References: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EmwFttYoLalE/5Ab"
Content-Disposition: inline
In-Reply-To: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: 88pm800: add regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EmwFttYoLalE/5Ab
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 08:10:53PM +0800, yizhang.mrvl@gmail.com wrote:

You need a DT binding document for any new DT bindings like this one.

> +static const unsigned int BUCK1_table[] = {
> +	/* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
> +	/* 0x50-0x7F: from 1.6 to 1.8V with step 0.05V */

Write this out as code, don't use a big table for large sets of
voltages.

> +static int pm800_list_voltage(struct regulator_dev *rdev, unsigned index)
> +{
> +	struct pm800_regulator_info *info = rdev_get_drvdata(rdev);
> +	int ret = -EINVAL;
> +
> +	if (info->vol_table && (index < rdev->desc->n_voltages))
> +		ret = info->vol_table[index];
> +
> +	return ret;
> +}

For things that are just table lookups use the framework helpers.

> +static int choose_voltage(struct regulator_dev *rdev, int min_uv, int max_uv)
> +{

Similarly here.

> +static int pm800_set_voltage(struct regulator_dev *rdev,
> +			     int min_uv, int max_uv, unsigned *sel)
> +{
> +	*sel = choose_voltage(rdev, min_uv, max_uv);
> +	if (*sel < 0)
> +		return -EINVAL;
> +	return regulator_set_voltage_sel_regmap(rdev, *sel);
> +}

Implement map_voltage.

> +	for_each_child_of_node(nproot, np) {
> +		if (!of_node_cmp(np->name, info->desc.name)) {
> +			config->init_data =
> +				of_get_regulator_init_data(&pdev->dev, np);
> +			config->of_node = np;
> +			break;
> +		}
> +	}

Use of_regulator_match().

--EmwFttYoLalE/5Ab
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnO7bAAoJELSic+t+oim9BfkP/3Kg1KJxDYKLoQjqo3nWY9xr
8nCOK5xwlY89o0h1t9cplkKCJvPww22foSBQ14dlSFlDuwu1aLWR4E4ZXaDKilsg
NmLr6xH8KXhd/jg3XABMRrfzeIY20NPy8FcnmAvfs+An4SaQRJSoIfQ//QdTgNaY
r7rvIOu1YEN8OCEHB4bZXX8oMrjuaFVESa03lTOOzksKH9rjGpsDE0qrQvbRn5pZ
aeWwO1vSaidqwEOa1q+cQTESjWp8uvDpgRc4GRCB1Ydr0Udfru45YKnYslGXoSdV
IA4vOUGkHhkmAtAmSgtInvyLV9pJ1Rz1BJG7ySHmBWF6YHZzbCikc3NeczjkSlcC
Q1gfTY0mLlVwHw/73a9ihIjcJ7F+GlJwdikWU+xpLnreU+ImbfmGfT0PahGmph5I
J69n13ibllWJbBtyZyFlWMd7EkwOOuE5hKr55y9lKNnfqOatCxHHgoN5khNG9k9B
7BXr9FefhMcxDlJ0u2ICweGeYGvsEBYNou+jv7eK/7ezEtOXR9z+UmYifBBD/6hV
vDOjS49irMBjSto61dFZ5cSeEbFwMzxHotT39J4KDjmG4gtoQ6ctaJJqR3zcMQRG
8JRNmZD69701spOdkGagkBGq9W3Uie4PuLU5MTk6qF6l02d2PByjoeqrfQpQZaqL
T1hxX+gMIxWEkyATW+5Q
=Sv1+
-----END PGP SIGNATURE-----

--EmwFttYoLalE/5Ab--
