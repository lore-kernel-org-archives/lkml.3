Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaIZAil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:38:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54440 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaIZAij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:38:39 -0400
Date: Thu, 25 Sep 2014 19:37:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Felipe Balbi <balbi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <sebastian.hesselbarth@gmail.com>, <p.zabel@pengutronix.de>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <jszhang@marvell.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140926003750.GA12770@saruman>
Reply-To: <balbi@ti.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <2923729.dtX0WmHSV0@wuerfel>
 <20140924112902.GA23331@peterchendt>
 <2786668.t3YLqX5enD@wuerfel>
 <20140925141553.GC28045@saruman>
 <20140925233932.GA3026@peterchendt>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20140925233932.GA3026@peterchendt>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Fri, Sep 26, 2014 at 07:39:34AM +0800, Peter Chen wrote:
> On Thu, Sep 25, 2014 at 09:15:53AM -0500, Felipe Balbi wrote:
> > On Wed, Sep 24, 2014 at 02:23:38PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 24 September 2014 19:29:05 Peter Chen wrote:
> > > >=20
> > > > So, it is IP CORE LIB (you suggest) vs IP CORE Platform Driver
> > > > (dwc3, musb, chipidea) you are talking about, right? Except for
> > > > creating another platform driver as well as related DT node (option=
al),
> > > > are there any advantages compared to current IP core driver structu=
re?
> > >=20
> > > Having a library module usually requires less code, and is more
> > > consistent with other drivers, which helps new developers understand
> > > what the driver is doing.
> >=20
> > I beg to differ. You end-up having to pass function pointers through
> > platform_data to handle differences which could be handled by the core
> > IP.
> >=20
> > > The most important aspect though is the DT binding: once the structure
> > > with separate kernel drivers leaks out into the DT format, you can't
> > > easily change the driver any more, e.g. to make a property that was
> > > introduced for one glue driver more general so it can get handled by
> > > the common part. Having a single node lets us convert to the library
> > > model later, so that would be a strong reason to keep the DT binding
> > > simple, without child nodes.
> > >=20
> > > Following that logic, it turns into another reason for using the libr=
ary
> > > model to start with, because otherwise the child device does not have
> > > any DT properties itself and has to rely on the parent device propert=
ies,
> > > which somewhat complicates the driver structure.
> >=20
> > this is bullcrap. Take a look at
> > Documentation/devicetree/bindings/usb/dwc3.txt:
> >=20
> > synopsys DWC3 CORE
> >=20
> > DWC3- USB3 CONTROLLER
> >=20
> > Required properties:
> >  - compatible: must be "snps,dwc3"
> >  - reg : Address and length of the register set for the device
> >  - interrupts: Interrupts used by the dwc3 controller.
> >=20
> > Optional properties:
> >  - usb-phy : array of phandle for the PHY device.  The first element
> >    in the array is expected to be a handle to the USB2/HS PHY and
> >    the second element is expected to be a handle to the USB3/SS PHY
> >  - phys: from the *Generic PHY* bindings
> >  - phy-names: from the *Generic PHY* bindings
> >  - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
> >=20
> > This is usually a subnode to DWC3 glue to which it is connected.
> >=20
> > dwc3@4a030000 {
> > 	compatible =3D "snps,dwc3";
> > 	reg =3D <0x4a030000 0xcfff>;
> > 	interrupts =3D <0 92 4>
> > 	usb-phy =3D <&usb2_phy>, <&usb3,phy>;
> > 	tx-fifo-resize;
> > };
> >=20
> > This contains all the attributes it needs to work. In fact, this could
> > be used without any glue.
> >=20
>=20
> If you want to add "vbus-supply" core node to support ID switch, what's
> the plan for that?

send a patch ? Just make sure it's optional because not everybody needs
a vbus-supply. Also, DRD will still take a few merge windows to become a
reality. I don't want to merge something before considering it carefuly,
otherwise we will having which is broken and doesn't work for everybody
;-)

> Is it possible that the glue layer needs to access core register
> (eg, portsc.phcd during suspend)? The wrapper IP may wait some signals
> at core IP to change.

why would a glue layer need to access registers from the core ? That
sounds very odd. I haven't seen that and will, definitely, NACK such a
patch :-)

can you further describe why you think a glue layer might need to access
core IP's registers ?

--=20
balbi

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJLVdAAoJEIaOsuA1yqRE8wwQAIax1t4tanR/L3I605+N30G6
8+g1fiqZ3ALt3BI5Pq+m1bSdQ3KuAB/LcmNScjl4sO1ekZq5fRh4baA9wJDH3bNy
qsDTqULQxanpzxXdCH+n1xTjAW+PLtaJwuPw+EZ9mkf4kiD4eIrqOyNEITkDf0h2
OV2d2zLxnMyRR86bdmOrXw8Z27AxA7/hnDbVYgDlqx1isr0F2SoV8jXKNkzgvMbR
apXejsFIN+m2rPGrxdvLEKX+AsLKrwRUS+8WDVv5sqqphsAuR+VE9hdtjHtUP1r+
FDRkPm5H7sN57YWqWQgw5ngBx6PABzHBVcayqMI7aMWylYIK14iWvJwZf7lApqfa
+Lv20l4oiDcWCuU5A/LztO9/+WL/JwMuGXzvWf3kUH69NzHpWg3zM3IJMSM/NfnP
EyeXNfLYmoorO8MoS6UppdRXsnRtnvWW7a/IyXZsnZPKSFG40hWTIs2f2jCfWKZX
MoN6V0QeM7B4v8MAlB8oVj9o06vWoUHUkFGY4X0lTqXAIceafyaGGDmuJbiBbk77
Gzwbb3eymoQZmxj3kbH4FsrL2dwpGoHrjQ4m+BZavCqXHY0Hqr/qJmrKWMWBriCv
hftEG8ROPSK0bR4RaU+jpZnbL/VPKi98k39DZJG5UWEaIrtB7hW27p5JZKWR39z1
VpEilFsBy+L6ruuWRs4L
=OHmG
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
