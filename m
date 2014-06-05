Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaFEWL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:11:28 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:35374 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaFEWLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:11:24 -0400
Date: Fri, 6 Jun 2014 00:08:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] of: Add NVIDIA Tegra XUSB pad controller binding
Message-ID: <20140605220833.GA28817@ulmo>
References: <1401894990-30092-1-git-send-email-thierry.reding@gmail.com>
 <1401894990-30092-2-git-send-email-thierry.reding@gmail.com>
 <53909F31.4050603@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <53909F31.4050603@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 10:47:45AM -0600, Stephen Warren wrote:
> On 06/04/2014 09:16 AM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > This patch adds the device tree binding documentation for the XUSB pad
> > controller found on NVIDIA Tegra SoCs. It exposes both pinmuxing and PHY
> > capabilities.
>=20
> > diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-=
xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124=
-xusb-padctl.txt
>=20
> > +- #phy-cells: Should be 1. The specifier is the index of the PHY to re=
ference.
> > +  Possible values are:
> > +  - 0: PCIe
> > +  - 1: SATA
>=20
> Those values are defined in
> include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h. I personally consider
> the <dt-bindings/> header files to be part of the binding itself, rather
> than being derived from the binding. As such, I'd suggest the following
> changes:
>=20
> * Make this patch 1 not patch 2
> * Move pinctrl-tegra-xusb.h into this patch.
> * Remove the list of values above, and replace it with the text "See
> <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the set of valid values".

I remember discussions where people explicitly said that relying on the
symbolic names in the DT bindings was a mistake because it would mean
that everyone would need to have access to a mechanism similar to what
we have in the Linux kernel (and that the header files would always need
to be shipped with the DT bindings).

> > +Example:
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +SoC file extract:
> > +-----------------
> > +
> > +	padctl@0,7009f000 {
> > +		compatible =3D "nvidia,tegra124-xusb-padctl";
> > +		reg =3D <0x0 0x7009f000 0x0 0x1000>;
> > +		resets =3D <&tegra_car 142>;
> > +		reset-names =3D "padctl";
> > +
> > +		#address-cells =3D <0>;
> > +		#size-cells =3D <0>;
>=20
> Why are those two properties required? Yes, this node has sub-nodes, but
> those sub-nodes don't have a reg property or unit address. The main
> Tegra pinctrl nodes don't have #address/size-cells.

I seem to remember that there was a reason but I'm pulling a blank. I'll
do some testing with those removed and verify that they are indeed not
needed.

> > +Board file extract:
> > +-------------------
>=20
> > +	padctl: padctl@0,7009f000 {
> > +		pinmux {
> > +			pinctrl-0 =3D <&padctl_default>;
> > +			pinctrl-names =3D "default";
>=20
> Isn't there one extra level of nodes here. In the DT patches later in
> this series, pinctrl-0/pinctrl-names are directly inside the top-level
> padctl node.

Yes, this is left-over from an earlier version of the patch. Thanks for
catching this.

Thierry

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkOpgAAoJEN0jrNd/PrOh43IQAJqKwAMJMy9dEiuPXWZRHqRQ
ZQDl9VUQYidevWc6B97ljjV2AksA64X9q/diMN6C47A8l0eys63qYUBMmA0LlzGB
XR+9xPTK/l6dk9AckuzdIrT3cnOLouEeCD4BoJ1gt0baNDFB0HlBh5m1itz7tjUa
DD/nsPSwZM6kwTlLfmZjavKJ9ivJk23/myqNpZXt406n7WIlDx4VdGNGM43oc0VU
V0pE55lUOjhC1MMCSUwlxJqRxhYGXy4WC5XSlng/6meVzol3GAHyzBpxWntbYywA
d9EKqXWEenvYMq517oZehnzL8CpLW/m/M6lFdtiyeSingZ5+YyhgmABwyVrY8CN1
3z3IeNzWuXuJkJkNM6YOfQj/OBBrBxrZdlvyvMy1rRLXbT3LMsTzdrA2PTGQFK0G
Yc5+7iRCvgHpN3txWmcfPOF1a55qGpyryuPdRJRnnaGDdiy8BlWcvyI7z+/5vL/G
5w7/JckV4WapBvSWetIUgNMDIRhKeDhOzDjjaZSex5twfY/BQkvA1D70XEVeexn1
R3xB3mY4bAYFHsLEMUCUc1A7xe3KuRx6PvJuYn6F30u9CqthlQpncidQIS1cWcRv
iVOxCPHgdPpqBHN8a49ib7a5nHozzTEGpuL2WYitGwEjxf666PH7palt4mPngO4Y
MUI4TH4gMLsQC6S0bOnT
=CjvU
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
