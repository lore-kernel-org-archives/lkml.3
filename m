Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3JJSIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:08:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48730 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab3JJSIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:08:12 -0400
Date: Thu, 10 Oct 2013 13:07:23 -0500
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
Message-ID: <20131010180723.GF19802@radagast>
Reply-To: <balbi@ti.com>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
 <1381140752-312-3-git-send-email-matt.porter@linaro.org>
 <20131010152922.GF28375@radagast>
 <5256DBD0.8030008@linaro.org>
 <20131010174620.GC19802@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458E16893@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O98KdSgI27dgYlM5"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E16893@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--O98KdSgI27dgYlM5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 10, 2013 at 05:57:54PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Thursday, October 10, 2013 10:46 AM
> >=20
> > On Thu, Oct 10, 2013 at 12:54:40PM -0400, Matt Porter wrote:
> > > On 10/10/2013 11:29 AM, Felipe Balbi wrote:
> > > >On Mon, Oct 07, 2013 at 06:12:29AM -0400, Matt Porter wrote:
> > > >>Extend dwc2 binding with an optional utmi phy width property.
> > > >>Enable the s3c-hsotg.c driver to use standard dwc2 binding
> > > >>and enable configuration of the UTMI phy width based on the
> > > >>property.
> > > >>
> > > >>Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > > >>Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > > >>Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > > >>---
> > > >>  Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
> > > >>  drivers/usb/gadget/s3c-hsotg.c                     | 18 +++++++++=
++++++++-
> > > >>  drivers/usb/gadget/s3c-hsotg.h                     |  1 +
> > > >>  3 files changed, 22 insertions(+), 1 deletion(-)
> > > >>
> > > >>diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt
> > b/Documentation/devicetree/bindings/staging/dwc2.txt
> > > >>index 1a1b7cf..fb6b8ee 100644
> > > >>--- a/Documentation/devicetree/bindings/staging/dwc2.txt
> > > >>+++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> > > >>@@ -6,10 +6,14 @@ Required properties:
> > > >>  - reg : Should contain 1 register range (address and length)
> > > >>  - interrupts : Should contain 1 interrupt
> > > >>
> > > >>+Optional properties:
> > > >>+- snps,phy-utmi-width: Must contain the UTMI data width (either 8 =
or 16)
> > > >
> > > >isn't this available in any of the configuration registers ?
> > >
> > > Yes and no. HWCFG4 has a UTMI data width field. However, it has 3
> > > valid states, "8", "16", or "8 or 16". The BCM281xx implementation is
> > > set to the latter and the attached phy is 8-bit.
> > >
> > > Looking at dwc2 prior to Matthijs Kooijman's patch [1] which starts
> > > validating the value of phy_utmi_width in that driver, the pci.c
> > > dwc2_module_params .phy_utmi_width field there even had the comment,
> > > "/* 16 bits - NOT DETECTABLE */". The autodetect code in
> > > dwc2_set_param_phy_utmi_width() will fail if HWCFG4 has the "8 or 16"
> > > option as it just decides to default to a phy width of 16 if nothing
> > > is configured by the platform glue. This property would also allow
> > > this issue to be addressed in that driver.
> >=20
> > fair enough, but I'd really like to hear from DT folks if your suggested
> > binding is acceptable. It seems like we can equally argue that it's a SW
> > configuration or HW description.
>=20
> It's definitely a HW description - the width of the UTMI data connection.

right, but that description should be passed to the PHY, right ? DWC2
works with both widths (8 or 16).

--=20
balbi

--O98KdSgI27dgYlM5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVuzaAAoJEIaOsuA1yqRElc0P/3fSy3JmkgF6ueqJJ6uuP3xs
pTymLwlYbWH/cRZPset6d8H1CVjQlV/n8GpVZhjlTeOolnVRoGaS25V/GS0etwE/
LlV1KxwgoRKelfo84hCcGSIlwkFwpXPuwW1Bd8OUwh59zfd+ER7QECq0P71pmJzC
HYEg1gSE0gKd3VNCnn2+pCX7tL4jDmIX08k7zHdXckGdI3Jysx0o6mTZKm0hovtB
dPNcvskknafNnBNjAx6Rxw9TZqDjnCUQnboF0fLVNozHZI74kaZZYsWomgNiOT5B
lZWmhOshdwFASVbk0UiFsZKILVcDtCqp2HXgTnhhgcLwPzYT4t+FxLv5LWWiQTS7
+RjcxuZvJHNa+392Sx4Z0TaQi/l71roUtbT9qxnsmonF0vpb2jpHm4hc2CrfZ52Q
ywNZcoIeLA5U6aEC5sS7M4y6ypMQyNBpVjrnFxlVAA8LcSQcJmJ/6XjAyl/oCfvY
JgQvSQ4KlRaIQ0etV3QCPVN+OZ/ODJzwSOh19gB7KBlVj403NufFvaULRQK48B/Y
TQgMXheKLJjnhg5jFPPahGpyx82ckSfRTFRfMAZTe00YRPEyo/pcq4OFT/CmFUBd
+EiRtkfkdyAIBioc72ObGwqK8rXkAlfmxdmaYCt/3ynQ+t19mox6x5660oSXLvMp
xN+hJHVqySDkNjzMYnOT
=6BW3
-----END PGP SIGNATURE-----

--O98KdSgI27dgYlM5--
