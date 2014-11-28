Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaK1Pao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:30:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42209 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaK1Pam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:30:42 -0500
Date: Fri, 28 Nov 2014 15:30:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141128153008.GS7712@sirena.org.uk>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-9-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LiyRbxGJ62giS2IN"
Content-Disposition: inline
In-Reply-To: <1417146874-5232-9-git-send-email-flora.fu@mediatek.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 8/8] ARM: dts: mt8135: Add support for MT6397 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LiyRbxGJ62giS2IN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 11:54:34AM +0800, Flora Fu wrote:

> Add device tree for MT6397 regulators in mt8135.dtsi.
>=20
> Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8135.dtsi | 192 ++++++++++++++++++++++++++++++++++++=
++++++

This appears to be the DT fragment for a SoC but you are defining the
system integration for the PMIC.  That's bad, the PMIC is a separate
device so should be hooked up by the board using it.  If there's common
elements from a reference design they should be in their own .dtsi.

> +					mt6397_vsramca15_reg: buck_vsramca15 {
> +						regulator-name =3D "vsramca15";
> +						regulator-min-microvolt =3D < 700000>;
> +						regulator-max-microvolt =3D <1493750>;
> +						regulator-ramp-delay =3D <12500>;
> +						regulator-enable-ramp-delay =3D <115>;
> +						regulator-always-on;
> +						regulator-boot-on;

Why do these regulators have both a board specific ramp delay specified
and -always-on?  If they are always on presumably they never ramp at
runtime; if this is a generic parameter for the device it should be in
the driver.

Similarly why is boot_on being specified - we can read the startup state
for all these regulators?

> +					};
> +
> +					mt6397_vsramca7_reg: buck_vsramca7 {
> +						regulator-name =3D "vsramca7";
> +						regulator-min-microvolt =3D < 700000>;
> +						regulator-max-microvolt =3D <1493750>;

All these regulators seem to have exactly the same range specified which
looks awfully like it might be the maximum variability the regulator has
rather than the board specific range that's supported; the fact that
they appear to have no consumers that might vary the voltage is another
warning sign.  This is probably wrong, the constraints should be
whatever is verified good for the board.

--LiyRbxGJ62giS2IN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJT/AAoJECTWi3JdVIfQLg8H/Ao23lVYsnJRmBYTOC+Nl5Oq
cA0oLkfl10dVNg232DwPTfO+HRbpg2m8sJXpj1jqThdJPSMpDaA45PiiJIJhkCjf
1/IM92jXbU7N1aBdtqigLmMlW7Uw4TBDGsXwZOm21lxy87RTSDyHnEZoohjgnH6D
y1zrCrDDNSXMYAtALdNxfhQMYlFEWyQoAaRpGlZfeH+m9KcvkK+S5y091QPzxZX6
ZAGVo3MR6fxO/t48lG1/GIsEJ1nlfdVVlHmcraoUlf4fGlhypn2i6RcdJ4kHQQ4j
vn1gpI4xKacuZTl97Nbm9nTE2PEn3PS1nrFtTB4Kaq2SZ3hSN4dEvjy7SCCtXko=
=G80z
-----END PGP SIGNATURE-----

--LiyRbxGJ62giS2IN--
