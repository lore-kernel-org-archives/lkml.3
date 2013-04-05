Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797Ab3DEKR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:17:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48027 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122Ab3DEKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:17:57 -0400
Date: Fri, 5 Apr 2013 11:17:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nishanth Menon <nm@ti.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/2] regulator: core: return err value for regulator_get
 if there is no DT binding
Message-ID: <20130405101754.GD6597@opensource.wolfsonmicro.com>
References: <1365135708-23886-1-git-send-email-nm@ti.com>
 <1365135708-23886-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Content-Disposition: inline
In-Reply-To: <1365135708-23886-2-git-send-email-nm@ti.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 04, 2013 at 11:21:47PM -0500, Nishanth Menon wrote:
> commit 6d191a5fc7a969d972f1681e1c23781aecb06a61
> (regulator: core: Don't defer probe if there's no DT binding for a supply)
>=20
> Attempted to differentiate between regulator_get() with an actual
> DT binding for the supply and when there is none to avoid unnecessary
> deferal.

So, this is an extremely long and hence difficult to understand and
follow commit message which manages to miss out mentioning the core
issue which is that we're ignoring the return value from lookup_dev().
I had to actually look at the code to understand.

What should be being said here is that the ret value supplied by
regulator_dev_lookup() is being ignored by _regulator_get().

>  	mutex_unlock(&regulator_list_mutex);
> -	return regulator;
> +	return ret ? ERR_PTR(ret) : regulator;

Please implement this so it looks like the rest of the function -
everywhere else in the function we just make regulator an ERR_PTR() and
goto out, we should do the same.

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXqTLAAoJELSic+t+oim9hEwP/2na3lv0AznYrBSF2HNVlajQ
YdrJeWKCsyXJ2vRKwQcxEdWyyB/r9Ymawosp9YztxxwIYKyKQoyQ0I7EafrtOpPb
Ql/z1NUCDYUV2g0UYuUOy+H/TOv6yhv2nbqy65Zl33MbieCiEzP26LEhJoiKb/e+
RE9VPHVLfJJIkYKbG3K5a1IfETksko14Wzqd6cbKQhU0A4MAacOcPiEQxAXtneHA
74Wiy0CUtfGaFl3N0UyYDPi5bCbREeem2UCgITkObI/gjjDuh3CAkF5zf/DxtGEO
JtxMLeb4/Mqpjz7wBaHENufQQOJOcXARNMRbgjWpTsUfRCNWgQgksoYti7Q0C5G1
MpsXeCH0gtbwVlVXDEpVYrqZ972monI5j/6EriB1o7mI0eK8sR/lywenFih+bdv/
vyWeqhKq5gYjWkzSfQmYqZtK++YI5dNAzbXY9EcKtMHcU72xVnZOJwPJxl2Wj9Tn
/POh9DE5N3SD3Y8J9tpTlVLv8BXZjzdYo46sN6+5/uMBjZ1HCMggRAx684qsct8O
k5Tf1KJeGV8krRlFJoSyBTm5Up4hrYgBYldudx8fNdQz/q9m7tfKsSrZZDpKbIT1
K/7QgfTZv1kWNdFUJLvbfA+D0AqwXg5Up6DyqUB5QZ2ppBn3CJX8ZsqScIcHOEem
R3Q9SeX6XW/bsQ5bUa1X
=W9eo
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
