Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872AbbA2FCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:02:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbA2FCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:02:48 -0500
Date: Wed, 28 Jan 2015 23:02:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] usb: add bus type for USB ULPI
Message-ID: <20150129050237.GA9098@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-2-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <1422025978-178336-2-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 23, 2015 at 05:12:51PM +0200, Heikki Krogerus wrote:
> @@ -6,4 +6,5 @@ obj-$(CONFIG_USB_COMMON)	  +=3D usb-common.o
>  usb-common-y			  +=3D common.o
>  usb-common-$(CONFIG_USB_LED_TRIG) +=3D led.o
> =20
> -obj-$(CONFIG_USB_OTG_FSM) +=3D usb-otg-fsm.o
> +obj-$(CONFIG_USB_OTG_FSM)	+=3D usb-otg-fsm.o

a bit of unrelated change here.

> diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
> index cc0ced0..c0fc3b5 100644
> --- a/drivers/usb/core/Kconfig
> +++ b/drivers/usb/core/Kconfig
> @@ -84,3 +84,11 @@ config USB_OTG_FSM
>  	  Implements OTG Finite State Machine as specified in On-The-Go
>  	  and Embedded Host Supplement to the USB Revision 2.0 Specification.
> =20
> +config USB_ULPI_BUS
> +	bool "USB ULPI PHY interface support"
> +	depends on USB ||=A0USB_GADGET

depends on USB_SUPPORT ?

> +int ulpi_register_driver(struct ulpi_driver *drv);
> +void ulpi_unregister_driver(struct ulpi_driver *drv);
> +
> +#define module_ulpi_driver(__ulpi_driver) \
> +	module_driver(__ulpi_driver, ulpi_register_driver, \
> +		      ulpi_unregister_driver)
> +
> +int ulpi_read(struct ulpi *ulpi, u8 addr);
> +int ulpi_write(struct ulpi *ulpi, u8 addr, u8 val);

no stubs ?

--=20
balbi

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUyb7tAAoJEIaOsuA1yqRENBAP/3BQrjcUu9QJ4beCjvJCcOg/
BfyCSguo4bQMc3FjGZDA33dZY9S+pGEtnz20pSyy4tpngDx8rsIAKkK91w2Ug7xe
Dnou/jMj5FmXnvZgPEwcUdM5JvInIwbtPjgMOAeFysKjb57B49iP69u0JLj6sMx7
CqIcSjMYg3LJ6/1fwfrN6+QO5vtTn7NlvO528aN+9xRuyO12BRYjQtNrgU8yblAX
JpOQV+u+ytUR09asIUiDOmvd4+f94yMZdqqbeQP7k5WK4NabI6oW9tyZMZlduOG5
r9KQgsWl4pMIe483zkULFnU/0il+Oxu4hY6iiMdXUl/KOsp9KNg7M0r3sQDKsItw
hOo/R5zTFvdg9S/wyoxhEfsSKl5NAOB+8SiYGonl8+veU6a/Q0k6LccWQnl5JPlW
yvXBVDyEmaDFF8d46tyNyEIGa85fh1LNU1AvMLAJ2AYL0SHOFnqj5tubKH7KvYF2
1Zdp357TIVF80wheyiY8DdJjuhxID2kfPtYZAnD6//lACkAsAWRUzKIvfw7SYsij
BQpz1WEoVM9Oc11B1eEFnnXURHupaOnI7dkiFR4wbkAoPZ7VY8yLpb2gAq2m5WCw
ujeeueIeWEQZmTSqynYeojHGitvQqzEueRikDgIq18Y5LSNRk7xuzNxoExpVr0gH
0eLQlGRkrdEE0HpzN+bc
=8/Hx
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
