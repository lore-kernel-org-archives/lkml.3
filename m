Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbaCQLPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:15:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57190 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932743AbaCQLPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:15:04 -0400
Date: Mon, 17 Mar 2014 12:10:39 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/3] irqchip: sun4i: Simplify irq mapping
Message-ID: <20140317111039.GF27873@lukather>
References: <1394740202-1952-1-git-send-email-hdegoede@redhat.com>
 <1394740202-1952-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <1394740202-1952-3-git-send-email-hdegoede@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 08:50:01PM +0100, Hans de Goede wrote:
> Now that we're using handle_fasteio_irq for all interrupts, we can get rid
> of having 2 irq_chip structs by making sun4i_irq_ack a nop for all irqs
> except irq 0.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/irqchip/irq-sun4i.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
> index 0a71990..6a8c88d 100644
> --- a/drivers/irqchip/irq-sun4i.c
> +++ b/drivers/irqchip/irq-sun4i.c
> @@ -45,6 +45,9 @@ static void sun4i_irq_ack(struct irq_data *irqd)
>  	int reg =3D irq / 32;
>  	u32 val;
> =20
> +	if (irq !=3D 0)
> +		return; /* Only IRQ 0 / the ENMI needs to be acked */
> +
>  	val =3D readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
>  	writel(val | (1 << irq_off),
>  	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
> @@ -74,24 +77,8 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
>  	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
>  }
> =20
> -/*
> - * Since sun4i and sun5i are single core SOCs there is no need to mask n=
on
> - * oneshot IRQs, to achieve this we use handle_fasteoi_irq with a dummy =
eoi.
> - */
> -static void sun4i_irq_dummy_eoi(struct irq_data *irqd)
> -{
> -}
> -
>  static struct irq_chip sun4i_irq_chip =3D {
>  	.name		=3D "sun4i_irq",
> -	.irq_eoi	=3D sun4i_irq_dummy_eoi,


Is it just me or did you just remove the code you added in patch 1?

Patches 1 and 2 can be easily squashed.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTJtgvAAoJEBx+YmzsjxAg/XcP/AswSJbOOE0tac2QtjDP8g+2
voZVmZpHSTltmEN/i4Mtg82z+g+qy0lRjq9655yAxaKvuxFuZhaev/zo3EOLsduv
ywi4jhV3ddCmVYKhWGnjF5iaQCw6DfWsCuiupocLHCiqdqfn7SPKdzzhz2Hob817
KKZUYMLGnIn59UE37R4Vg2vy+IOJ2aHnZeCiNMCoOLVXsEMNV6bAzPKI/N2igg1Z
ufQZq9NQktwqlXJCCtV7OreEtPLMkML8uVne84hAWx5U8Sxcb7QqIkchY1mSnaeV
8yN6zWnt+1u1232JtbIppdJfhp24+RNv2vQquf3PqyTIzLM9tBsKlBbZDt51n/3h
JeYk6T/s1nZnvTW0dZXVLNdWkeVZs0ETL7PaK5iHOxyhzX/T0LvhFzu7ffLDBfl9
Di3iND4xJjpMElG/gHMNsBWwEP0vsz6maLd8HkGSyK73OFlTbNipzObtStUqT3uz
TJJMPEBCys3F0WBVK8tnE5jZ6ektQQ8hXX/XndG28XRvZ0bgGictyb3MGFQoD3k+
2H1aJrhiBwBENveGMN6ie0KDugZsLwBQ/n+5tTMtV9NABVByi8qVxUul+twRO/qE
Fml519Q0H9hrwXcvdwFG0NAhp725SahyIMW8jVsaLH2MBwYtK6upJiPgJnrgtKSW
3xGYtz+lBiG7I4H7vTiS
=OLVh
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
