Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaBZMIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:08:10 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60484 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZMIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:08:09 -0500
Date: Wed, 26 Feb 2014 13:08:03 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm,renesas-tpu: Add dependency on HAS_IOMEM
Message-ID: <20140226120800.GA28939@ulmo.nvidia.com>
References: <1391172318-17853-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <1391172318-17853-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 01:45:18PM +0100, Richard Weinberger wrote:
> On archs like S390 or um this driver cannot build nor work.
> Make it depend on HAS_IOMEM to bypass build failures.
>=20
> drivers/built-in.o: In function `tpu_probe':
> drivers/pwm/pwm-renesas-tpu.c:421: undefined reference to `devm_ioremap_r=
esource'
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/pwm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

In the long run I think it might be better to add a dummy implementation
for devm_ioremap_resource() in order to make it build properly even for
architectures where it isn't implemented.

For now this looks like the best option. Applied, thanks.

Thierry

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDdkgAAoJEN0jrNd/PrOhAe0QAKyUA87zK4ZZmg8Jsg+3PjcL
oMKK5lfVyVm2hw4A4u/3cX6EKC8sSUtftX1xCrURNGEs/OFdYqNYigUbpdACjEBk
QzvwkjwgGL65putWA+zt1tRwiN4QXj05p4PNiyf0eRtTJ24UtW2Tb4Zgi4ONuBFY
cXXT/qlPhjbVFrEhi3XJ5Q4pLQam8ErsTJ10OI48i+H3zwN8san/Uz6m3JXa9KWV
fPzBmje9oR8gLARz6lqToR/oFJjTARO1t1fnD6E4Z8msTmM7dkEj4Fe7Qd2mgLsk
C83mm8XkK2dCIuaUku4Qcny6cEjq8N+iQv3Kgf1cUrocCLS/Q1iRHwnA0A+a1mql
g3OTpI0wgTG+uoLTZIzbgG8JleUlN4YFRTbPNyDeuaFat5wWXgAecFVTh0xS5puJ
Zoql9ZpmCGaLlvkIH6uBy1QEAthbFD6GRITkfP4XulkW2j8MvJZx5kLGMLNShUR8
IsLTeKP253iEXnFGVIVxTowRIegaE7ZfU6pSmBs2PoDtxDdhKmdPEg6+2sUTqxBm
Puv02La8AFlymhfZqWxAsYxvfHIUI4QKhk/9sAoyru2jCKxJG6j11AaupLGyt7Xe
rMrpPdAgnzNSA3nP73JBvr6fdmx0LpRF0chfKmzuV2r57nFT6l6Z95AubYe2NbJh
2mShAmiTKIGr9kqvEwSz
=+DMl
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
