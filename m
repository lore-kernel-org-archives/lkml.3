Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3CFJUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:20:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43885 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab3CFJUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:20:17 -0500
Date: Wed, 6 Mar 2013 11:19:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 8/8] ARM: dts: omap5: add dwc3 core dt data
Message-ID: <20130306091942.GJ28587@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362494223-14151-1-git-send-email-kishon@ti.com>
 <1362494223-14151-9-git-send-email-kishon@ti.com>
 <20130305143934.GB12123@arwen.pp.htv.fi>
 <51370494.7090902@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlxN1C6awaFNesUv"
Content-Disposition: inline
In-Reply-To: <51370494.7090902@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UlxN1C6awaFNesUv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 06, 2013 at 02:25:48PM +0530, kishon wrote:
> Hi,
>=20
> On Tuesday 05 March 2013 08:09 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Tue, Mar 05, 2013 at 08:07:03PM +0530, Kishon Vijay Abraham I wrote:
> >>Add dwc3 core dt data as a subnode to dwc3 omap glue data in omap5 dt
> >>data file. The information for the entered data node is available @
> >>Documentation/devicetree/bindings/usb/dwc3.txt
> >>
> >>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>---
> >>  arch/arm/boot/dts/omap5.dtsi |    7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >>diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> >>index c4eb2ec..24dd69f 100644
> >>--- a/arch/arm/boot/dts/omap5.dtsi
> >>+++ b/arch/arm/boot/dts/omap5.dtsi
> >>@@ -514,6 +514,13 @@
> >>  			#size-cells =3D <1>;
> >>  			utmi-mode =3D <2>;
> >>  			ranges;
> >>+			dwc3@4a030000 {
> >>+				compatible =3D "synopsys,dwc3";
> >>+				reg =3D <0x4a030000 0x1000>;
> >>+				interrupts =3D <0 92 4>;
> >>+				usb-phy =3D <&usb2_phy>, <&usb3_phy>;
> >>+				tx-fifo-resize;
> >
> >I think this should be merged with previous patch. Also, we need to
> >check whether tx-fifo-resize is needed with ES2 or not ;-)
>=20
> yeah. ES2 works without tx-fifo-resize.

Great, I guess we can deprecate that attribute. Can you check if ES2
still works with:

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 82e160e..cad0131 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2029,6 +2029,8 @@ static void dwc3_gadget_usb3_phy_suspend(struct dwc3 =
*dwc, int suspend)
 {
 	u32			reg;
=20
+	return;
+
 	reg =3D dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
=20
 	if (suspend)
@@ -2043,6 +2045,8 @@ static void dwc3_gadget_usb2_phy_suspend(struct dwc3 =
*dwc, int suspend)
 {
 	u32			reg;
=20
+	return;
+
 	reg =3D dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
=20
 	if (suspend)


starting on 1.94a (IIRC) core was supposed to control PHYs directly and
since there's nobody in linux mainline using any version prior to 1.94a,
we could drop that too.

--=20
balbi

--UlxN1C6awaFNesUv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJRNwouAAoJEIaOsuA1yqREoEYP9A3VqnODoGvvDfrS1/0zev7a
d5lx9xjbsAQsRYhPSbMCzp8H6tv74db7odL9eUZlD+2BRT1/1reYkwQKD7NT8zLi
nXoBVwAlgC+o3kKcLnTOc50QUHhnCNRw1y06zyDOudDJQu2q1TnlekFaJtpZW8VX
HhHcJMcXdUP6xKSobqKUGDmxbb8p/5ue+2l3uzygZO31buMi+Y6Vz22iUKZMePWE
R/sgMEgwEAY6pMYMP9ASuz7MluWnCcpj9I3Us3lQKkolTSBxBrGDPqfzs9v/kb4z
zSxSjXZ+FXUEugcCg+3gI4EeyPWRqiuKuDIpm0AIpTqNJIda5fP3FN9JNx8iZ4o9
onO4NdsVyn7B11kctxWecX3obuRbXh5+SqzPy1V14ShADcxW/0Z3ligwYt6YmrrX
k3pi1tjsTP5L+qTO76Vsjym21XsCbddOeW+ko5vB399s9XwrrYE2D2wIDGxU93lo
S+ObeTTIKB/204nKUWRN1XBZV4SN4Eo7s2fZks3+sqxpxno3D08vetun4ilLcc49
6p7LFosb09SFtrrmHgAX83KmdBRlNCGPMWLuDS57KsFEDhh9NFh3CTAKFQJeGst2
XuD9r9QB0GIUzqdptlImTDnM8y2dsIS+qEARHAT9LV7fKuYUx4nkkG2U4gJ92z5T
c7dnJArp/rxjjzRZqb8=
=8tDv
-----END PGP SIGNATURE-----

--UlxN1C6awaFNesUv--
