Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaBDLOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:14:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35119 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDLOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:14:31 -0500
Date: Tue, 4 Feb 2014 11:14:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140204111423.GT22609@sirena.org.uk>
References: <1391508384-5013-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2cECDj2Pn+L6wlyc"
Content-Disposition: inline
In-Reply-To: <1391508384-5013-1-git-send-email-geert@linux-m68k.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: rspi: Only enable interrupts when there's a need to
 wait
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2cECDj2Pn+L6wlyc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2014 at 11:06:24AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> rspi_wait_for_interrupt() unconditionally enables interrupts, even when t=
he
> wait condition is already satisfied. This causes a high interrupt load (2
> interrupts/byte for full-duplex Single SPI transfers, 1 interrupt/byte for
> RSPI with TX Only mode, or QSPI in unidirectional Dual or Quad Transfer
> mode).

Applied but I am wondering if the interrupts are really worth it in the
first place especially at higher clock rates - if you can get completion
within a small number of polls it might be more efficient to just do
that rather than take interrupts.

--2cECDj2Pn+L6wlyc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8MuLAAoJELSic+t+oim9NzYP/Rtjuw4sggCybprd5E7snNbp
27aE/AvUTYstJFGXsBf9aW/H8XlpEKUKDiDGXaDP1Q6TCu2Tg/b9nK1+Ffm11qmj
Ak3rKwMqgtC5/2sIPxIJKH10zLyaDFCsDmOkPmVWa3tw92112NhfYWHzI0Klo3gU
qXqe7ACIe4JDj796ww14ld0Lj6WX9BVpLxfLbjGVJFkZ60lrxzBWiwXqo6CQ5qBJ
7Z36tBthUPmdREL6OFwYQ5Vf7a/LlSJdqqLBHN257sFYJ2fltP0vUFfLIYpCVRPz
R8//kppnIWw9dZMqV3O68m1GXWFPIUpX/vDZikZxdPMstOFJc0l8FEWsu9OTDl/5
VDkuhMiKV6AdfJ7OV/6kcL3bUvsfiXskt8YHsQkU3BJ7abob/NtB8iNxbRVUffOk
t4udK9u9UYhlIrfynXYuDiouu9pSq5tFBktUAF64BcQKCq6q+0ANUrhL9tLm632T
t37VuA7c/N9F2xlL399kwAgUvhqmGv9f+YDEsHqTdfq82eMd6gGkHPvSJaAvyqgY
WS8HY/tiPcMRPtXp8/t9fCMKNiVNGLM5peNlo5plWh/t/VN3PZzFUKY4xOUNO+aN
PQgb0m2f1irYBHKW4eZMAvBI/oMDmh/hX2r8oAYUuy8s6b2ExdAlGfUNVf5DW2jV
lf96Jl0RBOMUCHHnigpV
=kk+a
-----END PGP SIGNATURE-----

--2cECDj2Pn+L6wlyc--
