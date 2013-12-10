Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3LJQgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:36:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53564 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab3LJQf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:35:59 -0500
Date: Tue, 10 Dec 2013 10:34:46 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 15/15] mfd: menelaus: Use devm_request_threaded_irq()
Message-ID: <20131210163446.GH22750@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-15-git-send-email-balbi@ti.com>
 <20131210093042.GU12675@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Content-Disposition: inline
In-Reply-To: <20131210093042.GU12675@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 09:30:42AM +0000, Lee Jones wrote:
> On Mon, 09 Dec 2013, Felipe Balbi wrote:
>=20
> > By using devm_request_threaded_irq() we can drop a few extra lines of
> > code and rely on device managed resources layer to free our IRQ for us.
> >=20
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/mfd/menelaus.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> > index bffe978..b87c2bd 100644
> > --- a/drivers/mfd/menelaus.c
> > +++ b/drivers/mfd/menelaus.c
> > @@ -1271,8 +1271,8 @@ static int menelaus_probe(struct i2c_client *clie=
nt,
> >  	/* Set output buffer strengths */
> >  	menelaus_write_reg(m, MENELAUS_MCT_CTRL1, 0x73);
> > =20
> > -	err =3D request_threaded_irq(client->irq, NULL, menelaus_irq,
> > -			IRQF_ONESHOT, DRIVER_NAME, m);
> > +	err =3D devm_request_threaded_irq(&client->dev, client->irq,
> > +			NULL, menelaus_irq, IRQF_ONESHOT, DRIVER_NAME, m);
>=20
> No need for a separate patch here. Convert straight from request_irq()
> to devm_request_threaded_irq() in patch 3.

that would be 2 changes in a single patch.

--=20
balbi

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSp0KmAAoJEIaOsuA1yqREaUgP/397L2BKhPwqbkADcEPbTr9y
Bnf3bfx+jXNU/wb6ntprvrwUDdZ0llQBt2Pq47ZNiei+qb92paFXilVi9M+BXzuu
VEZUd4QMbkBeJvF2o8llkhTkQIIV5sv/itdBR3Y3HXnCz9VlsFSGtXuU+3E2+OxY
AgrrprfXuSlPkWkGJg4t7b1eX1wUW6pGo3ra4OVTxhOrldfTyBDAA3rkGI6akys2
5bLdo0ugVwqRXVnJm2PWrDg2SCmFvQZIj7dkczF20oIRBm0pvzbWLLsxpjnLiqx6
Niy3W7wgBmp78nUGC9aWeub/tUQVetggY+xpjFn+YYmj+ne5MU2cpqsjPn1US6De
P56r1Nro+3rVkL8Uq3G57aajvcoIqEAxknoQ3o/XIdMn5UotCH5rziHvruHqbcyT
iUzkJrOH2EoF46M/GGwJ61w/WYqBO9UUGSWCxw1/GWJTwWi///XJL9ZnBLxoTYHz
fCxgoLAbXbl74mdd/ijwxRG5gRcbE2r/Dk5pL0PnZOJyNSQXbq3H1I3So5j8JpJL
eAmPTMkcaZO1758u3zshQKBXyL3f69T1LbSEWCr5p7ewUshI1MwQnZEzKxe8YQT8
8vPzY5DFCS7m+IVk5hLkKKko3maLCcwKfBFsn/QsPPyCZRSkeTQ9CaL47Q0ALsCV
YhznB8jExDtedhArDw4L
=NN90
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
