Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbbANRk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:40:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38517 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbANRkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:40:23 -0500
Date: Wed, 14 Jan 2015 11:39:06 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 12/12] usb: gadget: at91_udc: Allocate udc instance
Message-ID: <20150114173906.GL16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-13-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DMotDPdpQlD4ewOK"
Content-Disposition: inline
In-Reply-To: <1421252524-24452-13-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DMotDPdpQlD4ewOK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 05:22:04PM +0100, Alexandre Belloni wrote:
> From: Boris Brezillon <boris.brezillon@free-electrons.com>
>=20
> Allocate udc structure instead of relying on the statically declared
> object.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/udc/at91_udc.c | 96 +++++++++++----------------------=
------
>  1 file changed, 26 insertions(+), 70 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/a=
t91_udc.c
> index c0abb9bc76a9..6d285226ab94 100644
> --- a/drivers/usb/gadget/udc/at91_udc.c
> +++ b/drivers/usb/gadget/udc/at91_udc.c
> @@ -59,7 +59,15 @@
>  #define	DRIVER_VERSION	"3 May 2006"
> =20
>  static const char driver_name [] =3D "at91_udc";
> -static const char ep0name[] =3D "ep0";
> +static const char * const ep_names[] =3D {
> +	"ep0",
> +	"ep1",
> +	"ep2",
> +	"ep3-int",
> +	"ep4",
> +	"ep5",
> +};
> +#define ep0name		ep_names[0]
> =20
>  #define VBUS_POLL_TIMEOUT	msecs_to_jiffies(1000)
> =20
> @@ -1497,74 +1505,6 @@ static irqreturn_t at91_udc_irq (int irq, void *_u=
dc)
> =20
>  /*----------------------------------------------------------------------=
---*/
> =20
> -static struct at91_udc controller =3D {
> -	.gadget =3D {
> -		.ops	=3D &at91_udc_ops,
> -		.ep0	=3D &controller.ep[0].ep,
> -		.name	=3D driver_name,
> -	},
> -	.ep[0] =3D {
> -		.ep =3D {
> -			.name	=3D ep0name,
> -			.ops	=3D &at91_ep_ops,
> -		},
> -		.udc		=3D &controller,
> -		.maxpacket	=3D 8,
> -		.int_mask	=3D 1 << 0,
> -	},
> -	.ep[1] =3D {
> -		.ep =3D {
> -			.name	=3D "ep1",
> -			.ops	=3D &at91_ep_ops,
> -		},
> -		.udc		=3D &controller,
> -		.is_pingpong	=3D 1,
> -		.maxpacket	=3D 64,
> -		.int_mask	=3D 1 << 1,
> -	},
> -	.ep[2] =3D {
> -		.ep =3D {
> -			.name	=3D "ep2",
> -			.ops	=3D &at91_ep_ops,
> -		},
> -		.udc		=3D &controller,
> -		.is_pingpong	=3D 1,
> -		.maxpacket	=3D 64,
> -		.int_mask	=3D 1 << 2,
> -	},
> -	.ep[3] =3D {
> -		.ep =3D {
> -			/* could actually do bulk too */
> -			.name	=3D "ep3-int",
> -			.ops	=3D &at91_ep_ops,
> -		},
> -		.udc		=3D &controller,
> -		.maxpacket	=3D 8,
> -		.int_mask	=3D 1 << 3,
> -	},
> -	.ep[4] =3D {
> -		.ep =3D {
> -			.name	=3D "ep4",
> -			.ops	=3D &at91_ep_ops,
> -		},
> -		.udc		=3D &controller,
> -		.is_pingpong	=3D 1,
> -		.maxpacket	=3D 256,
> -		.int_mask	=3D 1 << 4,
> -	},
> -	.ep[5] =3D {
> -		.ep =3D {
> -			.name	=3D "ep5",
> -			.ops	=3D &at91_ep_ops,
> -		},
> -		.udc		=3D &controller,
> -		.is_pingpong	=3D 1,
> -		.maxpacket	=3D 256,
> -		.int_mask	=3D 1 << 5,
> -	},
> -	/* ep6 and ep7 are also reserved (custom silicon might use them) */
> -};
> -
>  static void at91_vbus_update(struct at91_udc *udc, unsigned value)
>  {
>  	value ^=3D udc->board.vbus_active_low;
> @@ -1872,15 +1812,31 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  	struct at91_ep	*ep;
>  	int		i;
> =20
> +	udc =3D devm_kzalloc(dev, sizeof(*udc), GFP_KERNEL);
> +	if (!udc)
> +		return -ENOMEM;
> +
>  	/* init software state */
> -	udc =3D &controller;
>  	udc->gadget.dev.parent =3D dev;
>  	at91udc_of_init(udc, pdev->dev.of_node);
>  	udc->pdev =3D pdev;
>  	udc->enabled =3D 0;
>  	spin_lock_init(&udc->lock);
> =20
> +	udc->gadget.ops =3D &at91_udc_ops;
> +	udc->gadget.ep0 =3D &udc->ep[0].ep;
> +	udc->gadget.name =3D driver_name;
> +	udc->gadget.dev.init_name =3D "gadget";
> =20
> +	for (i =3D 0; i < NUM_ENDPOINTS; i++) {
> +		ep =3D &udc->ep[i];
> +		ep->ep.name =3D ep_names[i];
> +		ep->ep.ops =3D &at91_ep_ops;
> +		ep->udc =3D udc;
> +		ep->int_mask =3D BIT(i);
> +		if (i !=3D 0 && i !=3D 3)
> +			ep->is_pingpong =3D 1;
> +	}
> =20
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	udc->udp_baseaddr =3D devm_ioremap_resource(dev, res);
> --=20
> 2.1.0
>=20

--=20
balbi

--DMotDPdpQlD4ewOK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtqm6AAoJEIaOsuA1yqREqxIP/jGDzrp38DAaM5yFahmrOUoQ
hX2yUQAoEkWRInFdvf1YWzb927BzwbRw1Bl4rx1Yo4FtHLfOOG5oOy6gdab9KViT
czI8kI5Oph1YFP5tVT+Te3n88h8B46xl8kEKpxKHvEKeszHRda8l2IqdOBWFSsjR
4ZlnJC44KKXzgcOs2hXpxdyidTm9ZtfheoE/8cam4BL16wXstbi8TXaZAyu7lbLp
TLTKDnGVMlNOFChL/1RyId6zi43jl3vG7ZVlCSqUZtPbVrrhhcV+18Inh/sk116b
poF1gDgwZr3kfPnbafzY0VuRHBBhYpCxThF+ywYsXLkq5iDgoRZ9VleMBSC69nvT
tEXl7cBAj018+c08455XwDWh468NNJ8QZUAo0KspnfaXZ9NbaiEfR8EEsBpDzP+k
AOdGb4ZrdL6BWkVeZsLMQD+JObCk7jGB3FP/9KTIlGFkzeQSo7UJt3e/HiYWaVja
W42ewE5V5rM4yuZNj2nrRjPpIXY4klYv0wMk/+dyyoeN4di6ekYoe40wlkN4Iybc
BBR3xitggz1qp8Tf6fOZwywurvzjVG4hsudNUdFPpDoVgfgkJ7JqUq5TNMgB5Cxv
bPeMzPRLOOOL2ws/2dwMa2nc1pbYX1qQ9hbJw20VZ5gBqwiesJJhkXp7nJoNXwKN
r0K3f5NA0TxXaW2uFk09
=/a9C
-----END PGP SIGNATURE-----

--DMotDPdpQlD4ewOK--
