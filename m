Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaK0PWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:22:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37288 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaK0PWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:22:31 -0500
Date: Thu, 27 Nov 2014 09:22:16 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Sebastian Reichel <sre@debian.org>, Benoit Cousson <bcousson@baylibre.com>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: dts: n900: isp1704 gpio
Message-ID: <20141127152216.GD30719@saruman>
Reply-To: <balbi@ti.com>
References: <201411271513.43349@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Content-Disposition: inline
In-Reply-To: <201411271513.43349@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 27, 2014 at 03:13:43PM +0100, Pali Roh=E1r wrote:
> Hello,
>=20
> in commit "ARM: dts: OMAP3-N900: Add isp1704 support"=20
> e17337a26962943c27124a14b0794eabe76af437 was added support for=20
> isp1704 chip with configured gpio "3". Now I looked into legacy=20
> board rx51 data and there is gpio "67" for isp1704.
>=20
> I would like to ask, why we have different gpio in board data and=20
> in DTS data? I'm sure that isp1704 worked from legacy board data=20
> without problem, so I do not understand why in DTS code is=20
> different gpio number.

it's magic! Seriously though, each GPIO bank as 32 GPIOs with numbers
starting at 0, note that DTS uses the 3rd GPIO line on the 3rd GPIO
bank.

Bank0 handles GPIOs 0 - 31, Bank1 handles GPIOs 32 - 63, Bank 2 handles
GPIOs 64 - 95, and so on...

Offset 3 on Bank 3 would be 64 + 3 =3D=3D 67. Yay, magic.

--=20
balbi

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUd0GoAAoJEIaOsuA1yqRE43sP/1NBs6sghXFvsYk5yHcqKdmb
fOQUXsWWvql3P7dEJjtap2iZzTtDRjzXyP69VerQlnf5wX4jrSowSuxTOOGnj7Za
g8qT2xn4ojzXZyDYVVercT5vlE76ggZjMI7hrNessLnp0u40hMtTTWYfcE65jAB3
O1KuusLkB4C3v93thWH9f9vl9/jjzknqGbKaLY2aoWCh1ahNN6TM2uKCyTxxhZYy
k+HF1ZsKTc9rH4r/26jdHz/zdJNdzuwuJhVgpq9aOXboUoNFtUL+Afa++3FQBjVs
YmWIhk5spe+AXTqi/8wc1NP2VPf9QsEeqxC8/MTwt2AQV24gs2yigyU23tmHWkH3
zr03vAhSSAZZh3iNRvMm+BJM+mR6A7DoLoKSU03eZmHJtl2GQ84Y1z6q1wXLHM65
qkafRCuMu8VfyalWhpQSw15vTVRJ1Xs8VOrLCYMg+FgNulCX3oQ8tnH/ka4OR0H4
TEoNFzdOxw6/MAAYyUjzZSh67JTKSwzSoHECemmUo8tyIrxxQIrN3xZzmaZjNYHL
Crw2DxmwOZNym8TKvzt5OXkfHPFV2Y/Kvf5Aj+79PnSFxo9HAMJd5eNEhV+SODs8
snzYlPmCFQWCN9UP6dt2Abe7zzMLyN8dEfiDY/7/4Lda5G8OrEgVH2CdpIyu+fHY
jImAlAzgJMSZVL0U+uy2
=gcxi
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
