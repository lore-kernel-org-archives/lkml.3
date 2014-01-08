Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaAHMaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:30:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48664 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbaAHMaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:30:08 -0500
Date: Wed, 8 Jan 2014 12:30:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        lee.jones@linaro.org, robh+dt@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, sbkim73@samsung.com, patches@linaro.org
Message-ID: <20140108123002.GY31886@sirena.org.uk>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
 <1389162390-4582-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pt/BdA48mw0ySYRj"
Content-Disposition: inline
In-Reply-To: <1389162390-4582-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: Add support for S2MPA01 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pt/BdA48mw0ySYRj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 08, 2014 at 11:56:29AM +0530, Sachin Kamat wrote:

> +	if (!iodev->dev->of_node) {
> +		if (pdata) {
> +			goto common_reg;
> +		} else {
> +			dev_err(pdev->dev.parent,
> +				"Platform data or DT node not supplied\n");
> +			return -ENODEV;
> +		}
> +	}

The driver shouldn't need these to probe, it should be able to start in
read only mode with no configuration.

> +static int __init s2mpa01_pmic_init(void)
> +{
> +	return platform_driver_register(&s2mpa01_pmic_driver);
> +}
> +subsys_initcall(s2mpa01_pmic_init);

module_platform_driver().

--Pt/BdA48mw0ySYRj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzUTGAAoJELSic+t+oim9F7oQAIMU9mZu44894P1CKlL/x3io
1kRJBv20T76gg/CIge4Y9m0Bq7I3ztbUT+Muv/tmfUZZ3E5nPLgePZXYEFhkxjRD
jEdKkRVUJ4LkQkbakU9cT1nVikBRcbNgC/AWvFZwUlQCZXTcKZNfKrcv/ml1Lk4n
5hbvN2W4LGYJjIqE/PQaMI/yMPkBvt8fBqQSwxQqJ/Uibqw172VUCBrzdkV9GcTG
6hPy5bDC43Ws/ZHQNKgzouAw+5/i04EdJ8c7cNzGmXUVVScXV5kN5zMpTf2bb+bY
e8TWRsqMTTRZSgdyVk0V/4z3Q3+z48GXVA50TLcsZ5+AGWSebHcPHUkLqhzXArEJ
mF7ApjFtvklhiL1c+yVBHEC8Oj1Rx4gSkgc6QvuWdFdfnh38GuTwiDsBRvLSpSu0
/wuTen3PEHw3C5wU+62rMmS/ktJBt4Xmn/cW6OsvnF+zsc1zhT3j63j6fbUzJS8d
Y8d31RcjZxgawnHtlhp3VINiDwGGE4xKA+l8nZ5PzZZftCo+x7qP2/DjK8ebk4pP
Lq+4IdInRXyF8F3k078kLm2xEk6y+mLrDGHOJM24nOV5SzmjDrQgkFrbK4gGLWr9
BvsPfW1lgtpV/gkf9uYngpbcFd/H6qwVKJGXM/jSB7T/W/rs1SnRw9RuBdQgATnX
2c0mzd7NP5Mm/aLc9N/Y
=31zK
-----END PGP SIGNATURE-----

--Pt/BdA48mw0ySYRj--
