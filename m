Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaGKOv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:51:59 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53498 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaGKOv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:51:57 -0400
Date: Fri, 11 Jul 2014 16:51:47 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: pdeschrijver@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
Message-ID: <20140711145146.GA6523@ulmo>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 05:18:30PM +0300, Mikko Perttunen wrote:
> Add binding documentation for the nvidia,tegra124-emc device tree
> node.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  .../bindings/memory-controllers/tegra-emc.txt      | 42 ++++++++++++++++=
++++++
>  1 file changed, 42 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/memory-controllers/=
tegra-emc.txt
>=20
> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-e=
mc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
> new file mode 100644
> index 0000000..2dde17e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
> @@ -0,0 +1,42 @@
> +Tegra124 SoC EMC controller
> +
> +Required properties :
> +- compatible : "nvidia,tegra124-emc".
> +- reg : Should contain 1 or 2 entries:
> +  - EMC register set
> +  - MC register set : Required only if no node with
> +    'compatible =3D "nvidia,tegra124-mc"' exists. The MC register set
> +    is first read from the MC node. If it doesn't exist, it is read
> +    from this property.

No can do. Memory regions shouldn't be shared between drivers like this.
It makes it impossible to ensure that they don't stump on each others'
toes.

One possibility to make this work is to export global functions from the
memory controller driver that this driver can call into. Perhaps if you
want you can be extra explicit by linking them in DT, like this:

	mc: memory-controller@0,70019000 {
		compatible =3D "nvidia,tegra124-mc";
		reg =3D <0x0 0x70019000 0x0 0x00001000>;
		...
	};

	memory-controller@0,7001b000 {
		compatible =3D "nvidia,tegra124-emc";
		reg =3D <0x0 0x7001b000 0x0 0x00001000>;
		memory-controller =3D <&mc>;
		...
	};

But I think it's safe enough to assume that there will only be a single
memory controller/EMC pair in the device.

Thierry

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTv/oCAAoJEN0jrNd/PrOhzQkQALGAnMdHYbyJkd7LKouan99x
8GbDnQmaM5ThtC4A27u9fahogSq7MuB15dBkqsR+VKjH7u1Eptkg0YFWbiSn0MIi
uvLhVBdcqwjqbHoGC/RGjrvU/luqHxUHoBia1hMqBEjm9toZUqoWy+AoBlXN9oYy
D8+iySspQAueOuFTM1kZrg5t31h/fySyZ2Sflh1unP/q1qEdiZE0NVKU8TaO4bxP
kXzj6RtW5duPNJjol7yu8YyAWl1MHd7uJjUChBHHX3TzWMK6khMsnl2LkbpvY+19
r8a6DKooA62qpxFocQwcoB+UQc86Vom7/6QoB22TvaDNwR3CeIOY4I062tfwbDHy
Mr6FA92mwL8/7t3OqPBie3tx1HhDHZpiQmG+C+/qm7FptKLs/i8yzmqlwQ2nHrkx
d+KT/Jl61Co8ce7Cvt2+j5pBrw9l4vxgxdKUInb3sbYmz+feGe5hx7DvUVJ3bP7M
uLlwDRuuTcy76h8UZgnlmBn+gvIYZg8np4R9H2ACuUZBDQl3qOjmom7S2EwVtaXU
yUtbFnjgnpoZGBn+csLjXfjfK3s/NlBZMvrNgA73soMPjK5v5jJ5l0yL30JlCgmn
thDmoAoA2qh87YSx5pv95XAcS1rSZcr+KENe2e8QRAMg2aPBFElfsLfjofUgGLZr
POo682DcBGzbAPcPYGZ1
=40vN
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
