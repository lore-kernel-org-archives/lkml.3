Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3JKNiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:38:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46710 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab3JKNiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:38:19 -0400
Date: Fri, 11 Oct 2013 08:37:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <matt.porter@linaro.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>,
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
        Linaro Patches <patches@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI
 PHY width
Message-ID: <20131011133731.GD25706@radagast>
Reply-To: <balbi@ti.com>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
 <1381140752-312-3-git-send-email-matt.porter@linaro.org>
 <20131010152922.GF28375@radagast>
 <5256DBD0.8030008@linaro.org>
 <20131010174620.GC19802@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458E16893@US01WEMBX2.internal.synopsys.com>
 <5256FAFA.1020509@linaro.org>
 <52576EBA.9000502@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Content-Disposition: inline
In-Reply-To: <52576EBA.9000502@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 10, 2013 at 11:21:30PM -0400, Matt Porter wrote:
> On 10/10/2013 03:07 PM, Matt Porter wrote:
> >On 10/10/2013 01:57 PM, Paul Zimmerman wrote:
> >>>From: Felipe Balbi [mailto:balbi@ti.com]
> >>>Sent: Thursday, October 10, 2013 10:46 AM
> >>>
> >>>On Thu, Oct 10, 2013 at 12:54:40PM -0400, Matt Porter wrote:
> >>>>On 10/10/2013 11:29 AM, Felipe Balbi wrote:
> >>>>>On Mon, Oct 07, 2013 at 06:12:29AM -0400, Matt Porter wrote:
> >>>>>>Extend dwc2 binding with an optional utmi phy width property.
> >>>>>>Enable the s3c-hsotg.c driver to use standard dwc2 binding
> >>>>>>and enable configuration of the UTMI phy width based on the
> >>>>>>property.
> >>>>>>
> >>>>>>Signed-off-by: Matt Porter <matt.porter@linaro.org>
> >>>>>>Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> >>>>>>Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> >>>>>>---
> >>>>>>  Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
> >>>>>>  drivers/usb/gadget/s3c-hsotg.c                     | 18
> >>>>>>+++++++++++++++++-
> >>>>>>  drivers/usb/gadget/s3c-hsotg.h                     |  1 +
> >>>>>>  3 files changed, 22 insertions(+), 1 deletion(-)
> >>>>>>
> >>>>>>diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt
> >>>b/Documentation/devicetree/bindings/staging/dwc2.txt
> >>>>>>index 1a1b7cf..fb6b8ee 100644
> >>>>>>--- a/Documentation/devicetree/bindings/staging/dwc2.txt
> >>>>>>+++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> >>>>>>@@ -6,10 +6,14 @@ Required properties:
> >>>>>>  - reg : Should contain 1 register range (address and length)
> >>>>>>  - interrupts : Should contain 1 interrupt
> >>>>>>
> >>>>>>+Optional properties:
> >>>>>>+- snps,phy-utmi-width: Must contain the UTMI data width (either 8
> >>>>>>or 16)
> >>>>>
> >>>>>isn't this available in any of the configuration registers ?
> >>>>
> >>>>Yes and no. HWCFG4 has a UTMI data width field. However, it has 3
> >>>>valid states, "8", "16", or "8 or 16". The BCM281xx implementation is
> >>>>set to the latter and the attached phy is 8-bit.
> >>>>
> >>>>Looking at dwc2 prior to Matthijs Kooijman's patch [1] which starts
> >>>>validating the value of phy_utmi_width in that driver, the pci.c
> >>>>dwc2_module_params .phy_utmi_width field there even had the comment,
> >>>>"/* 16 bits - NOT DETECTABLE */". The autodetect code in
> >>>>dwc2_set_param_phy_utmi_width() will fail if HWCFG4 has the "8 or 16"
> >>>>option as it just decides to default to a phy width of 16 if nothing
> >>>>is configured by the platform glue. This property would also allow
> >>>>this issue to be addressed in that driver.
> >>>
> >>>fair enough, but I'd really like to hear from DT folks if your suggest=
ed
> >>>binding is acceptable. It seems like we can equally argue that it's a =
SW
> >>>configuration or HW description.
> >>
> >>It's definitely a HW description - the width of the UTMI data connectio=
n.
> >>
> >>But, which PHY is this? Does it have a register that could tell what
> >>the data width is? The dwc2 core has an (optional) PHY Vendor Control
> >>Register that allows reading the PHY registers.
> >
> >This is the integrated PHY on the bcm28155 part (the entire
> >bcm281xx/11351 family shares it). My register doc doesn't show the
> >optional PHY vendor control register as being present in this dwc2
> >implementation. I'll track down with the design team if this is
> >accurate...but it appears we can't go that route.
>=20
> The design team confirmed that we do not have any registers that can
> be accessed via the PHY Vendor Control Register. All PHY control
> registers are implemented in the MMIO control block which is
> supported in the PHY control driver later in this series.They also
> confirmed there's no other way to detect that it's an 8-bit data
> path.

then we need the DT binding, let's see what DT maintainers say.

--=20
balbi

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSV/8bAAoJEIaOsuA1yqREP3MP/0M7glVlml6aKzCtbu7czTgl
p6laWFgrzQW9/GH2tkbJew1V0gJ0fNUg+Tas1gSfTKfc5m6NK0QpyTqwx8q4H4RM
WUQ7gQV10edeLdjnDa9+VGU16/OPTqsgrAum+DFP7vMOi7rNVh5g98M+JqDghMcn
cKHFuFcosAqXFkhw6Xknnf/ldKLDHZS/hIlnLaAlplanRNP5xkJ6TsEpRd9vHO0o
sWpRUoEo1Ud+JPhnQHXblbdsclnlemEUiWRJJZ84HynZKNC4HqDc/HMx4hyiV9yw
/iXD0AnOO+jZVyj/X6+rn5nC+t0wnrMGlJMcLlxhP1dJucVC0Mxjx+e0tyZ9iuOf
lUT0iibS/ziQJ7EBwHzO+xZP6aLAJfo0X/CZ1XaeBAUcy6EaRQ9pdwpKc4l85c0V
hyxGB9pfU3PLsA+3KjKw4OiLp2BtOHsnmf/mrjI3onNuQcgO/3mMtCJDnNtFiwGY
902K2fGLFiaU4USz8aZwqNvrSyMWibS62NrXjz4+nRrEN89gWrSWnhsKPjYv6p2z
Zh1NNlCHr7BpxvA1hmT8XrEiET7Z9rDVAIxNGYEJ3LxpJOehrY1S4gEJuAKhhkPW
ahtqrX5FxPGNpDnTS3Jh6Y3d/oI/WmpD5J029F1IP+OsReZLKkAw6EpvHCpGFbwm
wjIH0ByMbXmLAEmKncrY
=nY4D
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
