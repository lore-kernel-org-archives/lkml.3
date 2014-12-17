Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaLQIaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:30:09 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:63105 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLQIaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:30:07 -0500
Date: Wed, 17 Dec 2014 09:30:03 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
Message-ID: <20141217082958.GC3303@ulmo>
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2014 at 01:06:07PM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
> failure") broke platforms that rely on deferred probing to order probing
> of PHY and host controller drivers. The reason is that the commit simply
> propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
> PHY has been registered yet for a given device tree node. The only case
> in which -EPROBE_DEFER would now be returned is if try_module_get() did
> fail, which does not make sense.
>=20
> The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
> registered yet. The only condition under which it makes sense to return
> -ENODEV is if the device tree node representing the PHY has been
> disabled (via the status property) because in that case the PHY will
> never be registered.
>=20
> This patch addresses the problem by making __of_usb_find_phy() return an
> appropriate error code while keeping in line with the above-mentioned
> commit to propagate error codes rather than overwriting them. At the
> same time the check for a valid PHY is decoupled from the check for the
> try_module_get() call and a separate error code is returned if the
> latter fails.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/usb/phy/phy.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Ping?

Thierry

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUkT8GAAoJEN0jrNd/PrOhhVQQAJxoogV6JSuZWkgj38Mp0iGE
Fqxstu5ojj7UUQPO4EfDgNBJzkQ84qHOPEnA0/xCTWu9lyAsxWx12JEM71pWMMXW
qd1nrJghtCgG37a0OzCVWoLyJzj1+AqrbMFYdpwSQ333jpdrpoE6BBjXDE+qkICZ
7i9AM76z1uIz2vvR0JI5xSWemfIFS/UTGPwVA3oRG53B1i5YrG0A2BMvlO2MdSNk
DJaCopoU1qQuYPD8RUkJ3LKBPgfzepJl8GVrW2cS/jKDB/29UF/KSduVmwdzZMAv
zOLYg3Vj5hGX9zOHlukUHBKqo6DULcsrOQSva7pZv7LRo9/v9USIx0lQkq9ymsEV
M+wAltcafzKbunejzof8V7WKkhK5jiLlyoalTk+kW+6Bzh5btCZqZGI4vtsGWNto
+6QlwOu+REfZzBxeNFGq0OGkuAAJ/3DHQdxwdXh/pe5GLjTCJ/ejdU/7EZOce83R
kjDoYELJphdsMMvS2Ax1UW9iOAt2xj+HQx0H8+t0jfhB0D80Vwt3m2aW7Hxfchq/
ImatHMqEskxHC++3Zc3Px5VMPjeyGMlez4lJhYLij43PWUtVVb9y/Ja4jNGf4BaE
J373iSv2XnruiXWVdVwSxh/3nQj/YMhUdYVS6gxZ8/54aT8FYiO3k0NOIU7OuwG4
Ca/TGCHeJEPjrrCRsrEo
=g7QQ
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
