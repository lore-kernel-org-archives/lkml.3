Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaAPM1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:27:17 -0500
Received: from sauhun.de ([89.238.76.85]:49986 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbaAPM1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:27:14 -0500
Date: Thu, 16 Jan 2014 13:27:04 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
Message-ID: <20140116122704.GD2617@katana>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
Content-Disposition: inline
In-Reply-To: <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index d74c0b3..c4c5588 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -104,6 +104,11 @@ static int i2c_device_match(struct device *dev, stru=
ct device_driver *drv)
>  static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env =
*env)
>  {
>  	struct i2c_client	*client =3D to_i2c_client(dev);
> +	int rc;
> +
> +	rc =3D acpi_device_uevent_modalias(dev, env);
> +	if (rc !=3D -ENODEV)
> +		return rc;
> =20
>  	if (add_uevent_var(env, "MODALIAS=3D%s%s",
>  			   I2C_MODULE_PREFIX, client->name))

I wonder why we don't have/need that with CONFIG_OF? Because probably
nobody is using modules with i2c devices there?


--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS19AXAAoJEBQN5MwUoCm2swEP/3NZJ6MKIWsmni+iwXU/rxbW
0yfkQondx3rLkk/OgdfEavkCvqqXF78ZYPJmxHsIGU1xVeRKzKMrDVWzpxCc7OS8
QiHjbYMJCyzO3SAqIi0kFqsbcb8wIWJI9kTSbOsLyjD+euZJZGSgapBH+HfpkzRQ
mbQLlUlBJoNUDs7B5iKlimUQj8AZyb4NXVLQqgxU1JCDFdAfi5iPi2OljHTJIX9Z
Dy5gsOYYAYHMs8vYqwz90lBZO7Zuwo7a5R/o/itemi3wrkEGj6TMsMAknlSPG/3h
AmxoWjaiQiOiSL6n+8o9dRERG0bhJdFQDBIsq/iv1gJYJLPTRz1R2PYfJsPJCowK
Bx7fwzZ4V0QAHckIYu23gA1HiQGgjhd7jytUnizLuhndXLo9QH8tgruaES2FxzyE
eYmUUQoswb4wu4/mVgJNFsQ9aN5DM1Ihws4fZhisooPVfv0NKyHDVJQ/61FgBLoe
z1ZHe6SybkbQ36WpX4KjqZH2inMyU9fMI3k8ePOe5vssizYk4sNGSOLDLMJ4iqjX
kuMlkcu1xpAYVCFFAfXypxdgMtZFrtqwN3Z7tTwSv8+WRtv1mzLar5wn3/3sa6Iw
afmlsNy36tf89Ocl1FVFR1G//Zz+9BaRZXcnWQygCqVJES75Di2cnaHkVbhvOi+j
3btR/rN/jtcJNPutc9Jm
=XqOA
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--
