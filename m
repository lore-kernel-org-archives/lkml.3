Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbaKTTje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:39:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56426 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbaKTTjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:39:33 -0500
Date: Thu, 20 Nov 2014 13:39:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Arjun Sreedharan <arjun024@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Message-ID: <20141120193949.GC23217@saruman>
Reply-To: <balbi@ti.com>
References: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2014 at 09:23:36PM +0530, Arjun Sreedharan wrote:
> When __of_usb_find_phy() fails, it returns -ENODEV - its
> error code has to be returned by devm_usb_get_phy_by_phandle().
> Only when the former function succeeds and try_module_get()
> fails should -EPROBE_DEFER be returned.
>=20
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  drivers/usb/phy/phy.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> index 045cd30..0310112 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
> @@ -191,7 +191,9 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct de=
vice *dev,
> =20
>  	phy =3D __of_usb_find_phy(node);
>  	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> -		phy =3D ERR_PTR(-EPROBE_DEFER);
> +		if (!IS_ERR(phy))
> +			phy =3D ERR_PTR(-EPROBE_DEFER);
> +	=09

trailing whitespace here. I'll fix it myself this time, but next time be
more careful.

cheers

--=20
balbi

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbkOFAAoJEIaOsuA1yqRE7JwQAI2xHHx/ZC7dSoGfuR9TWwF5
XCnBcU4phnYdQBmxkXTZcRf/idPolg6WQb6x++CrGdBtUYal2+EZhGzVyUZ9Apjj
MfJ5F3909f4xlmUPzM0C5BXqU3FQFxwv+c94VRWz+FRPW6Y6dNuhjhLe40GTowpy
N5K+KwA2TUq5dzylf5gw3yZcZJAJPQjh76arHoaDnvhWS/ztLfkT5z70Qh75gVlG
quP7QVSpNi94MJRC8DJ5oJCt7JdB2TiE9w2/EcFglajHO1koEXFD6wQhsBQlrq/j
3tUNBpoo1sWDDwl3peonvTTRHfzj3+fLIkiwgsRohQg7bac8yAnhJVgdEjrgh+SY
GhFkd9x/Q505YLOq4d1vA+wmDOh/QU0OLXgeNf3jBXlEaVteDLNDxBx3fU5O1D0C
cxvYigCbyHeoe8PjL98qtY7kJ3bhQhjQKCO6uZIJeIOXYOtbMmRDNzs1QgD85Eqp
5iEpAybZig1w4HKExuh67yr7iz0P4lfIfKxjNaZg6Edzu4T3BKgL0v+8/4KxV99K
EpBRK2b+scQpwgv7s+UYtEldr18qBy5jjFYWNMf/H6Gt5MSDAp8iFUvD34wUAd2r
5usOnNYqXVX1rqaJM8E+8UYCP/BBuKAxI0Ad8PNDaJQ7KLYr3xEEsTbDDh3sEKQE
gRAgEHdmOe+diAiTduPI
=jlPG
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
