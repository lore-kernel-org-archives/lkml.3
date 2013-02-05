Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3BEJrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:47:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42597 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:47:05 -0500
Date: Tue, 5 Feb 2013 11:46:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: kishon <kishon@ti.com>, <balbi@ti.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <gg@slimlogic.co.uk>,
        <s-guiriec@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/6] ARM: dts: omap5: add dwc3 omap dt data
Message-ID: <20130205094650.GO32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359112312-6918-1-git-send-email-kishon@ti.com>
 <1359112312-6918-5-git-send-email-kishon@ti.com>
 <510432BF.80808@mvista.com>
 <5110C2E6.30504@ti.com>
 <20130205083828.GE32118@arwen.pp.htv.fi>
 <5110C6EC.6050606@ti.com>
 <5110CBB9.5080307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G23JYFG0d77Z6i/3"
Content-Disposition: inline
In-Reply-To: <5110CBB9.5080307@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--G23JYFG0d77Z6i/3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 05, 2013 at 02:37:05PM +0530, Santosh Shilimkar wrote:
> On Tuesday 05 February 2013 02:16 PM, kishon wrote:
> >Hi,
> >
> >On Tuesday 05 February 2013 02:08 PM, Felipe Balbi wrote:
> >>On Tue, Feb 05, 2013 at 01:59:26PM +0530, kishon wrote:
> >>>On Sunday 27 January 2013 01:17 AM, Sergei Shtylyov wrote:
> >>>>Hello.
> >>>>
> >>>>On 25-01-2013 15:11, Kishon Vijay Abraham I wrote:
> >>>>
> >>>>>Add dwc3 omap glue data to the omap5 dt data file. The information
> >>>>>about
> >>>>>the dt node added here is available @
> >>>>>Documentation/devicetree/bindings/usb/omap-usb.txt
> >>>>
> >>>>>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>>>---
> >>>>>  arch/arm/boot/dts/omap5.dtsi |   11 +++++++++++
> >>>>>  1 file changed, 11 insertions(+)
> >>>>
> >>>>>diff --git a/arch/arm/boot/dts/omap5.dtsi
> >>>>>b/arch/arm/boot/dts/omap5.dtsi
> >>>>>index 5f59bf2..1703a72 100644
> >>>>>--- a/arch/arm/boot/dts/omap5.dtsi
> >>>>>+++ b/arch/arm/boot/dts/omap5.dtsi
> >>>>>@@ -513,6 +513,17 @@
> >>>>>              ti,type =3D <2>;
> >>>>>          };
> >>>>>
> >>>>>+        omap_dwc3@4a020000 {
> >>>>>+            compatible =3D "ti,dwc3";
> >>>>>+            ti,hwmods =3D "usb_otg_ss";
> >>>>>+            reg =3D <0x4a020000 0x1ff>;
> >>>>
> >>>>    Shoudn't the "reg" length be 0x200 here? It's length, not limit.
> >>>
> >>>I think 0x1ff is correct. I got the data from hwmod data.
> >>
> >>hwmod is utterly wrong. Looking at TRM, it says the size here is 64KiB
> >>(0x10000), so is the size for dwc3 itself. Please don't blindly trust
> >>hwmod, make sure you read data from TRM ;-)
> >
> >hmm..ok. But it has only 17 registers :-D
> >
> As Felipe said, it should be 0x200. And if you are
> interested in lesser space, there is no need to map entire 64 KB
> address space if it isn't being used.

We get really close to using all of it. For DWC3, the last address is at
0xcc10 (a 32-bit register).

For dwc3-wrapper, then it's correct, we don't use it, I would still map
the whole thing to make it future proof.

Any draw-backs from mapping all 64K ?

--=20
balbi

--G23JYFG0d77Z6i/3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENUKAAoJEIaOsuA1yqREm5kQAKHEtm1CcMceK3bB2JTyaxDe
P+cMlkSXLNo67MR0fnLketFIwy/ELQIwARg1uBTj/wIwRTa2YmW/AGmos1vG7wO/
nA6tDD8Pbp+apdtkyLBudq6IDk5aEIGcFv9pl6fDTyV2mQB9m+HiYDRfsJhoPPGy
K1rEDzvKkNJc7TMr0ZwYgzcJmNabezjpyXMsfPrKisncaz5zKHOAHVzfAMcsuwZO
1M8ja/fpLfXRW9zgs1rCMz3jyyvWKrs0fmAiAzkqFJfRxV7kZJoT9j2nPPX/milZ
oTj2UPNAYjcugZcB4ABBzLb64FzjV040pF8PMKulZ0/fjHBfFdRjBkii8psYE2nU
yoIRV3HguGXJhbBY4mkAIDyO5XeYj6euosC39C6HAIuwQJ6dOg1NtiJgfcn0ojK0
Duh7I6GATPwTg3YISvpV3vMaZ0dJPpyyWot2sfAAocnWc9uduLkocn+n35YhgwXQ
Nppn1X5OddfJ40jmCuqe9qj3D46+YdnfMO23X5iCsuu0sxFwuxFS/JQd4bQUmI1a
6fICTd2n9t6c7RVfDUXl5uHthg5mVMPO6VDiJ7XBn9/X5HH9kGHKq1sUx4fS8Mqo
jQ0fBIWhz9fJkIRRkEhsRun48T+slWDUQ4lTs9xfQgZmhpjHM+Uh/zMrwD20OI7m
AAIW8fQLotUotP8VVL6q
=yRok
-----END PGP SIGNATURE-----

--G23JYFG0d77Z6i/3--
