Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab3JJS6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:58:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab3JJS6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:58:42 -0400
Date: Thu, 10 Oct 2013 13:57:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, Matt Porter <matt.porter@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI
 PHY width
Message-ID: <20131010185752.GD21240@radagast>
Reply-To: <balbi@ti.com>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
 <1381140752-312-3-git-send-email-matt.porter@linaro.org>
 <20131010152922.GF28375@radagast>
 <5256DBD0.8030008@linaro.org>
 <20131010174620.GC19802@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458E16893@US01WEMBX2.internal.synopsys.com>
 <20131010180723.GF19802@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458E168E8@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E168E8@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 10, 2013 at 06:14:19PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Thursday, October 10, 2013 11:07 AM
> >=20
> > On Thu, Oct 10, 2013 at 05:57:54PM +0000, Paul Zimmerman wrote:
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Thursday, October 10, 2013 10:46 AM
> > > >
> > > > On Thu, Oct 10, 2013 at 12:54:40PM -0400, Matt Porter wrote:
> > > > > On 10/10/2013 11:29 AM, Felipe Balbi wrote:
> > > > > >On Mon, Oct 07, 2013 at 06:12:29AM -0400, Matt Porter wrote:
> > > > > >>Extend dwc2 binding with an optional utmi phy width property.
> > > > > >>Enable the s3c-hsotg.c driver to use standard dwc2 binding
> > > > > >>and enable configuration of the UTMI phy width based on the
> > > > > >>property.
> > > > > >>
> > > > > >>Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > > > > >>Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > > > > >>Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > > > > >>---
> > > > > >>  Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
> > > > > >>  drivers/usb/gadget/s3c-hsotg.c                     | 18 +++++=
++++++++++++-
> > > > > >>  drivers/usb/gadget/s3c-hsotg.h                     |  1 +
> > > > > >>  3 files changed, 22 insertions(+), 1 deletion(-)
> > > > > >>
> > > > > >>diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt
> > > > b/Documentation/devicetree/bindings/staging/dwc2.txt
> > > > > >>index 1a1b7cf..fb6b8ee 100644
> > > > > >>--- a/Documentation/devicetree/bindings/staging/dwc2.txt
> > > > > >>+++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> > > > > >>@@ -6,10 +6,14 @@ Required properties:
> > > > > >>  - reg : Should contain 1 register range (address and length)
> > > > > >>  - interrupts : Should contain 1 interrupt
> > > > > >>
> > > > > >>+Optional properties:
> > > > > >>+- snps,phy-utmi-width: Must contain the UTMI data width (eithe=
r 8 or 16)
> > > > > >
> > > > > >isn't this available in any of the configuration registers ?
> > > > >
> > > > > Yes and no. HWCFG4 has a UTMI data width field. However, it has 3
> > > > > valid states, "8", "16", or "8 or 16". The BCM281xx implementatio=
n is
> > > > > set to the latter and the attached phy is 8-bit.
> > > > >
> > > > > Looking at dwc2 prior to Matthijs Kooijman's patch [1] which star=
ts
> > > > > validating the value of phy_utmi_width in that driver, the pci.c
> > > > > dwc2_module_params .phy_utmi_width field there even had the comme=
nt,
> > > > > "/* 16 bits - NOT DETECTABLE */". The autodetect code in
> > > > > dwc2_set_param_phy_utmi_width() will fail if HWCFG4 has the "8 or=
 16"
> > > > > option as it just decides to default to a phy width of 16 if noth=
ing
> > > > > is configured by the platform glue. This property would also allow
> > > > > this issue to be addressed in that driver.
> > > >
> > > > fair enough, but I'd really like to hear from DT folks if your sugg=
ested
> > > > binding is acceptable. It seems like we can equally argue that it's=
 a SW
> > > > configuration or HW description.
> > >
> > > It's definitely a HW description - the width of the UTMI data connect=
ion.
> >=20
> > right, but that description should be passed to the PHY, right ? DWC2
> > works with both widths (8 or 16).
>=20
> I don't know what you mean by "passed to the PHY". The data width is the
> number of physical wires connecting the PHY to the DWC2 controller. If

right, that's well understood.

> that value can be read from the PHY, fine. Otherwise, I think a DT
> binding is the way to go.

Let's see what the DT folks have to say.

--=20
balbi

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVviwAAoJEIaOsuA1yqREc1cQAJYStNIqaUTNP9DbClN0cZ6e
R5iTiWXOnJv5JD7/clMdLuY4P6rrTi3VmTcMu3QKdUg01zPu006QA/NwbF/QWnyJ
imgQ868j7S2svSTflS1Ow/T/18zIoKWJJcaCHdri31VgJTUt5OdiPABXVz2HXJve
K/By+2OEK/SNouyGp1mbUQaxsUtr17Nug1Xzpr5IVB1uh8AnIacz9V6GKBa+8Nwi
zjNDbBZrpoTPwpCzycrdFSGS5rC3Es/MKpV+pCpgA8r6BDIr4h6qvrGlFBsCV+50
NmFHdQL3x796mEOFQ7Jgq/RqpIQxJC1xK/S9xUdoH4VqhTvgg5Y+D2OpRnVIfEPr
ELHJKtQDIY9hZep5qPq5yl9lEKWNDN8UZpuiKl8uxnZRCBhctw0eykRXyPb6puwQ
oBeUdSvtFtslmTViGq/X9G2hEDtFNTEZCaBWvOr7HAls3jZ2uukpk6gNNBOZLfYk
MYjV6RdZ3En9m8Rm1vpMIKhP34709uKQgCBCNPk4CWUNNmxNVqkQfSNAQkM/V3/a
L9seW+xV5S2a0DfIWizq8maiaW6LiHIEvbDmzWSVWKk+bfMpsJz9ljCJsCepGuY7
WwO98foDJd8d5bQAl2OJ5BtSr72S+b5jufl9xg+7aPB0jfTltlppd8LGnvW+djfe
rDQ6GXljO2HoswRv0XMa
=UuBU
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
