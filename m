Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161376Ab3DEJoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:44:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50025 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173Ab3DEJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:44:20 -0400
Date: Fri, 5 Apr 2013 10:44:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Greg Guyotte <gguyotte@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: regulator: query on regulator re-entrance
Message-ID: <20130405094411.GA6597@opensource.wolfsonmicro.com>
References: <1365138582-10409-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1365138582-10409-1-git-send-email-nm@ti.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 05, 2013 at 12:09:42AM -0500, Nishanth Menon wrote:

> If we ignore the details of the class 1.5 implementation, we will notice
> a) regulator set_voltage equivalent set_voltage() is required.
> b) this set_voltage does some 'magic stuff' depending on the SoC and AVS =
class
> and calls the 'real regulator' which talks to the PMIC over i2c/spi etc..
> in short the call sequence is more or less:
>=20
> driver (cpufreq) -> AVS -> PMIC regulator.
>=20
> By modeling AVS class drivers as an regulator, we then do not need to int=
roduce
> SoC specific hacks and APIs.

But you're shoehorning something into the regulator API which isn't
supposed to be there and causing yourself problems.  This just isn't a
good idea.  The regulator API already has a mechanism for supporting
regulators which are supplied by other regulators, if you can't model in
terms of that (adding something to support variability better) then
you're not using a regulator.

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXpzfAAoJELSic+t+oim9RaoP/iU25GrbgzdsFkKLALHexFZ3
uhkGuGcJxYRQa9La6f/LRCWWmCX+QL/qAuXXK8UYaeYWHpNOLYvODN13NpxRwTk+
FtvK4M02/AnKSh3j2uIGkgqzAiufYlRx++jNgrlAp38kvLATJdDZWavqHOgsvv6W
x34cWQtJ9hROm6KEPea0nRmILK6CXkqIUOB3/dcEXVI8P6jYp7tZJdxvHvfuZVAi
9aJK9+/pz7L7aqxo3N85xCtzxZEan7fhYArc4emA/ZPr/R2qDIRiqQwvhQM83PUv
4ifA4ls1g0ILKXAsQkuJH/FrX4jSY9zN3ZT9UvbLpmJMYwfgc8fE0MsfL2RJ8kXv
2mZZJTtKdrObysEW0L0oTxR58B1cEjayWKQl0DdF4ig8DVHTdUrV2FbGkS8f1CkG
73OPekcO6l4zxpH1Ep7NEmRYBGQO3/Zde8LTZVHjIGtsBRs9jQMoqVF6bZLdTiwZ
B4qZDpKHGkdazIcPg8Ewvvn7pKR+lUUk+qSnSNUMAdyvqXraRn+yTm/6UYltMb3h
oV72n9gi4aRcdzIL0dL5/STPi0C8v6GZ7dno1i6afifP9wTgc1HWbctqlmRB1fq1
5nKMb4aCoSdGR9L6sGULU7iRBGc7E2R9H1Qti8Xq2qM/Nkvsi8kwQc53dw0LaC37
KRos2uwxeVx5zIkyMCMW
=yICT
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
