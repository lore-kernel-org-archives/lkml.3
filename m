Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3JHIR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:17:29 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51755 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3JHIRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:17:25 -0400
Message-ID: <5253BF8E.4050802@monstr.eu>
Date: Tue, 08 Oct 2013 10:17:18 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, gnurou@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v7 1/5] ARM: add basic support for Trusted Foundations
References: <1380904635-18113-1-git-send-email-acourbot@nvidia.com> <1380904635-18113-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1380904635-18113-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BDpjDvjmMN2UQURjhm38bdHVcwUhd0upd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BDpjDvjmMN2UQURjhm38bdHVcwUhd0upd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 10/04/2013 06:37 PM, Alexandre Courbot wrote:
> Trusted Foundations is a TrustZone-based secure monitor for ARM that
> can be invoked using the same SMC-based API on all supported
> platforms. This patch adds initial basic support for Trusted
> Foundations using the ARM firmware API. Current features are limited
> to the ability to boot secondary processors.
>=20
> Note: The API followed by Trusted Foundations does *not* follow the SMC=

> calling conventions. It has nothing to do with PSCI neither and is only=

> relevant to devices that use Trusted Foundations (like most Tegra-based=

> retail devices).
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
>  .../arm/firmware/tl,trusted-foundations.txt        | 17 +++++
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  arch/arm/Kconfig                                   |  2 +
>  arch/arm/Makefile                                  |  1 +
>  arch/arm/firmware/Kconfig                          | 28 ++++++++
>  arch/arm/firmware/Makefile                         |  1 +
>  arch/arm/firmware/trusted_foundations.c            | 77 ++++++++++++++=
++++++++
>  arch/arm/include/asm/trusted_foundations.h         | 64 ++++++++++++++=
++++
>  8 files changed, 191 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,t=
rusted-foundations.txt
>  create mode 100644 arch/arm/firmware/Kconfig
>  create mode 100644 arch/arm/firmware/Makefile
>  create mode 100644 arch/arm/firmware/trusted_foundations.c
>  create mode 100644 arch/arm/include/asm/trusted_foundations.h
>=20
> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-=
foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trust=
ed-foundations.txt
> new file mode 100644
> index 0000000..3954bbd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundat=
ions.txt
> @@ -0,0 +1,17 @@
> +Trusted Foundations
> +
> +Boards that use the Trusted Foundations secure monitor can signal its
> +presence by declaring a node compatible with "tl,trusted-foundations"
> +under the root node.
> +
> +Required properties:
> +- compatible : "tl,trusted-foundations"
> +- version-major : major version number of Trusted Foundations firmware=

> +- version-minor: minor version number of Trusted Foundations firmware
> +
> +Example:
> +	firmware {
> +		compatible =3D "tl,trusted-foundations";
> +		version-major =3D <2>;
> +		version-minor =3D <8>;
> +	};

This is just another example how to add sw description to dts.
I have briefly looked at tegra20.dtsi and there are IPs like timer, intc,=
 etc
which are in the DTS without any bus.

Add this firmware node to the root is just +1 case to this mess
but IMHO will be good to have specific DT part which will be used for
this sw setting which are coming to DTS all the time.

Grant, Rob: Where is the proper location for these type of description?

Thanks,
Michal




--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--BDpjDvjmMN2UQURjhm38bdHVcwUhd0upd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJTv48ACgkQykllyylKDCEYkwCeLioWKoeGiaYBx648ugD2OS+U
rcIAn1v7siGeDBSfU5yRm9YORfSs+hSO
=ZRPE
-----END PGP SIGNATURE-----

--BDpjDvjmMN2UQURjhm38bdHVcwUhd0upd--
