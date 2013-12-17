Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3LQAUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:20:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52588 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3LQAUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:20:21 -0500
Date: Mon, 16 Dec 2013 18:19:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Joe Perches <joe@perches.com>
CC: Felipe Balbi <balbi@ti.com>, <lee.jones@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH 05/10] mfd: menelaus: Use for_each_set_bit()
Message-ID: <20131217001911.GE29284@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131216153936.GQ18769@lee--X1>
 <1387238904-7843-1-git-send-email-balbi@ti.com>
 <1387238904-7843-5-git-send-email-balbi@ti.com>
 <1387239455.18217.61.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0ZfoUVt4BxPQnbU"
Content-Disposition: inline
In-Reply-To: <1387239455.18217.61.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--o0ZfoUVt4BxPQnbU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2013 at 04:17:35PM -0800, Joe Perches wrote:
> On Mon, 2013-12-16 at 18:08 -0600, Felipe Balbi wrote:
> > That macro just helps removing some extra line of code and hides ffs()
> > calls.
> >=20
> > While at that, also fix a variable shadowing bug where 'int irq' was
> > being redeclared inside inner loop while it was also argument to
> > interrupt handler.
> >=20
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/mfd/menelaus.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> > index 87d80a8..d3e3022 100644
> > --- a/drivers/mfd/menelaus.c
> > +++ b/drivers/mfd/menelaus.c
> > @@ -795,24 +795,22 @@ static irqreturn_t menelaus_irq(int irq, void *_m=
enelaus)
> >  {
> >  	struct menelaus_chip *menelaus =3D _menelaus;
> >  	void (*handler)(struct menelaus_chip *menelaus);
> > -	unsigned isr;
> > +	unsigned long isr;
> > +	unsigned long i;
> > =20
> >  	isr =3D (menelaus_read_reg(MENELAUS_INT_STATUS2)
> >  			& ~menelaus->mask2) << 8;
> >  	isr |=3D menelaus_read_reg(MENELAUS_INT_STATUS1)
> >  		& ~menelaus->mask1;
> > =20
> > -	while (isr) {
> > -		int irq =3D fls(isr) - 1;
> > -		isr &=3D ~(1 << irq);
> > -
> > +	for_each_set_bit(i, &isr, 16) {
> >  		mutex_lock(&menelaus->lock);
> > -		menelaus_disable_irq(irq);
> > -		menelaus_ack_irq(irq);
> > -		handler =3D menelaus->handlers[irq];
> > +		menelaus_disable_irq(i);
> > +		menelaus_ack_irq(i);
> > +		handler =3D menelaus->handlers[i];
> >  		if (handler)
> >  			handler(menelaus);
> > -		menelaus_enable_irq(irq);
> > +		menelaus_enable_irq(i);
> >  		mutex_unlock(&menelaus->lock);
> >  	}
> > =20
>=20
> This could handle the irqs in reverse order.
> Does that matter?

order does not matter with this device.

--=20
balbi

--o0ZfoUVt4BxPQnbU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr5h/AAoJEIaOsuA1yqRElt0P/jwy3WbKRD0V70dt5odZ4WZ8
5zKYbmHfyX7hPDoKp8I/Mub6KNMMvU4ulYiHEKeJtXfZX+m6dSLBpoo7Pn0O+nWo
CzyP8jZau62TQFqS5UaLK5sRAeIf9p+E4zdYt2vGiKRCRvqyNa1LKqkJYsbIhvj4
v8ehgDZ8g8pIa6XBDLmbzpBOoINHqpjbspDldOWt2cYo68lD7I/DYhhGaxCZ1/36
yfP4K7xDqlYQz9ewiUlq7Krq7TRDhoV3BVFQ3s9pm68cC/ggdfRQH2bIa5cxv4Vv
4cYSo9DYFKPs2PZWyQUvxUgKBO1DIAirQsoLeEnT99UMiC2gNrkbwRh0PingkQr6
lhwGh5uqEMOAx9KkjBXy8RFcO1F+7njTUAHB22nvXCGHeCkyK585kdmIaNDLbT7O
fpj13TCJvO+Ml0DrwgSZ73fn2LnrAjz4TFl4AaMtjeRmI+9xqjeWEEqmbaGsLGAT
DyMjBsSs9cf5zKEgAhRuNiY2/BLvASa11XOTTn6GQEInMbjHhlw3yCKitT29WyIj
UuD5IVADa38jcxK5QN57TJ4GgKPmAoAPZ28C7i5hcBghV/wx4hTLM0tJHP5Ia3j8
vyL+Sg6OPDIn901UrOAjLkftFHLfLM5UCCntwqJQgRcY+6fJ5rKN+c9L0mKwjjth
VROTD5D2clmKU8ujGIOz
=e9ap
-----END PGP SIGNATURE-----

--o0ZfoUVt4BxPQnbU--
