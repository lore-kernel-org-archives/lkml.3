Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3FXThT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:37:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39427 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3FXThN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:37:13 -0400
Date: Mon, 24 Jun 2013 22:36:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Chao Xie <xiechao.mail@gmail.com>,
        Roger Quadros <rogerq@ti.com>, Chao Xie <chao.xie@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
Message-ID: <20130624193643.GC11815@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130620121749.GF9817@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1306201319580.2063-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1306201319580.2063-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 01:25:31PM -0400, Alan Stern wrote:
> On Thu, 20 Jun 2013, Felipe Balbi wrote:
>=20
> > > In fact, the PHY setting and handling is related to platform or SOC,
> > > and for different SOC they can
> > > have same EHCI HCD but they PHY handling can be different.
> > > Omap'a case is the example, and i think some other vendors may have
> > > silimar cases.
> > > From above point, It is better to leave the PHY initialization and
> > > shutdown to be done by each echi-xxx driver.
> > >=20
> > > So Alan and Felipe
> > > What are your ideas about it?
> >=20
> > If we have so many exceptions, then sure. But eventually, the common
> > case should be added generically with a flag so that non-generic cases
> > (like OMAP) can request to handle the PHY by themselves.
> >=20
> > Alan ?
>=20
> I don't have very strong feelings about this; Felipe has much more
> experience with these things.
>=20
> However, when the common case is added into the core, the simplest way
> to indicate that the HCD wants to handle the PHY(s) by itself will be
> to leave hcd->phy set to NULL or an ERR_PTR value.
>=20
> One important thing that hasn't been pointed out yet: When we move
> these calls into the core, the same patch must also remove those calls
> from the glue drivers that currently do set hcd->phy.  And it must make
> sure that the glue drivers which handle the PHY by themselves do not
> set hcd->phy.

perfect summary. Perhaps Roger could already work on private PHY handle
for ehci-omap.c and later we can start moving generic case to usbcore
without having to touch ehci-omap.c at all. Roger, any commetns ?

--=20
balbi

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyJ/LAAoJEIaOsuA1yqREGsIP/RW3h32mi+qhd0GrhhwBcGtO
TgykdxOg75+JpXQBjGOR49fbRE8abJKmDia6gEJBhLVlfnCjIlQMc6WNPGDOl3hb
a/Hn06s4TNu1RMggf+MX4i+7n6XezpZwx3RVwIOqCcE0h2lBtIZqpX4H5J9Kz1/5
XwkcE+dqAHD0r0+FsjhosEcABXlErhXij8vQzEUgNrqwRgzJvWnKuz0vkVFwifwX
4fuTVE+uHfF/ueMCt3jktSGPEN15AJklX/iqhaTG8XfosLk/gPC8+XzUsreEXBuI
X31UGtb9gcuVPQ4jeXGqjxPeVgf8z5DjyaS8NHr+S7JLQd0sZ6Cj8c1p7HDvUbkb
qHT4FQBgsrG/8OXKXEdf5X8AxUr1v2crRPakjqHm8bsWBPAVU7Jjh03hx4K5bEhq
q0GaB6xGp/iqa8d/hfUivhGVq2VdYy+dltc7knOcKePaoYLPIlEWyNrljFPgLeCH
fsS+w68k76kOLHKIR7E7g3ZncOTBn0s1eu2nWJHGmAfBHY/UVgXg0XA++BlGjEBl
C1nCj6hV1ScFybFBKkJdl0sQhd8u+atvJDOMSks19VnPmbtjDuxiYyLGtTn++/ql
R8xUKAZbqdFdm653su/vbCv6p8p13W7FgNcWy+6LboqYGCUgumas66bjxl34WkxN
YCW+aKBoBsy/0GspWl/K
=iK8V
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
