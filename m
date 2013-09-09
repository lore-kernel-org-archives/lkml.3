Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3IILNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:13:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52967 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3IILNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:13:38 -0400
Date: Mon, 9 Sep 2013 12:12:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, linux@roeck-us.net, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130909111242.GW29403@sirena.org.uk>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-2-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eGyD7iWN192kf2IJ"
Content-Disposition: inline
In-Reply-To: <1378722552-10357-2-git-send-email-wni@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eGyD7iWN192kf2IJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2013 at 06:29:11PM +0800, Wei Ni wrote:

> +	reg = devm_regulator_get_optional(dev, "vcc");
> +	if (!IS_ERR(reg)) {
> +		err = regulator_enable(reg);
> +		if (err < 0) {
> +			dev_err(&client->dev,
> +				"Failed to enable regulator: %d\n", err);
> +			return err;
> +		}
> +		msleep(25);
> +	} else {
> +		if (PTR_ERR(reg) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +	}

This doesn't look good, it is going to ignore actual errors - I *really*
doubt that vcc is optional, it looks like it's the main power supply for
the device.  You should use normal regulator_get(), _optional() is for
supplies which could physically not be provided in a system (eg, if the
device can generate them internally if required).

Also do you really need 25ms after power on?

--eGyD7iWN192kf2IJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLa0mAAoJELSic+t+oim9mtEP/1SUDSgzujFw5/vaUxTB6Jq/
PwuLrmNO0Qn6UGFgEedeVtxF8sFiw/lQwE9BxjI/31HaLpMIzhW7jyWTclCcfHLm
8sEkFEF8uQfMXR613Z/dBaDhX2cpv7GxrYT1BTJEyAJ8SsUqoHlTZfW2zQtmCV2y
cMKB7pxHx6sbu4bfyPqy3n0C8Z3O5hO2toh3cnGMs6ykw2SXLC2MRqlNeOkrTFHW
sYf6U9Di6V+r6CTU+hkWlAA9Z6EK34K1W03hVwy2Uxt/7JQXPJstRteeCaQkMoOy
Nh3aZr9ndD0mLWQOlZPTdZFgWEXWoSMMd5cp1sIHCgSouIAmgNWtYm6xeMqHeMX8
QW302r0sG2cFNHR8s9WxXmkqxU/zaNJSndTCbz9+2JMri3oDTa1h/17lYmEhAmeU
nRZdWf0vCUt3xFcmXLOLJGh/+6wfeG5grOjCZ2ak1iK/Hg8AZBW8baqDpSQoNdbe
aZwnQ1XWUFr6x41CXOY2gAo+cHewD6xCmbUMaNZ1Hw609cCtzUyH4RJk4WdCD6nR
HL2nXGJ0eBuej+oVFWuYpgN7nfaLEgD0O6ltbkQ/Gy2EcJKiQ0pnXJVUonCo2tmz
LaxRZv5XyqFWh5fkfqeWN+yoiSLytn69nv/wL37DfuAII8MkusNIGLfovIc5Lw1L
sy023tGgup8IypqiDFB0
=cjg2
-----END PGP SIGNATURE-----

--eGyD7iWN192kf2IJ--
