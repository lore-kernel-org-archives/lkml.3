Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3JJRrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:47:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab3JJRrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:47:09 -0400
Date: Thu, 10 Oct 2013 12:46:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <matt.porter@linaro.org>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI
 PHY width
Message-ID: <20131010174620.GC19802@radagast>
Reply-To: <balbi@ti.com>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
 <1381140752-312-3-git-send-email-matt.porter@linaro.org>
 <20131010152922.GF28375@radagast>
 <5256DBD0.8030008@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <5256DBD0.8030008@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 10, 2013 at 12:54:40PM -0400, Matt Porter wrote:
> On 10/10/2013 11:29 AM, Felipe Balbi wrote:
> >On Mon, Oct 07, 2013 at 06:12:29AM -0400, Matt Porter wrote:
> >>Extend dwc2 binding with an optional utmi phy width property.
> >>Enable the s3c-hsotg.c driver to use standard dwc2 binding
> >>and enable configuration of the UTMI phy width based on the
> >>property.
> >>
> >>Signed-off-by: Matt Porter <matt.porter@linaro.org>
> >>Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> >>Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> >>---
> >>  Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
> >>  drivers/usb/gadget/s3c-hsotg.c                     | 18 +++++++++++++=
++++-
> >>  drivers/usb/gadget/s3c-hsotg.h                     |  1 +
> >>  3 files changed, 22 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt b/Docum=
entation/devicetree/bindings/staging/dwc2.txt
> >>index 1a1b7cf..fb6b8ee 100644
> >>--- a/Documentation/devicetree/bindings/staging/dwc2.txt
> >>+++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> >>@@ -6,10 +6,14 @@ Required properties:
> >>  - reg : Should contain 1 register range (address and length)
> >>  - interrupts : Should contain 1 interrupt
> >>
> >>+Optional properties:
> >>+- snps,phy-utmi-width: Must contain the UTMI data width (either 8 or 1=
6)
> >
> >isn't this available in any of the configuration registers ?
>=20
> Yes and no. HWCFG4 has a UTMI data width field. However, it has 3
> valid states, "8", "16", or "8 or 16". The BCM281xx implementation is
> set to the latter and the attached phy is 8-bit.
>=20
> Looking at dwc2 prior to Matthijs Kooijman's patch [1] which starts
> validating the value of phy_utmi_width in that driver, the pci.c
> dwc2_module_params .phy_utmi_width field there even had the comment,
> "/* 16 bits - NOT DETECTABLE */". The autodetect code in
> dwc2_set_param_phy_utmi_width() will fail if HWCFG4 has the "8 or 16"
> option as it just decides to default to a phy width of 16 if nothing
> is configured by the platform glue. This property would also allow
> this issue to be addressed in that driver.

fair enough, but I'd really like to hear from DT folks if your suggested
binding is acceptable. It seems like we can equally argue that it's a SW
configuration or HW description.

cheers

--=20
balbi

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVufsAAoJEIaOsuA1yqREz6UQAJRTHwkAXhNfJYndx+tyxPc9
Pmy6wi6qMiwxNkzmIS9iRLGPnipag8eI/Kh0qURAG8OT9N/C/H73xwbOr81F27nE
yLawRTLDd3yT0858wR87t1ktjCEI1XhfcWSyOm/1U4teAReMJlmvLzHPX09v1QTH
1mRxuJU05sD0QL4cWj9lckj9fU3JZyQUK2RPVpaovnVL1qSA7D6KYG07lCnAC2GA
B4ezVy6CXPOxX5fIs/LMhbYLRpjxOW+sh3lt/f9DGpKmowWOEvoxulytK2/+gKzV
zKXM2H85PjJ/bYumAGMp85RA7alPOe6HM0aTiG5Tp7Rw+DE33fPbg4gn0EZcEH90
ElNOqFzjtNBxXBFmJAQRA4dOTwJDUdSUuJr8mE+Om8nhBZW/MjdE1/u+eutSFuRW
7RCpNr6KG4Nf0aJPcbSVl121OteZ59/w22D0YZIGRnyD/zlR0O5blbk/aBssOzAi
MuVPkm9hsxwZZrRXf9zypeto3LfNfv4n4QqiXKxtFoQ2Ctl/0tdb+G+IpXxuGPmk
ZhWYYYWXMNvrJHlPOuH+0+UDFkEhXdJF+y8jqTdQFBAow3zGgtJfIa0XA5EkoWPd
yd9IrimUgMdp6OAI62R91VxxLQrYPvOvfTvqu1AE2ftkqvROzOkNloDShfG5kykZ
EhCz/EtdD6s38ovRAGxf
=idGW
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
