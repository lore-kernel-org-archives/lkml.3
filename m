Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3CFIGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:06:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55549 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3CFIGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:06:13 -0500
Date: Wed, 6 Mar 2013 10:05:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arm@kernel.org>, Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/9] usb: gadget: fix omap_udc build errors
Message-ID: <20130306080546.GC28587@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-5-git-send-email-arnd@arndb.de>
 <20130305222224.GA26278@arwen.pp.htv.fi>
 <20130306004425.GA28448@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <20130306004425.GA28448@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 06, 2013 at 08:44:25AM +0800, Greg Kroah-Hartman wrote:
> On Wed, Mar 06, 2013 at 12:22:24AM +0200, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Mar 05, 2013 at 11:16:44PM +0100, Arnd Bergmann wrote:
> > > 1bf0cf6040 "usb: gadget: omap_udc: convert to udc_start/udc_stop"
> > > made some trivial changes but was missing a ';' character.
> > >=20
> > > 8c4cc00552 "ARM: OMAP1: DMA: Moving OMAP1 DMA channel definitions
> > > to mach-omap1" added a definition for OMAP_DMA_USB_W2FC_TX0 to
> > > the driver while making the header file it was defined in
> > > unavailable for drivers, but this driver actually needs
> > > OMAP_DMA_USB_W2FC_RX0 as well.
> > >=20
> > > Both changes appear trivial, so let's add the missing semicolon
> > > and the macro definition.
> > >=20
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  drivers/usb/gadget/omap_udc.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_=
udc.c
> > > index 06be85c..f844565 100644
> > > --- a/drivers/usb/gadget/omap_udc.c
> > > +++ b/drivers/usb/gadget/omap_udc.c
> > > @@ -62,6 +62,7 @@
> > >  #define	DRIVER_VERSION	"4 October 2004"
> > > =20
> > >  #define OMAP_DMA_USB_W2FC_TX0		29
> > > +#define OMAP_DMA_USB_W2FC_RX0		26
> > > =20
> > >  /*
> > >   * The OMAP UDC needs _very_ early endpoint setup:  before enabling =
the
> > > @@ -1310,7 +1311,7 @@ static int omap_pullup(struct usb_gadget *gadge=
t, int is_on)
> > >  }
> > > =20
> > >  static int omap_udc_start(struct usb_gadget *g,
> > > -		struct usb_gadget_driver *driver)
> > > +		struct usb_gadget_driver *driver);
> >=20
> > good catch, thanks. I'll queue it for v3.6-rc3. Make sure to Cc
> > linux-usb for anything under drivers/usb/ though
>=20
> I think you mean 3.9 :)

right

> I can take this patch right now, if you ack it.

ok thanks:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNvjaAAoJEIaOsuA1yqREO+AP/iZfByovSbx6DuudppkJaoLM
oCra/TzDjS276YMOjlHd5iLnc80aLqg5f7bezzwt6VEmz91Yd8pZRVOm6/eNRzHM
/I4ilPz9eoPI7MbacOU2/SDjVLKpKiAhJ5EcfrMKWC1O9hJkXoCtWN5NMGePAAVo
7L39VI7VkJ5NDoOTZu+dmTH0RHTlWkAwV1eYgutfiP0nzhsVEkA1mRSlnWDag6pC
+hzIcsp5+j87MwpO6+u7lcDF2odvUsG74ksspzq8PZUJW+0efSmIbOQnRfn9ryGF
bQTj6otiKL+NaJTzZB0/mh/RK+MO+0ku3Q5v0mjLuOB6Y0VLk6baezfkl329q9vI
UFtrmv5CXiu/tfhGSPASBNTl3qVIoNQ/Rm4/H3EHd2jpal+dKpxNgr1fWh4vTgs8
+8LuFfOtgCv1k+SjY1MgXu2CkIBqMnKO0EO6MRGzWH5RYgrO5DUb8b5SuXcpw81u
2R/jBA6bHFu1i6doH3F3Vrt+09yjGzWjgOmslaWNsbqgbPqWteSJGPoozsI4CTHG
o7dfjlyrwMPbNLRKxbbyHHpjIRSnBozpTHkwP2WG3MQ+DDwpztRru88Qk5YnVGGN
YIwSV9XjZryCBtY9dVCG85b+3xzj2I0MRS41RkeTirQ4OY1EQndhdzZRPQj9Bl2D
NNVWXHvAVhFjeKn0Xysg
=+2MV
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
