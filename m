Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab3CNQIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:08:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52820 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603Ab3CNQII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:08:08 -0400
Date: Thu, 14 Mar 2013 18:07:56 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: remove MACH_OMAP_H4_OTG
Message-ID: <20130314160756.GD3001@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363032881.3137.101.camel@x61.thuisdomein>
 <20130314141301.GI26080@arwen.pp.htv.fi>
 <1363272657.1335.79.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <1363272657.1335.79.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2013 at 03:50:57PM +0100, Paul Bolle wrote:
> On Thu, 2013-03-14 at 16:13 +0200, Felipe Balbi wrote:
> > On Mon, Mar 11, 2013 at 09:14:41PM +0100, Paul Bolle wrote:
> > > diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> > > index 5a0c541..c65b5e2 100644
> > > --- a/drivers/usb/gadget/Kconfig
> > > +++ b/drivers/usb/gadget/Kconfig
> > > @@ -194,7 +194,7 @@ config USB_FUSB300
> > >  config USB_OMAP
> > >  	tristate "OMAP USB Device Controller"
> > >  	depends on ARCH_OMAP1
> > > -	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4=
_OTG
> > > +	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
> >=20
> > could you, instead, just remove the entire line ? we have an overuse of
> > select and this is one of those cases where it doesn't make sense.
>=20
> Sure, but there's one problem: I need to come up with a descriptive
> summary. "Remove "select" because Felipe told it makes no sense" might

heh :-) that'd look very funny 10 years from now ;-)

> not be good enough. Any hint why you think this entire line can be
> dropped?

How about:

"An improper use of 'select' has been proliferating through a bunch of
Kconfig files, this is just one instance of such case which prevents the
particular PHY driver to be enabled as a dynamically loaded module.

Users of the omap_udc, or any other UDC, should know that PHYs need to
be enabled in order for proper functionality. Based on that, we're
dropping the entire 'select' statement which will also remove warnings
further down the line when the PHY layer re-write is finished."

Sounds good to you ?

--=20
balbi

--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQfXcAAoJEIaOsuA1yqREGosP/3RGtJsnaKDoG6Beu5a1jmQS
Crcw4+PHi1o6lFpV4T7NIetZiaYDkdIjgrJrTmGFqpMnsEO4St0NTGuVG8Al/pl7
MbQCv8eHf6x1myKBGVYpgUKIvz47VshNHW1pGoKH+YXOAe4fduy2LEsSSgeXEo+r
xyE72cKfdbps+a8Y+zF/eL69yNwhMQfZp7cLIgUYQP0bAP5oszxRkdBIehFgZeQf
8i+3Fr/5nfik0j/QdI5gt/RVEl4QR+SMwwW5CrPQYNFbwwdVMQnbahGq4PwPYocr
odsRQxtXvuyV/c+ZOZdaCjw/yFeGF55COEbez0rtnaFr90Ul8qKyOWwI24GbEow7
mPzyaDUPHEDxItpR+2N1dfqB+Uy2Ij35XPwgqLlfDgKdbRKBYLsqCuDl0IuXBmCJ
gWSJQP8l40r4IlTv+9q8R2ecy0UXT7ArGLDafM1cH+XVZ3YYI4nrU6oySt3qyUqM
ZjaH8aspH3noOqjjjzLtZWUCNgPhUjCqW1o11u56S+iSUxgOh26LPb3omJJBsLxU
PzHTxH3Hg6OLJeW9yRedndnIgxjHfhW8DRF8XXBpnKen+W57/LKjL0L8kdQiy609
donqNAN23jCYoKGPzRH/lhOBr174LaFtJjBV6SmmzaLjpMk5z6TMYj6f8pG0cuzD
H0ZV5D4Qd5wPjCMZHtje
=MZfb
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--
