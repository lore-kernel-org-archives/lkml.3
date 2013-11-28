Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3K1IbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:31:17 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:60219 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3K1IbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:31:13 -0500
Date: Thu, 28 Nov 2013 09:30:26 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>, sameo@linux.intel.com,
        dev@lynxeye.de, mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: tps6586x: add voltage table for tps658643
Message-ID: <20131128083025.GB26502@ulmo.nvidia.com>
References: <cover.1385508112.git.stefan@agner.ch>
 <8be2fe8560cc19f03d5be40ad3dc21d5979c8358.1385508112.git.stefan@agner.ch>
 <5296273C.1000705@wwwdotorg.org>
 <93a0f4b1da2a54e58cee0756ab5f3e36@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <93a0f4b1da2a54e58cee0756ab5f3e36@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 10:56:10PM +0100, Stefan Agner wrote:
> Am 2013-11-27 18:09, schrieb Stephen Warren:
> > On 11/26/2013 04:45 PM, Stefan Agner wrote:
> >> Depending on version, the voltage table might be different. Add version
> >> compatibility to the regulator information in order to select correct
> >> voltage table.
> >=20
> >> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulato=
r/tps6586x-regulator.c
> >=20
> >> -static const unsigned int tps6586x_ldo4_voltages[] =3D {
> >> +static const unsigned int tps6586x_ldo4_sm2_voltages[] =3D {
> >=20
> >> +static const unsigned int tps658643_sm2_voltages[] =3D {
> >=20
> > What's the logic behind the "ldo4_sm2" v.s. "sm2" naming? Does it match
> > the data sheet in some way? If not, it might be better to name this
> > something like "tps6586x_ldo4_voltages" and "tps65863_ldo4_voltages".
> >=20
>=20
> This table is used for the TPS6586X (e.g. TPS658621A/D, maybe others)
> variant for the LDO_4 regulator. The same table applies for TPS658623
> for the SM2 regulator as well, so this naming should reflect that fact.
>=20
> I could be some more verbose, e.g. tps6586x_ldo4_tps658623_sm2_voltages.
> The other solution would be to create two independent (but identically)
> voltage tables, but takes up more space...

If you only want that name for clarity, perhaps you could just add a
#define instead of duplicating the whole array. That way you'll be able
to reference the same array by a different name (for clarity).

> >> +/* Add version specific entries before any */
> >>  static struct tps6586x_regulator tps6586x_regulator[] =3D {
> >>  	TPS6586X_SYS_REGULATOR(),
> >> -	TPS6586X_LDO(LDO_0, "vinldo01", ldo0, SUPPLYV1, 5, 3, ENC, 0, END, 0=
),
> > ...
> >> +	TPS6586X_LDO(TPS6586X_ANY, LDO_0, "vinldo01", tps6586x_ldo0, SUPPLYV=
1,
> >> +			5, 3, ENC, 0, END, 0),
> >=20
> > Rather than changing all the macros and table entries, wouldn't it be
> > much simpler to:
> >=20
> > 1) Make tps6586x_regulator[] only contain all the common regulator
> > definitions.
> >=20
> > 2) Add new version-specific tables for each version of regulator, so
> > tps6586x_other_regulator[] and tps65863_regulator[].
> >=20
> > 3) Have probe() walk multiple tables of regulators, selecting which
> > tables to walk based on version.
> >=20
> > That would result in a much smaller and less invasive diff.
>=20
> Hm, sounds easier yes. Would also remove the need for correct ordering,
> which is a bit ugly. I will try that, lets see how this works out.

I was going to propose something similar, good that I read the whole
thread at first. My idea would have been to duplicate some of the tables
for simplicity and just have a tps6586x_regulator[] array with all those
that use the "default" set of regulators and separate tables for each
variant. That's obviously suboptimal because it wastes some space, but
it keeps the code simpler, since you'll just have to select a single
array and register that.

What Stephen proposes isn't really all that complex, though, so I'd
prefer that.

Thierry

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlv8hAAoJEN0jrNd/PrOhudoP/i1+6skxJglbL3vMhHos6Yk9
t46HcmH3cNspAfGeY5FrjhlzrjW60dh9usUPo3oEukHrg9VnU1dJOYSA8c2fiOax
gMBYaGEvQoRCYdbgF26Ynl5PKS9GExVqgf0WdnlYAuXVav8m5J7X6O37a96aex3J
Qn5w1v3RLWBLlMjE6RVBMRajE6ng859Jhp9AVH2v1C9uSEO+oeOsheKIUDaw43o4
tbmfTnR3JEkE+4udgRwJ2g+KqHYdxFQcq0gpBkxke0es2CggTLUjomkkzPt8Kz11
Vz+vy2OfYId4NB52ehS+y9IuXNlU3SkIsBWHOr8KFCIE1TVr7X1ZP92AQSDf71RV
OkXUCzLTHC5cVY1DxJYGw6x9ivR82XzFNyD2PvXM7Zndj0LKm7ATi9QKAhY8FVEB
8DY/dHopN8NIld0sLFEP45yNl5fntzbr+eOlkooi+T23VqgAewWEHM9PNQHcJaA+
WKAloNBTMtOuU2tKSxR4pDKwQzAWIlaVlJj96qs5JHMJTCJIfiTtIU6EMVWODla3
VYUZFtlFtE8xxzj/X5nUCtwHqag6zy6HkrNxAbHU1tmVUDIPNJieex5ieSSsYyRT
JiWo2DnkdXcsWPvVA5HHK3gdM/6jDTwNguL6ZJ2eGt69kh1b58Zv7UcIYYQxcJII
0/aDg9IegLwdvVtv2Q17
=d2zt
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
