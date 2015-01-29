Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbbA2KCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:02:24 -0500
Received: from mout.gmx.net ([212.227.17.20]:59280 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035AbbA2KCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:02:20 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Andrey Danin <danindrey@mail.ru>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        ac100@lists.launchpad.net, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH 3/3] dt: paz00: define nvec as child of i2c bus
Date: Thu, 29 Jan 2015 11:01:56 +0100
Message-ID: <1500927.ysGdJAUmOd@fb07-iapwap2>
User-Agent: KMail/4.14.4 (Linux/3.18.3-1-desktop; KDE/4.14.4; x86_64; ; )
In-Reply-To: <1422516022-27161-4-git-send-email-danindrey@mail.ru>
References: <1422516022-27161-1-git-send-email-danindrey@mail.ru> <1422516022-27161-4-git-send-email-danindrey@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6458978.GtOuVI5b9r"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:TZnkpS2Tn0k+nLBPXZ3u37ZDknOxeCi2Xivounx9EV4eckvqdwW
 nUZAxQpLekaAMiafgloqZemxZN4rEFKDXnZdZEcqfG/0yrklBP/euBgUJ9rxBfs7TQVLWWQ
 Xf3el0B66uJspfVCD/+WGSDd+yJaPfrK8KOQsHyF5WlfUwXbFb7paC4zXe4+P1fwQmQX+Q9
 yfDwZdgz1cc2KCgE5hAJg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6458978.GtOuVI5b9r
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Am Donnerstag, 29. Januar 2015, 10:20:22 schrieb Andrey Danin:
> NVEC driver was reimplemented to use tegra i2c. Use common i2c bindings
> for NVEC node.
> 
> Signed-off-by: Andrey Danin <danindrey@mail.ru>
> ---
>  .../devicetree/bindings/nvec/nvidia,nvec.txt       | 19 ++-----------------
> arch/arm/boot/dts/tegra20-paz00.dts                | 22
> +++++++++------------- 2 files changed, 11 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt
> b/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt index
> 5ae601e..d82c125 100644
> --- a/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt
> +++ b/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt
> @@ -2,20 +2,5 @@ NVIDIA compliant embedded controller
> 
>  Required properties:
>  - compatible : should be "nvidia,nvec".

based on the earlier discussion with Wolfram, this should be "nvidia,nvec-
slave" to distunguish it from a possible nvec master driver.


> -- reg : the iomem of the i2c slave controller
> -- interrupts : the interrupt line of the i2c slave controller
> -- clock-frequency : the frequency of the i2c bus
> -- gpios : the gpio used for ec request
> -- slave-addr: the i2c address of the slave controller
> -- clocks : Must contain an entry for each entry in clock-names.
> -  See ../clocks/clock-bindings.txt for details.
> -- clock-names : Must include the following entries:
> -  Tegra20/Tegra30:
> -  - div-clk
> -  - fast-clk
> -  Tegra114:
> -  - div-clk
> -- resets : Must contain an entry for each entry in reset-names.
> -  See ../reset/reset.txt for details.
> -- reset-names : Must include the following entries:
> -  - i2c
> +- request-gpios : the gpio used for ec request
> +- reg: the i2c address of the slave controller
> diff --git a/arch/arm/boot/dts/tegra20-paz00.dts
> b/arch/arm/boot/dts/tegra20-paz00.dts index ed7e100..65e247b 100644
> --- a/arch/arm/boot/dts/tegra20-paz00.dts
> +++ b/arch/arm/boot/dts/tegra20-paz00.dts
> @@ -288,20 +288,16 @@
>  		clock-frequency = <100000>;
>  	};
> 
> -	nvec@7000c500 {
> -		compatible = "nvidia,nvec";
> -		reg = <0x7000c500 0x100>;
> -		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
> -		#address-cells = <1>;
> -		#size-cells = <0>;
> +	i2c@7000c500 {
> +		status = "okay";
>  		clock-frequency = <80000>;
> -		request-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
> -		slave-addr = <138>;
> -		clocks = <&tegra_car TEGRA20_CLK_I2C3>,
> -		         <&tegra_car TEGRA20_CLK_PLL_P_OUT3>;
> -		clock-names = "div-clk", "fast-clk";
> -		resets = <&tegra_car 67>;
> -		reset-names = "i2c";
> +
> +		nvec: nvec@45 {
> +			compatible = "nvidia,nvec";
> +			request-gpios = <&gpio TEGRA_GPIO(V, 2)
> +				GPIO_ACTIVE_HIGH>;
> +			reg = <0x45>;
> +		};
>  	};
> 
>  	i2c@7000d000 {

--nextPart6458978.GtOuVI5b9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJUygUUAAoJEKyeR39HFBto68gIAJ2XSrdQVRtVsDp4YypU04yZ
iVy/q6T+vR3/PZJcsF4FbCGQOepLMdLnHBJ1pubUkezKCjnnmj89t0asVwk0P5a+
B+paMVQiBzm3YEpy2YnXuRcpmWweOWllpgd6b4SXKf7+NjtTLbbDtCtT14z1KneV
EocOzEpzA6TxfhxWmxOtHRyJFMaNmX9TGWUgHK4UsgWHcJk1fmTYeGGMknXquuSK
jJbsQCzxZ9dlrPgKriNWZKZKD+retfyXQ1o3q0iZwFb+1FzvDNWX/mMjl2IyPMRT
QyzyQ4BYUV8vI4rjA1RtT845b9DZuA4P/yTPMUx+eMm8eFCQzgNBbRpJAQ6Kg3w=
=ND/s
-----END PGP SIGNATURE-----

--nextPart6458978.GtOuVI5b9r--

