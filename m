Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3FXRGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:06:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49260 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3FXRGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:06:03 -0400
Message-ID: <51C87C4C.8010201@ti.com>
Date: Mon, 24 Jun 2013 13:05:16 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH V7 27/30] ARM: dts: thermal: exynos: Add documentation
 for Exynos SoC thermal bindings
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com> <1372071051-3167-28-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1372071051-3167-28-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2EVHQTLWMITXPMOUBSHXC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2EVHQTLWMITXPMOUBSHXC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24-06-2013 06:50, Amit Daniel Kachhap wrote:
> Proper description for Exynos4 bindings added to Documentation/devicetr=
ee/
> bindings. It adds description to use multiple TMU instances, optional v=
oltage
> supply node and optional shared register across multiple TMU's.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   55 ++++++++++++=
++++++++
>  1 files changed, 55 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos-th=
ermal.txt
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> new file mode 100644
> index 0000000..284f530
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -0,0 +1,55 @@
> +* Exynos Thermal Management Unit (TMU)
> +
> +** Required properties:
> +
> +- compatible : One of the following:
> +	       "samsung,exynos4412-tmu"
> +	       "samsung,exynos4210-tmu"
> +	       "samsung,exynos5250-tmu"
> +	       "samsung,exynos5440-tmu"
> +- interrupt-parent : The phandle for the interrupt controller
> +- reg : Address range of the thermal registers. For soc's which has mu=
ltiple
> +	instances of TMU and some registers are shared across all TMU's like
> +	interrupt related then 2 set of register has to supplied. First set
> +	belongs	to each instance of TMU and second set belongs to common TMU
> +	registers.
> +- interrupts : Should contain interrupt for thermal system
> +- clocks : The main clock for TMU device
> +- clock-names : Thermal system clock name
> +- vtmu-supply: This entry is optional and provides the regulator node =
supplying
> +		voltage to TMU. If needed this entry can be placed inside
> +		board/platform specific dts file.
> +
> +Example 1):
> +
> +	tmu@100C0000 {
> +		compatible =3D "samsung,exynos4412-tmu";
> +		interrupt-parent =3D <&combiner>;
> +		reg =3D <0x100C0000 0x100>;
> +		interrupts =3D <2 4>;
> +		clocks =3D <&clock 383>;
> +		clock-names =3D "tmu_apbif";
> +		status =3D "disabled";
> +		vtmu-supply =3D <&tmu_regulator_node>;
> +	};
> +
> +Example 2):
> +
> +	tmuctrl_0: tmuctrl@160118 {
> +		compatible =3D "samsung,exynos5440-tmu";
> +		reg =3D <0x160118 0x230>, <0x160368 0x10>;
> +		interrupts =3D <0 58 0>;
> +		clocks =3D <&clock 21>;
> +		clock-names =3D "tmu_apbif";
> +	};
> +
> +Note: For multi-instance tmu each instance should have an alias correc=
tly
> +numbered in "aliases" node.
> +
> +Example:
> +
> +aliases {
> +	tmuctrl0 =3D &tmuctrl_0;
> +	tmuctrl1 =3D &tmuctrl_1;
> +	tmuctrl2 =3D &tmuctrl_2;
> +};
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2EVHQTLWMITXPMOUBSHXC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHIfEwACgkQCXcVR3XQvP1pbAEA9LKmgRwaKPy84wSNu+r3gQOS
h9K0o3tXud98mKpgkfcA/0qcNy6VnyjC8hpkaU6WWw3MoIFhali5JmECby8QCIym
=4y+7
-----END PGP SIGNATURE-----

------enig2EVHQTLWMITXPMOUBSHXC--
