Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3LWRMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:12:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53178 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab3LWRMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:12:17 -0500
Date: Mon, 23 Dec 2013 11:11:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: Felipe Balbi <balbi@ti.com>, Robert Baldyga <r.baldyga@samsung.com>,
        <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH v5] usb: gadget: Add UDC driver for Aeroflex Gaisler
 GRUSBDC
Message-ID: <20131223171122.GI28679@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387799858-11036-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+9faIjRurCDpBc7U"
Content-Disposition: inline
In-Reply-To: <1387799858-11036-1-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+9faIjRurCDpBc7U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 23, 2013 at 12:57:38PM +0100, Andreas Larsson wrote:
> This adds an UDC driver for GRUSBDC USB Device Controller cores available=
 in the
> GRLIB VHDL IP core library. The driver only supports DMA mode.
>=20
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

You have a few Sparse Warnings:

drivers/usb/gadget/gr_udc.c:1255:13: warning: incorrect type in argument 1 =
(different address spaces)
drivers/usb/gadget/gr_udc.c:1255:13:    expected void [noderef] <asn:2>*<no=
ident>
drivers/usb/gadget/gr_udc.c:1255:13:    got unsigned int *<noident>
drivers/usb/gadget/gr_udc.c:1284:16: warning: incorrect type in argument 1 =
(different address spaces)
drivers/usb/gadget/gr_udc.c:1284:16:    expected void [noderef] <asn:2>*<no=
ident>
drivers/usb/gadget/gr_udc.c:1284:16:    got unsigned int *<noident>
drivers/usb/gadget/gr_udc.c:1136:28: warning: context imbalance in 'gr_ep0_=
setup' - unexpected unlock
drivers/usb/gadget/gr_udc.c:1052:1: warning: "/*" within comment [-Wcomment]
 /* Must be called with dev->lock held and irqs disabled

Two of them I fixed below:

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index ee220f3..5eb36af 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -218,7 +218,7 @@ config USB_FOTG210_UDC
=20
 config USB_GR_UDC
        tristate "Aeroflex Gaisler GRUSBDC USB Peripheral Controller Driver"
-       depends on OF && HAS_DMA
+       depends on HAS_DMA
        help
           Select this to support Aeroflex Gaisler GRUSBDC cores from the G=
RLIB
 	  VHDL IP core library.
diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index 4f99a61..9ac378a 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -1049,9 +1049,11 @@ static void gr_ep0out_requeue(struct gr_udc *dev)
 /*
  * The main function dealing with setup requests on ep0.
  *
-/* Must be called with dev->lock held and irqs disabled
+ * Must be called with dev->lock held and irqs disabled
  */
 static void gr_ep0_setup(struct gr_udc *dev, struct gr_request *req)
+	__releases(&dev->lock)
+	__acquires(&dev->lock)
 {
 	union {
 		struct usb_ctrlrequest ctrl;

The other two are seem like they would require a much larger code
change. Why are you passing integers as arguments to IO access
functions ? You should be passing void __iomem *.

Dropping for now.

--=20
balbi

--+9faIjRurCDpBc7U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSuG66AAoJEIaOsuA1yqREzAkP/RX79LASkX7c5etvKLglnjqf
/aOAGDg75yV7K3mOsw7e747whmSuWoaBObP27lLpv/UyJiLotVGmdJa2pH45Fxo4
Syc6+c4OW4unPMcsl2j+t3TG+8J1bqErt5o9OYeUHnR5xxG00vsIQxIieNGGfKOk
pa67230rgRbwJgIggRAZBNMs2XsUSJgA8Vqtxa4HIll5Yc8YyfTXr61HqLJIx+UY
Vr7tuaq3YJ8w4QKCfCCgXC3VjUA5OwFmYFcFvmBTBkRD/AzNOL1smFS/X+sSZpnM
04aJamxScJsrUclXfEd8jFraSqUMTqC3U0vl76DsysEjso1TC57SGkuxpuY4lR2c
c3VfVxSREBDho8tbkZSk4nWsoaTwZL7qQ88VKrU7Y9owPA0I9BGRt7DjPITLYEpp
TDCvLkNhqAomeYM2zfSz6RijqmMB52otFPqjl9GQDw10rD6W8urxMP1DSPVBYH1J
dLeLgkCARvQqoeGyHYBAveSm/wgbMjZW10vROv92oGomNnkA4A6Ic5DZabSI+yQ4
TxV2GPJhlwkgOg96+lrpz0f3EZgGl9FlqXwyUWHDvJ2TWtNMk8/4G97H4UsoY+Gx
Fr0It0+nIVWPxYXjJUztb7bpCAu7fTI9ZB7aj7aDN3ryCMAq5yQLvE7HYq5tnWFN
4M49I1nfUVileGWDUykI
=zMte
-----END PGP SIGNATURE-----

--+9faIjRurCDpBc7U--
