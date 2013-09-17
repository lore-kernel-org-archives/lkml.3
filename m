Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3IQLZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:25:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53764 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3IQLZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:25:17 -0400
Date: Tue, 17 Sep 2013 12:24:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, florian.lobmaier@ams.com
Message-ID: <20130917112444.GU21013@sirena.org.uk>
References: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com>
 <1379400338-20704-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2F7AbV2suvT8PGoH"
Content-Disposition: inline
In-Reply-To: <1379400338-20704-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] mfd: add support for AMS AS3722 PMIC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2F7AbV2suvT8PGoH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2013 at 12:15:35PM +0530, Laxman Dewangan wrote:

> +MFD driver adds following mfd devices with their compatible values:
> +as3722-gpio: The compatible value of this as3722 gpio driver is
> +	     "ams,as3722-gpio";
> +as3722-regulator: The compatible value of this as3722 regulator driver is
> +	     "ams,as3722-regulator";
> +as3722-rtc: The compatible value of this as3722 rtc driver is
> +	     "ams,as3722-rtc";
> +as3722-adc: The compatible value of this as3722 adc driver is
> +	     "ams,as3722-adc";
> +as3722-power-off: he compatible value of this as3722 power off driver is
> +	     "ams,as3722-power-off".

Personally I find this to be exposing implementation details of Linux -
unless there is something reusable about the binding that'd allow it to
be used to describe the contents of the chip the subnodes really aren't=20
adding any information that wasn't present from just knowing the parent
chip.  If there were relocatable IPs it'd be a bit different.

> +#define reg_range(min, max)	{.range_min =3D min, .range_max =3D max,}
> +static const struct regmap_range as3722_readable_ranges[] =3D {
> +	reg_range(AS3722_SD0_VOLTAGE_REG, AS3722_SD6_VOLTAGE_REG),
> +	reg_range(AS3722_GPIO0_CONTROL_REG, AS3722_LDO7_VOLTAGE_REG),

If this macro is useful it should be a generic thing in the header, not
done driver local.

> +static const struct regmap_access_table as3722_volatile_table =3D {
> +	.no_ranges =3D as3722_voltaile_ranges,
> +	.n_no_ranges =3D ARRAY_SIZE(as3722_voltaile_ranges),
> +};

This looks wrong - the registers listed in _volatile_ranges are in fact
the ones that are not volatile.  I'd rename _volatile_ranges to
something like _cacheable_ranges.

> +static int __init as3722_i2c_init(void)
> +{
> +	return i2c_add_driver(&as3722_i2c_driver);
> +}
> +subsys_initcall(as3722_i2c_init);
> +
> +static void __exit as3722_i2c_exit(void)
> +{
> +	i2c_del_driver(&as3722_i2c_driver);
> +}
> +module_exit(as3722_i2c_exit);

Modern systems should be able to use module_i2c_driver() and deferred
probing - is this not working well?

--2F7AbV2suvT8PGoH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSODv5AAoJELSic+t+oim9jZ8P/idmFHPapqV0CQm7y9Pxw4Ij
dUehc9jrgF5bU3w7WE4qxZy4sxKS5ixSIoSuNuAMG9nuN+yEi/2MXJtfOUpen8ky
dBwmM2J/65sbLl0pd3XE/fuutHp1ieT/Ncf56KBU2N03XE6RV/exe+XZ+D6hbCbH
W06f9LAyxi+Na4u3oxlyc16T+QsAcXHTku0248/9SqMdDMqYOqm35SqvUoupojMB
T9CkjSV56JbI2MYmf4FAIek1U4oG2anEy6XjhzZ3o9pV9pPI1PitmebhGVQO9Hqa
Nbh5srfovfheX4ngZgqE9jlbKnIjMS0Zyw5ds4mNS1tu/Ku/Nmynvq8Y5aGsv1Nf
UdUqonxtzqHE0ILnefir3eRHnUb6E/VGyeh79dmBUFyx8hHTZWrfqOCll7e+xR5B
1o2RV8NliIO7UjLOq+LRZd+fnlv8zNA6PH/s19KMY5Mt4VkMpRHktsBiJtnMOBPe
hbNNtvF3U/aTf2b2Fy/NuAzx+lSWmLgOXui85xdB3efY4DYNCljaOeYlQq7nV5lG
0stRER29XOAttTjSK5bCCAusMSfELzlx5EkIlG04k6O8bcVdIMUbxxehxr0rl7Qz
ZmSFfn0XrCVZlTWnsca7kFA5Y5dNJ42DLROxirrWGRCAri6Rr3FkBL0CySeeSu88
Ie1UTJVrDCNWMzYz0Qg4
=dTEc
-----END PGP SIGNATURE-----

--2F7AbV2suvT8PGoH--
