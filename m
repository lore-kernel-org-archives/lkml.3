Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbaFRALz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:11:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46366 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbaFRALx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:11:53 -0400
Date: Wed, 18 Jun 2014 01:11:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Message-ID: <20140618001127.GC5099@sirena.org.uk>
References: <1403033795-9122-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QJsKrtZ3JQHaPDYU"
Content-Disposition: inline
In-Reply-To: <1403033795-9122-1-git-send-email-mpa@pengutronix.de>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Add Kconfig option for debugfs register writes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QJsKrtZ3JQHaPDYU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 17, 2014 at 09:36:35PM +0200, Markus Pargmann wrote:

> To enable writing of registers through the regmap debugfs interface, it
> was necessary to alter the regmap-debugfs.c source code. This is not
> really practical.

> As this is a powerful tool for debugging, this patch creates an expert
> kconfig option for this function. This makes it easier to enable
> register writing in the kernel.

This is deliberately hard to enable in order to make it clear that it
should never, ever be used in production as a bodge around writing
drivers and generally in order to reduce the risk to the rest of the
system.  Enabling this will typically give userspace full access to
components like PMICs which have the potential to cause physical damage
to the system if misused.

Anyone with a use for this is most likely building their own kernels
anyway and if a user modifies the code to enable it is clear that it is
their responsibility to deal with the fallout.

> This patch also fixes the file mode when the regmap debugfs write code is
> compiled.

Seperate changes in separate patches, especially don't put bugfixes in
the same patch as features.

--QJsKrtZ3JQHaPDYU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToNksAAoJELSic+t+oim9YyUP/0ydFZnJVDp3DETzGcfsNa8s
FcNL9aQupunhQUwKSHwlnhLbDVVe3NnTMv8b1zTFhxV3KYXo5NOC1wNTVMZm5qW7
uEK/YOjrO9+vw61VEBJkQC5hadk7KclraxZibw1lsDHhuDICgUaDZwq7CekX6E9n
CoB2QuxlnFORfZZSJ0fF1+qo7qwn4AxpeYIKAK1t3ST6XvP7JBLLirTDgKL/UnuX
DkM29/X5lCxk+d+aVirIVqUY0RKDJRrlQX3l+k69saT7Ap+ZrmhpLRatDq1SP3+a
k9yGbl/tJ87PgaabKq5GVikKh7loAmyNiMxqxhhSVJDD4E5lJoG6INBe2Qe77bOI
Skqw0VdReCSSUmP4Z0PqoGfCx7YOE5nzvawxWAfS/nmLbeqznMwP8PXJEYw1zdU8
bNoL77vkbTQmX7Kg0la9M8cUREegBiPHOWjaA6/ApeLGvWTpa4Ir0Q1DNdFZPgsq
Jg7Lpl+P4TdC3h8MwzoTQmZpUj1kvtv96GZv1A2NNvweSz2xE/oU85bln7EOVPve
W9OCVoCpGTyev/Jb35zeECyDIjzw7pBysWApFcP2KDsEnu4QqDtdrW4OBuOGeRHo
owS7vkjlw3P63Wy+/H+gZ+mfDKggc1D23hEAQJYlcZA+bPulEG5jjGRsOsxazDju
5SzGn16c3bxykvZSTkj7
=KShF
-----END PGP SIGNATURE-----

--QJsKrtZ3JQHaPDYU--
