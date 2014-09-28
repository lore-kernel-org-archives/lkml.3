Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaI1K4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:56:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50274 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaI1K4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:56:48 -0400
Date: Sun, 28 Sep 2014 11:56:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140928105604.GT27755@sirena.org.uk>
References: <1411895394-25250-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KS5V1uDxmEcBh2BA"
Content-Disposition: inline
In-Reply-To: <1411895394-25250-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.138
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing
 error.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KS5V1uDxmEcBh2BA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 28, 2014 at 05:09:54PM +0800, Xiubo Li wrote:
> Since we cannot make sure the 'val_count' will always be none zero
> here, and then if it equals to zero, the kmemdup() will return
> ZERO_SIZE_PTR, which equals to ((void *)16).

Applied, thanks. =20

> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 455a877..3d93e38 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -1716,6 +1716,9 @@ out:

Whatever you're using to generate the patches isn't annotating with the
function being changed like git normally does which isn't great for
working out what the best return value should be.

--KS5V1uDxmEcBh2BA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJ+lDAAoJECTWi3JdVIfQvo0H/iwWTcSMpQOBMbnhgWChG5QV
94zu6+mdZ9Cs+FZc+ukJRPeGm4Q9fc01ZIxEGWS7nFXcujxSnzzBMwz4H9BDd1BP
wok8e8m7PXWz/C+G8XXBg4Y/F5CoJnEBsfC50ifxvuMMmb9/8TtZYlrQMMOdgoQQ
1QY0ipYfysfzwZVUBFIt3nTztat5ZDLkAyARxpSyDLC7fJMNLraV4adPQ7RIZlZj
P9Q7Q6qPrGhhOGbutZMSP1z/+yIc+c86DC6Jx7KzTtlP8ZZdVCiH51wescFhLNn/
7PKtanDtcvminber8rI2pl90qX007oX6vnc54/sRQbHkQgH4MBannwy7TQ0xhrY=
=W0oE
-----END PGP SIGNATURE-----

--KS5V1uDxmEcBh2BA--
