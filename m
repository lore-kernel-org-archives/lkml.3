Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbbA0PV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:21:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45921 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbbA0PVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:21:25 -0500
Date: Tue, 27 Jan 2015 09:20:47 -0600
From: Felipe Balbi <balbi@ti.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Ola Jeppson <ola@adapteva.com>,
        <linux-gpio@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] usb: phy-generic: Don't fail on missing gpio reset
Message-ID: <20150127152047.GA13776@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422323129-20969-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1422323129-20969-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2015 at 05:45:29PM -0800, Soren Brinkmann wrote:
> A reset through a GPIO is optional. Don't fail probing when it is
> missing.
>=20
> Reported-by: Andreas F=E4rber <afaerber@suse.de>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi Andreas,
>=20
> does this do the trick?
>=20
> 	Thanks,
> 	S=F6ren
>=20
>  drivers/usb/phy/phy-generic.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
> index dd05254241fb..a73d4c738f0b 100644
> --- a/drivers/usb/phy/phy-generic.c
> +++ b/drivers/usb/phy/phy-generic.c
> @@ -241,10 +241,8 @@ int usb_phy_gen_create_phy(struct device *dev, struc=
t usb_phy_generic *nop,
> =20
>  	if (err =3D=3D -EPROBE_DEFER)
>  		return -EPROBE_DEFER;
> -	if (err) {
> -		dev_err(dev, "Error requesting RESET GPIO\n");
> -		return err;
> -	}
> +	if (err)
> +		nop->gpiod_reset =3D NULL;

there's a better patch to use gpiod_get_optional(), instead.

--=20
balbi

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx6zPAAoJEIaOsuA1yqREIZsQAKqQcHbwfPNixQ93RQPXhV3x
au60/mtVkYNza+ZtJgPakyLMR06f/j8xuZXirVC3qzPq8mmugpqUTTzKf5I3kNtv
3Rdt9DvrVY+hGOxiCPmd+gjKe1BLvosjuUa6DzF+6LQulQEDFIhq6pOfYlbPm79I
XGahyK0/BWhBMzQsjX3/Vto7kgVOe5W899yU70K1qIqjUOnwZGGyYOifa0yIGkjM
2uU3fYryeAD03cmyN5E/4MnHmDnGai6xakoNBZFBaLH3FQX9B02jPPOa3tXGatvi
+KIB1GBHqiTWo7lDldlpM2+HB9RNBdVzdEXm/uRu2OYY/wq0KpoxryZ8Vozs4BIU
jq5SH6Bt/5TyXmUzQNqbQ6J2KPzD6x0tMrp9a4kfKStN2OCXJN3hdleCYY+z52j0
XBQWDvZ3IhkGeYQmbYDBITVeuYV7WcX6LNkUexpyh3h+EK1qRHP3jwksAo1Y2J7R
jXyG0Df1ozUiROgTQyDFYLvRFeXNyhmCYp1nwlOBNbbtXkxmI/l7b/2fImov/Pnp
Utu0GXzGfAfI+cCkci7hc37FnGCnRXMEjfbzuSwvy6ASBGBbK4nK6mXI0/xRj8gO
DrFPR4hxvUYjz+fihh/yUr7i7iIOLamdcvMpWLRol4gTcpVFtVGofdz4b8de38jh
t+fNXkMMRA8fZZU+ERir
=CBzx
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
