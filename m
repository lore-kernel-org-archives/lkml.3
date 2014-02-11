Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBKSwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:52:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40499 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBKSwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:52:09 -0500
Date: Tue, 11 Feb 2014 18:51:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140211185157.GY13533@sirena.org.uk>
References: <201402111758.s1BHweP2015522@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I/wet25DnWlSyk1C"
Content-Disposition: inline
In-Reply-To: <201402111758.s1BHweP2015522@swsrvapps-01.diasemi.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] regulator: da9063: Bug fix when setting max voltage
 on LDOs 5-11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I/wet25DnWlSyk1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2014 at 05:46:41PM +0000, Steve Twiss wrote:
> From: Steve Twiss <stwiss.opensource@diasemi.com>
>=20
> Bug fix to allow the setting of maximum voltage for certain LDOs.

This changelog isn't very useful, it doesn't say what the bug was or
what the fix is.  However...

> This fixes a problem caused by an invalid calculation of n_voltages
> in the driver. This n_voltages value has the potential to be
> different for each regulator and the new calculation takes this
> into account.

> Several of the regulators have a non-linear response of voltage
> versus voltage selector. This is true for the following LDOs:
> 5, 6, 7, 8, 9, 10 and 11.

=2E..but this one is more so.  It should have been the actual changelog,
along with a description of what the fix actually is.  In general
anything that's not in the changelog should normally be process stuff
not a description of the change.

> This patch also includes several minor alterations to clean up
> the code so that checkpatch.pl will not display any warnings.

Don't do things like this for bug fix patches, fix the bug and then
separately do any style fixes.  Mixing in unrelated changes makes things
harder to review since there is and makes it harder to send things to stabl=
e.

> @@ -60,7 +61,8 @@ struct da9063_regulator_info {
>  	.desc.ops =3D &da9063_ldo_ops, \
>  	.desc.min_uV =3D (min_mV) * 1000, \
>  	.desc.uV_step =3D (step_mV) * 1000, \
> -	.desc.n_voltages =3D (((max_mV) - (min_mV))/(step_mV) + 1), \
> +	.desc.n_voltages =3D (((max_mV) - (min_mV))/(step_mV) + 1 \
> +		+ (DA9063_V##regl_name##_BIAS)), \

This seems a bit confusing - the number of voltages is affected by
something called _BIAS?  That's not very clear.  There was also some
mention of non-linear responses which doesn't seem to have been
addressed at all in the change.

> @@ -387,7 +389,8 @@ static int da9063_suspend_disable(struct regulator_de=
v *rdev)
>  	return regmap_field_write(regl->suspend, 0);
>  }
> =20
> -static int da9063_buck_set_suspend_mode(struct regulator_dev *rdev, unsi=
gned mode)
> +static int da9063_buck_set_suspend_mode(struct regulator_dev *rdev,
> +					unsigned mode)
>  {
>  	struct da9063_regulator *regl =3D rdev_get_drvdata(rdev);
>  	int val;

This is an example of something that just shouldn't be in this change at
all, send it separately.  There's no overlap in either the purpose of
the patch or in the code affected.  In fact it looks like the entire
rest of the patch is unrelated stylistic changes?  If that's the case
there's far more checkpatch in here than anything related to the main
purpose of the patch.

--I/wet25DnWlSyk1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+nFKAAoJELSic+t+oim9im4P/3vZCisWK7lGmbf9gVC9qmsA
8K8Jj7wvzp3h2MRp930n0Wzm+sLCsjHhj9cYvTPh/9ana08Ons0Z2NGVzhd7x20d
RpOXi/Qi8cCoHS6O2d8SJgIqlb2jKMOLYuXOIGBCf1Ya1ATmnd7Xq8II4VDMmY4X
efy6fcpHem3PQi7bzc+2WaWEvsUg1xuwggnJvPUr30YgwXFWVt2qy0eWp2ysGghA
yd5TriZ0qOE5XQQLqgd/1hacJRjb8g08vjXGMhfIKjnIkJGN5NJKZ9G0XR46aNSj
fdBGIDNy8z4bokOih+ecRp9FDgMECZG+N+/YCy3k0jdPl8t9DV+1ELWdrK03AhqQ
zw1ZVkd1li7RU1lLr1l6KFkmjmwgnUMmUqrzChbqZdtaWLGyoVI5MoMhpRHmaRhv
FM/3SjaT2Ep2YQG414woHRRYx+Aehtf7mfF124J8lPRuQ3SUJICV1ZKyHzRWgOr9
vrKeesuaCPGjGHD4i8hvwonG6w+VLRRrDkkvd0w47jLOHjnjTYlx5EE/2za5U2IR
8amJBvJXQwiNgWLMBdYn5rFW8aDreS+FDgsUgCCwrSd/dwbVX3PmmHd5mg1jcn0x
/N597dR3WJa+gv48mWXUHFFi4mGAOmaZeMiwxLke3ORdvlJoiMZdndgGXoq5uoIc
vIVHtyQRD0BZzuy3d0Z7
=oLzq
-----END PGP SIGNATURE-----

--I/wet25DnWlSyk1C--
