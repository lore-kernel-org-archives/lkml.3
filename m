Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaFCN5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:57:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52071 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaFCN5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:57:13 -0400
Date: Tue, 3 Jun 2014 14:56:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140603135630.GC31751@sirena.org.uk>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140528184752.GA22488@sirena.org.uk>
 <20140603130938.GI27722@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o9w4P0ZCTVHZJ0iX"
Content-Disposition: inline
In-Reply-To: <20140603130938.GI27722@lukather>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/5] regulator: Enhance AXP209 DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o9w4P0ZCTVHZJ0iX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 03:09:38PM +0200, Maxime Ripard wrote:
> On Wed, May 28, 2014 at 07:47:52PM +0100, Mark Brown wrote:
> > On Wed, May 28, 2014 at 07:11:04PM +0200, Maxime Ripard wrote:

> > > This patchset modifies the regulator core and axp209 regulator driver
> > > to be able to set in each regulators sub-node the supply, that should
> > > be possible, given that it's documented as such in the bindings, but

> > It is?  We should fix that.

> From Documentation/devicetree/bindings/regulator/regulator.txt:

>   - <name>-supply: phandle to the parent supply/regulator node

> With the example:
>=20
>     xyzreg: regulator@0 {
>         regulator-min-microvolt =3D <1000000>;
>         regulator-max-microvolt =3D <2500000>;
>         regulator-always-on;
>         vin-supply =3D <&vin>;
>     };

> If not right, then it's strongly misleading.

That's misleading, the supplies are for the bit of silicon not some
subfunction on it.

> > No, we've been round this loop several times before.  This reduces
> > consistency in how we map supplies since the user has to work out which
> > subnode the supply is associated with and what it's called there instead
> > of being able to just look at the schematic and translate the supply
> > name into a property name.  It also means you have to map supplies into
> > multiple child nodes if the same supply is used in multiple places.

> Which might be what your schematics actually show. If you have a
> single input pin for each regulator, even if the name changes from one
> pin to another, you're still pretty much in this kind of construct.

That's very common, but I do expect that the supplies are all uniquely
named on the silicon so not a big deal and bear in mind that this is
not just about consistency between PMICs but also about consistency
between PMICs and other devices.

--o9w4P0ZCTVHZJ0iX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjdQHAAoJELSic+t+oim92gEP/AmCrSHTITPo5l5yJ7xCIDnB
cq9+23cy50ETQroMI4K9ciylG5e2Zkoe+rVuTsYYadhfruwoPQsEByxfhMidYqz4
pCMHBNHCD/yDbzHPOKQGpDVOhJPr6AsEhFX6bi5+X5U3XsFMg52clFBsa7676/7m
wL5XGymim0eMF9dgX4z0kIRIPU9YnN5wOl8lR8GRTxmW+sqoK0+wdiJE3mPI6onA
E8Vd14gobKhoJRZfNElnP8rXROB7dwDnd5uWhXIBPtAEWVI4JKVudyfZZp47V5Uy
RL5HKo0rTRIVZJ2yM0ls3XToIcLf4p2yoqsZScca9RTE5v8MTOzW0VS4TSCSndSA
UxC1HdgHMZhp//Pbge1KVbRMTHEG5a20QvNiVtNE1+HbT10/CzC0iRWygXLmU4eb
0yL94uiZoFRx5qvQUMCZzpjcpPmIYFoMOny1XCbO4S3VVsdhfL81MUgQk93nqXXQ
a2ZjBL5hgbHRJJ9bGbXFiw8T3FBbM3/az1DJ9WAyguMJ9rV+AU0k6t7HbOslo5xx
NO9eb5YmBHC9dgLOCKyVNJEkY7Hhzwn0wBvWUiRpVxYR5wWQ0H7uu2ee8p82eMaV
cIIti6goafndbKspJ5POgvWyC0luW1sN412LX6vBVxWEdAZCTxNXHZJF3MBuYkJt
uhAk1VlIEaEhlP7lLvm3
=kYHI
-----END PGP SIGNATURE-----

--o9w4P0ZCTVHZJ0iX--
