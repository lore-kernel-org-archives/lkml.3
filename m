Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaIYOQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:16:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39503 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaIYOQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:16:39 -0400
Date: Thu, 25 Sep 2014 09:15:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Peter Chen <peter.chen@freescale.com>, <balbi@ti.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <sebastian.hesselbarth@gmail.com>, <p.zabel@pengutronix.de>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <jszhang@marvell.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140925141553.GC28045@saruman>
Reply-To: <balbi@ti.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <2923729.dtX0WmHSV0@wuerfel>
 <20140924112902.GA23331@peterchendt>
 <2786668.t3YLqX5enD@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <2786668.t3YLqX5enD@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 02:23:38PM +0200, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 19:29:05 Peter Chen wrote:
> >=20
> > So, it is IP CORE LIB (you suggest) vs IP CORE Platform Driver
> > (dwc3, musb, chipidea) you are talking about, right? Except for
> > creating another platform driver as well as related DT node (optional),
> > are there any advantages compared to current IP core driver structure?
>=20
> Having a library module usually requires less code, and is more
> consistent with other drivers, which helps new developers understand
> what the driver is doing.

I beg to differ. You end-up having to pass function pointers through
platform_data to handle differences which could be handled by the core
IP.

> The most important aspect though is the DT binding: once the structure
> with separate kernel drivers leaks out into the DT format, you can't
> easily change the driver any more, e.g. to make a property that was
> introduced for one glue driver more general so it can get handled by
> the common part. Having a single node lets us convert to the library
> model later, so that would be a strong reason to keep the DT binding
> simple, without child nodes.
>=20
> Following that logic, it turns into another reason for using the library
> model to start with, because otherwise the child device does not have
> any DT properties itself and has to rely on the parent device properties,
> which somewhat complicates the driver structure.

this is bullcrap. Take a look at
Documentation/devicetree/bindings/usb/dwc3.txt:

synopsys DWC3 CORE

DWC3- USB3 CONTROLLER

Required properties:
 - compatible: must be "snps,dwc3"
 - reg : Address and length of the register set for the device
 - interrupts: Interrupts used by the dwc3 controller.

Optional properties:
 - usb-phy : array of phandle for the PHY device.  The first element
   in the array is expected to be a handle to the USB2/HS PHY and
   the second element is expected to be a handle to the USB3/SS PHY
 - phys: from the *Generic PHY* bindings
 - phy-names: from the *Generic PHY* bindings
 - tx-fifo-resize: determines if the FIFO *has* to be reallocated.

This is usually a subnode to DWC3 glue to which it is connected.

dwc3@4a030000 {
	compatible =3D "snps,dwc3";
	reg =3D <0x4a030000 0xcfff>;
	interrupts =3D <0 92 4>
	usb-phy =3D <&usb2_phy>, <&usb3,phy>;
	tx-fifo-resize;
};

This contains all the attributes it needs to work. In fact, this could
be used without any glue.

--=20
balbi

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJCOZAAoJEIaOsuA1yqREqZAP/A3p0DDhoM/aMv7+JY7L508C
UVS8LhzA5f60fSR9QxVMrrI5TsmGKCXpGrprQPZeZZgks8YwC6BJjW9EN0p7ykuM
GyA4MKNCBl7q99tVIgC8EZ59FU4vQcoLxC/U+dIePCyvn9JyarM9tQ5zleiXvGt9
F88N091tsS+905xQo13Ef1sw5EgFXrFxt4eVeFiEy8jh+Ll/hs2UoYi72CzA+N1h
CRSPlPhubFz3gzDkyz/9Uv9IXWYd80WUIVzkdOAN9MGiM5x/GSXsFe25DASel9sg
g1Ayyid2VffUKscGxUVfPRHmm0zxiti2Cj7PAPP9XWS4ZRHvElpO6PAJcKb5Is2B
5wNY+2qI6UNqyb7ydJOwKUga/XDC2/Ra6LfOTU4xiPIoGgY0LShCw9qAfwDyQ5xB
gZBir+QGb0MvmPWG07/ckM6oq3adhhLcnQ2bu+/0wR2S/Fk6pbk9RbOYQzj2OuOi
PwGjwz01z4HlMD+D9y2JReTLYDyMHvjcigmI/yxs8yvlJBIzFgQZDN4RTM9Yv477
Bl2+wfs/HWGO3jgjcLE7x8AunRNLBup+wCGfV//wHMMKKGesDP2Trfg2ydWnV/VX
GfQtQgq3MgcXIkEz2bPXJ2Hk0L49xWzINVVl0ULCu+BscxndPTnko5a4Oklgydym
kZpjHkNs/bSw8ft/nlnw
=FfiF
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
