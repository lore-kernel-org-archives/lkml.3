Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaA2RSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:18:34 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65255 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaA2RSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:18:32 -0500
MIME-Version: 1.0
In-Reply-To: <1390952176-30402-5-git-send-email-pdeschrijver@nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
	<1390952176-30402-5-git-send-email-pdeschrijver@nvidia.com>
Date: Wed, 29 Jan 2014 11:18:31 -0600
Message-ID: <CAL_JsqKy2rMT6tuTOJGqVeuRsGHsdnJ9w-sECG5ML9Z1aRpiNg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] ARM: tegra: Add efuse bindings
From: Rob Herring <robherring2@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 5:36 PM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> Add efuse bindings for Tegra20, Tegra30, Tegra114 and Tegra124.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Acked-by: Rob Herring <robh@kernel.org>

Rob

> ---
>  .../devicetree/bindings/fuse/fuse-tegra.txt        |   32 ++++++++++++++++++++
>  arch/arm/boot/dts/tegra114.dtsi                    |    7 ++++
>  arch/arm/boot/dts/tegra124.dtsi                    |    7 ++++
>  arch/arm/boot/dts/tegra20.dtsi                     |    7 ++++
>  arch/arm/boot/dts/tegra30.dtsi                     |    7 ++++
>  5 files changed, 60 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/fuse/fuse-tegra.txt
>
> diff --git a/Documentation/devicetree/bindings/fuse/fuse-tegra.txt b/Documentation/devicetree/bindings/fuse/fuse-tegra.txt
> new file mode 100644
> index 0000000..8a566a1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/fuse/fuse-tegra.txt
> @@ -0,0 +1,32 @@
> +NVIDIA Tegra20/Tegra30/Tegr114/Tegra124 fuse driver.
> +
> +Required properties:
> +- compatible : should be:
> +       "nvidia,tegra20-efuse"
> +       "nvidia,tegra30-efuse"
> +       "nvidia,tegra114-efuse"
> +       "nvidia,tegra124-efuse"
> +  Details:
> +  nvidia,tegra20-efuse: Tegra20 requires using APB DMA to read the fuse data
> +       due to a hardware bug. Tegra20 also lacks certain information which is
> +       available in later generations such as fab code, lot code, wafer id,..
> +  nvidia,tegra30-efuse, nvidia,tegra114-efuse and nvidia,tegra124-efuse:
> +       The differences between these SoCs are the size of the efuse array,
> +       the location of the spare (OEM programmable) bits and the location of
> +       the speedo data.
> +- reg: Should contain 2 entries: the first entry gives the physical address
> +       and length of the fuse registers, the second entry gives the physical
> +       address and length of the apbmisc registers. These are used to provide
> +       the chipid, chip revision and strapping options.
> +- clocks: Should contain a pointer to the fuse clock.
> +
> +Example:
> +
> +        fuse@7000f800 {
> +                compatible = "nvidia,tegra20-efuse";
> +                reg = <0x7000F800 0x400>,
> +                      <0x70000000 0x400>;
> +                clocks = <&tegra_car TEGRA20_CLK_FUSE>;
> +        };
> +
> +
> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
> index 389e987..05ca90b 100644
> --- a/arch/arm/boot/dts/tegra114.dtsi
> +++ b/arch/arm/boot/dts/tegra114.dtsi
> @@ -481,6 +481,13 @@
>                 clock-names = "pclk", "clk32k_in";
>         };
>
> +       fuse@7000f800 {
> +               compatible = "nvidia,tegra114-efuse";
> +               reg = <0x7000f800 0x400>,
> +                     <0x70000000 0x400>;
> +               clocks = <&tegra_car TEGRA114_CLK_FUSE>;
> +       };
> +
>         iommu@70019010 {
>                 compatible = "nvidia,tegra114-smmu", "nvidia,tegra30-smmu";
>                 reg = <0x70019010 0x02c
> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
> index ec0698a..30faa73 100644
> --- a/arch/arm/boot/dts/tegra124.dtsi
> +++ b/arch/arm/boot/dts/tegra124.dtsi
> @@ -381,6 +381,13 @@
>                 clock-names = "pclk", "clk32k_in";
>         };
>
> +       fuse@7000f800 {
> +               compatible = "nvidia,tegra124-efuse";
> +               reg = <0x7000f800 0x400>,
> +                     <0x70000000 0x400>;
> +               clocks = <&tegra_car TEGRA124_CLK_FUSE>;
> +       };
> +
>         sdhci@700b0000 {
>                 compatible = "nvidia,tegra124-sdhci";
>                 reg = <0x700b0000 0x200>;
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 480ecda..a1a15d7 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -541,6 +541,13 @@
>                 #size-cells = <0>;
>         };
>
> +       fuse@7000f800 {
> +               compatible = "nvidia,tegra20-efuse";
> +               reg = <0x7000F800 0x400>,
> +                     <0x70000000 0x400>;
> +               clocks = <&tegra_car TEGRA20_CLK_FUSE>;
> +       };
> +
>         pcie-controller@80003000 {
>                 compatible = "nvidia,tegra20-pcie";
>                 device_type = "pci";
> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
> index ed8e770..1ec80fa 100644
> --- a/arch/arm/boot/dts/tegra30.dtsi
> +++ b/arch/arm/boot/dts/tegra30.dtsi
> @@ -623,6 +623,13 @@
>                 nvidia,ahb = <&ahb>;
>         };
>
> +       fuse@7000f800 {
> +               compatible = "nvidia,tegra30-efuse";
> +               reg = <0x7000f800 0x400>,
> +                     <0x70000000 0x400>;
> +               clocks = <&tegra_car TEGRA30_CLK_FUSE>;
> +       };
> +
>         ahub@70080000 {
>                 compatible = "nvidia,tegra30-ahub";
>                 reg = <0x70080000 0x200
> --
> 1.7.7.rc0.72.g4b5ea.dirty
>
