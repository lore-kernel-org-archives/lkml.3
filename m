Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaHMHfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:35:50 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50903 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaHMHfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:35:48 -0400
Date: Wed, 13 Aug 2014 09:35:44 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/3] of: Add descriptions of thermtrip properties to
 Tegra PMC bindings
Message-ID: <20140813073541.GA17466@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <1407226380-747-2-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <1407226380-747-2-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 11:12:58AM +0300, Mikko Perttunen wrote:
> Hardware-triggered thermal reset requires configuring the I2C
> reset procedure. This configuration is read from the device tree,
> so document the relevant properties in the binding documentation.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  .../devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt    | 13 +++++++=
++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-p=
mc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
> index 68ac65f..140e2aa 100644
> --- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
> @@ -38,6 +38,19 @@ Required properties when nvidia,suspend-mode is specif=
ied:
>  			      Core power good time in uS.
>  - nvidia,core-pwr-off-time : Core power off time in uS.
> =20
> +Required properties for hardware-triggered thermal reset:
> +    (only tegra30, tegra114, tegra124)
> +- nvidia,thermtrip-pmu-i2c-addr : I2C address of the power management un=
it.
> +- nvidia,thermtrip-i2c-controller : Index of the I2C controller the PMU =
is
> +                                    attached to.

This duplicates information already associated with the PMU device. Can
this be turned into something like:

	nvidia,thermtrip-pmu: phandle to Power Management Unit

Then we can query the relevant information from the I2C client resolved
=66rom the phandle.

One problem with that might be that the I2C controller index may not
match the hardware ID.

> +- nvidia,thermtrip-reg-addr : Address (byte) to send reset command to.
> +- nvidia,thermtrip-reg-data : Data (byte) to use as reset command.
> +
> +Optional properties for hardware-triggered thermal reset:
> +    (only tegra30, tegra114, tegra124)
> +- nvidia,thermtrip-pinmux : Pinmux ID used for I2C access.

I suppose this takes a phandle? If so the description should probably
say so.

> +- nvidia,thermtrip-pmu-16bit-ops : Use 16-bit operations.

What exactly does "16-bit operations" mean? And isn't this a property of
the I2C device, therefore could be queried from the I2C slave via the
phandle?

Thierry

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6xVNAAoJEN0jrNd/PrOhLhoP/25rLq0IgBxLPoe1zapS8Nco
Ok0kXocn87qNe8r6wTy2WXIIhgCvVLIj7TXt5gsE9c/rZyPnF0jAxXLfbrEWp2Ck
Ac/D76dXFeIHDqj5jBpQCWwlJm2jYzDmrJ9z1ypL7mshj9Lq/C0NjO0F+o7Fa/R/
XxjBr6HNWFFEudMDifItoYBBa2Xw5NDrnFnbFeKfvlNe+zi5ok07pDwmr30vTpGR
aTetexMV+ANZtBSi9+2HRsHLVEZKMsO32BFAJ4sGFRVTPIBk9AtvoDZVHIhwLTs9
mv9bfgNkmonyXX8zIenH6DsabKM0awaEdPex6YfrGTst/FRyyYnQeW8wh9leKzxt
sbAJgxtvEzz4tlc2/LAsXPtDxds8tjMFR3V0A2IjVbXW9dDXSA2cFv4farX78ijr
J3Ue/Et4gKQdXmZSZLM+cUneqO+nCiP2zceE8A8z0IQN34wgw8liYlHgH4Q33EFv
gYLSUDWQwV4+wWW0DeTIEt6C0rzWW2fJJySMnL5fYb595aszlJR7uw9lJMFlToMO
zxD0n038lV94fUTIafEsGoqWWYm8GYE7zJmWC90uRq55dUL8Kyuepvw9ReYmr0G/
8vWH3lUgpoRH6hWQRv+UTBNUbj2OQ3y5ynW1D4QPPVztDpc70GJYJFJWZ1IsjJnH
Ex4OWOopz+V6Z/nTmih3
=ERs4
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
