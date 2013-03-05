Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3CEWWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:22:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54977 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3CEWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:22:48 -0500
Date: Wed, 6 Mar 2013 00:22:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arm@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/9] usb: gadget: fix omap_udc build errors
Message-ID: <20130305222224.GA26278@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <1362521809-22989-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 05, 2013 at 11:16:44PM +0100, Arnd Bergmann wrote:
> 1bf0cf6040 "usb: gadget: omap_udc: convert to udc_start/udc_stop"
> made some trivial changes but was missing a ';' character.
>=20
> 8c4cc00552 "ARM: OMAP1: DMA: Moving OMAP1 DMA channel definitions
> to mach-omap1" added a definition for OMAP_DMA_USB_W2FC_TX0 to
> the driver while making the header file it was defined in
> unavailable for drivers, but this driver actually needs
> OMAP_DMA_USB_W2FC_RX0 as well.
>=20
> Both changes appear trivial, so let's add the missing semicolon
> and the macro definition.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/usb/gadget/omap_udc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
> index 06be85c..f844565 100644
> --- a/drivers/usb/gadget/omap_udc.c
> +++ b/drivers/usb/gadget/omap_udc.c
> @@ -62,6 +62,7 @@
>  #define	DRIVER_VERSION	"4 October 2004"
> =20
>  #define OMAP_DMA_USB_W2FC_TX0		29
> +#define OMAP_DMA_USB_W2FC_RX0		26
> =20
>  /*
>   * The OMAP UDC needs _very_ early endpoint setup:  before enabling the
> @@ -1310,7 +1311,7 @@ static int omap_pullup(struct usb_gadget *gadget, i=
nt is_on)
>  }
> =20
>  static int omap_udc_start(struct usb_gadget *g,
> -		struct usb_gadget_driver *driver)
> +		struct usb_gadget_driver *driver);

good catch, thanks. I'll queue it for v3.6-rc3. Make sure to Cc
linux-usb for anything under drivers/usb/ though

--=20
balbi

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNnAgAAoJEIaOsuA1yqREn5wP+wc5Ycera0NmG7fUJxZmVlk8
XCyeY8dEXasbbpqD8tjRAqTiu3kLJh/WoSkHsGbCh1b8B2JK+rdbz3mWamPE1ix5
mPuRDKxiSSjua6P1/9sOY5G6utlSx8PhlvolETTsjt5IeK3pHGqKEsAcavH2PGcg
pFs/ZfQioVQcg57Eb+Nih6qyvqd8/gPBTEXwp9kZEXMbYVrTzmPAXD35KrqX4h/W
R+1K0qoikwTWEwC5zs35U7H7V3Z09exrC4S35MO2K+8vyw8DQlrFZBHRQaC9yKvA
cJU1cT2ygFnzyB9bXIqCcXissQvEESo0SMyxCKs1SGG71UuaawgTyzHXY0qhU4XP
GF492hEBIXfke8R/tmsYZ0TncSEgpAYrzKZtYh0ICdE7C29cXFYqPTqP06tthifD
fRxXWsqqnrCAxLepQzdgaQ9KNukfSeXTE+bcK4f0U2/V8eRWxGOSZJXilZv1pJQY
/+7NVFLaBpi/mhSW/UwDVXyJL7Im0bHir46BJEq55KuaK/ljFrlr3YSC+/bubWoS
4tn3BdomqFhleOa3+2JT08svTqnBYg9tVGwtQiFeDHY2c5Ruanzol5xkfuyTKi5Q
spra3heBk62bgQx7K59ENRgTOgrMtriSkzd0u4Jiw4LtDflzGZWMfHUA7bTuvL0j
yuBBZvFqmxqBbqDHQOSk
=BuQ2
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
