Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3C2RpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:45:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42532 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756454Ab3C2RpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:45:00 -0400
Date: Fri, 29 Mar 2013 17:44:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 07/33] regulator: ab8500-ext: Add suspend support
Message-ID: <20130329174458.GF18316@opensource.wolfsonmicro.com>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
 <1364487093-19551-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KooJrfvDkviRNGvv"
Content-Disposition: inline
In-Reply-To: <1364487093-19551-8-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KooJrfvDkviRNGvv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 04:11:07PM +0000, Lee Jones wrote:

> +static int ab8500_ext_regulator_set_suspend_enable(struct regulator_dev *rdev)
> +{
> +	dev_dbg(rdev_get_dev(rdev), "suspend: ");

It's kind of a general problem with the AB8500 code but there's an awful
lot of content free trace like this, if there's not adequate trace in
the core for things like that we should add it there.

> +
> +	return ab8500_ext_regulator_enable(rdev);
> +}
> +

This looks broken - it's going to interfere with the normal runtime
operation of the device as it's using exactly the same operation to
change the device state.  If the hardware doesn't have any support for
suspend mode then the driver shouldn't be implementing this function.

--KooJrfvDkviRNGvv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVdMTAAoJELSic+t+oim9agwP/A4L3Fyet4vTVHCc0nE/PJGu
OXwKcnIJii3rE5R2rYVzbecexSg3qc8FKYT/1vTaGlgWpRB7fGGGGbijbdbhX1uS
wiwWUGf0LsS+uY6VlXO21HUVVSgAbVyWHMQMrbEximKRIiiac/9AWGrzcnd4qMlF
zYR17JQK0v9jZ0zbxQniAzBP9I+3ym/FvA4R7Q217nF1gMVfnTkBldU9efQpJQWK
U1JSAO7w34LI34mwiQtZ8DMzQulYptErdi46E+qaaY2TEKU9Ef1jQkKrYKxLO4Oq
rpD9ZBS073yEkc/Y85jBi6OUT3eBFckgeqMjwYDnweUe0vr0OMi1FYjmilzfUaxV
c6h1V/jkjUWly4GT1eoh1Dl86PJ+mtI1BCiK+rJubgqSKbXC+egMHA//1n18QosE
BY1p69uHjnOjWn2nIqmuKb5rWXbDlxcZJRGc1LKMroaxU6uoiHUsUopcxq9dlJ+d
jnw70M6KODjK0CqU1XylW3WSjp6ZfikIWsxLJqMOXASHIZclI7bDs8X7M2qPfIiO
+TXFvZJU2DoXh6LaGI1xApjyFWfy0LFPOAvNJqt6V5WZK/3pzaP9lFHDkLVCpfnc
YjViUECDetM7fTKzQhbMyIk+rFMwoS8uibZk850pMMhSt7R8xoXvHU6bc2KzfnDJ
sW/wogEH/z9baEKHPb+A
=vuYH
-----END PGP SIGNATURE-----

--KooJrfvDkviRNGvv--
