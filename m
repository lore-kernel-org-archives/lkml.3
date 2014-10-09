Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbaJIOVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:21:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49818 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbaJIOV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:21:27 -0400
Date: Thu, 9 Oct 2014 09:21:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>, <m.szyprowski@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: remove redundant ffs_data_get()
Message-ID: <20141009142117.GB16002@saruman>
Reply-To: <balbi@ti.com>
References: <1412840476-2767-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline
In-Reply-To: <1412840476-2767-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:41:16AM +0200, Robert Baldyga wrote:
> During FunctionFS bind, ffs_data_get() function was called twice
> (in functionfs_bind() and in ffs_do_functionfs_bind()), while on unbind
> ffs_data_put() was called once (in functionfs_unbind() function).
> In result refcount never reached value 0, and ffs memory resources has
> been never released.
>=20
> Since ffs_data_get() call in ffs_do_functionfs_bind() is redundant
> and not neccessary, we remove it to have equal number of gets ans puts,
> and free allocated memory after refcount reach 0.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Which commit is this fixing ? does it deserve a stable backport ? How
far back ?

--=20
balbi

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNpndAAoJEIaOsuA1yqREoSUP/R3834u/PuqzOXFDNPSrjNOe
sJj/9SLgXp3P1QC65P+rU3coAls2B86pAo2Ly2Nmz47XFeuimNou4pvJegJtYBNx
tFYqUexr78rcCD2K/XLA8VGAofLL4xmTxO9jjcMD5QKWP2ZRG6A3pAJOmyvdccCb
+qtplZETuSwNS/vS0oe99b/bt1iuwYQrpwHSGvW22i6fMzhtAmQKav5os+0vDZiy
l0G0H3Unchu/s+g7Z6GXYvkwW8FV5me4ZlQ4snfCxCFBJ0NK0xoQdOVqZOUonDHO
Bhl9WlIBfb9A2c0yQM7nEXWUKpLmvcTxQWtgDq7YKTRqGwgCM3A3j8FZNdwTTRfm
LvnpY5E1xNZqL3qplN8ZIYpOXp4cAWh+Kk20CjmCm+mumHtVU8VZv4uS3714Oym/
EzFm+B/tYm3FPQp+Uwq3ULklJ7OpGm463cYiuPXBjzeXcMq+nRNgN7eJzDbr+hSp
Lm4jUGfJm0Ku7kkjOL8f8DTkzX9wPshEwt91bMlhClErK9EM4vYH2UW+7bTJPM3b
bq3Gnfnh+OGmagSWxfenY+A0TFtgRFhVHq/6Oo2Od2Mlra/jP2+N803lKCpdeufR
N/g84yrFJaIryiBeYqtl43pWEFhMeXEaK9OKfCChXtWT0o1W6tFtRISimGBvWbMh
Jlc8roiAKSuhzBtOh6O/
=tSnH
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
