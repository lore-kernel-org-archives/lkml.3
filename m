Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3EVP7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:59:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57420 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3EVP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:59:30 -0400
Date: Wed, 22 May 2013 10:53:47 -0500
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Message-ID: <20130522155347.GJ1627@sirena.org.uk>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tgQ0jN0vM+YIGDGO"
Content-Disposition: inline
In-Reply-To: <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tgQ0jN0vM+YIGDGO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2013 at 01:47:33PM +0100, Lee Jones wrote:
> This patch fixes a bug introduced in the v3.10 merge window.
>=20
> Some platforms will not want external registers. Rather than setting up
> lots of different clauses in the core ab8500 regulator driver not to
> call ab8500-ext init() we just won't pass the initialisation data from
> platform code. This patch checks for it and if it's missing, we won't
> register the external regulators.

This seems problematic - if the regulators are unused then they
shouldn't have anything enabled in the constraints and the regulator
driver ought to be read only in which case it doesn't matter if it's
running or not, the worst that should happen is that the state can be
read back.  I'd therefore expect the fix here to be in the board side
code that enables the regulators.

--tgQ0jN0vM+YIGDGO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnOoIAAoJELSic+t+oim9jS0P/3sDdQgo7ESEoFZD8IIQFp7/
XEdDS9lFUa7uUdQtQe8OWdmGh4qIi64sHCD+8nKwwSinFhimPycL8E4DqFrGOmpT
p4YeQu56cAD2dQh+eMex4OHD/A+8MCovv6PW02nZz4biuRyb2ezA4sh8ZT96kPFf
gMkdwAcLmq8QTdwZfIek0WH3TYv5TDmP20xLtl0N8nPeiX8LyS2El2ip6/GSPj4s
LSSTUsmj0UuyaaLj3gAlVDOR/zj8TzBCVIu0l6OP3Alb9V7IYpI9MrwF0zWvuGlc
Ys6ei3uas+sOu65oUyxCBgiCMTZtxFeTIvKPd2CUnWtZ0xRwiQwCFHAagJvnf3jz
xH49tU6C6V0LNpE4B2c2xPlrWU+aDMyxtNTmKq5V3H+m/kTbEqD71kAs9X1p03Hs
qkjEHV5FuNBBM5mOvFi+QGDJ/AugdpSastJ+IZvt94kT9YqJRcAFzMKu+ikbU2eM
REKS1pWUP1aON2h4D8GR755Vk0tmyua4IrvsE4TsG+bQyL7LC/27GO884ksXDMCF
1yqVUFZ7JcilbH7ThzBKSXH2thmi2mIHZJg8Iq4YS4arMZBnIqHneDrLH7ormy2g
75yG9fC2BxcjBCL7RiIh7rhMvCIhsADqQ/4KdDzk3jxdcA4oV1lfl1Jo2L/W3nLs
WdZGuF3IUALGZ9Te1ZwX
=pPzf
-----END PGP SIGNATURE-----

--tgQ0jN0vM+YIGDGO--
