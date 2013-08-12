Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3HLJMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:12:38 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53248 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3HLJMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
References: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
Date: Mon, 12 Aug 2013 14:42:31 +0530
Message-ID: <CAK9yfHwEPEfhMCWGbDWK2NQE2zAgmsQc6_Dn498pRP4UX6sYmQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: exynos: add support for MSI
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        SRIKANTH TUMKUR SHIVANAND <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sean Cross <xobs@kosagi.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 12 August 2013 14:26, Jingoo Han <jg1.han@samsung.com> wrote:
> This patch adds support for Message Signaled Interrupt in the
> Exynops PCIe diver using Synopsys designware PCIe core IP.

s/Exynops PCIe diver/Exynos PCIe driver

>
> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> Signed-off-by: Srikanth T Shivanand <ts.srikanth@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> ---
>  arch/arm/boot/dts/exynos5440.dtsi  |    2 +
>  arch/arm/mach-exynos/Kconfig       |    1 +
>  drivers/pci/host/pci-exynos.c      |   60 ++++++++++
>  drivers/pci/host/pcie-designware.c |  213 ++++++++++++++++++++++++++++++++++++
>  drivers/pci/host/pcie-designware.h |    8 ++
>  5 files changed, 284 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
> index 586134e..3746835 100644
> --- a/arch/arm/boot/dts/exynos5440.dtsi
> +++ b/arch/arm/boot/dts/exynos5440.dtsi
> @@ -249,6 +249,7 @@
>                 interrupt-map-mask = <0 0 0 0>;
>                 interrupt-map = <0x0 0 &gic 53>;
>                 num-lanes = <4>;
> +               msi-base = <200>;

Please update the bindings documentation too.

>         };
>
>         pcie@2a0000 {
> @@ -269,5 +270,6 @@
[snip]
>
> +#ifdef CONFIG_PCI_MSI
> +static void exynos_pcie_clear_irq_level(struct pcie_port *pp)
> +{
> +       u32 val;
> +       struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
> +       void __iomem *elbi_base = exynos_pcie->elbi_base;
> +
> +       val = readl(elbi_base + PCIE_IRQ_LEVEL);
> +       writel(val, elbi_base + PCIE_IRQ_LEVEL);

Sorry, I did not get this. Writing the value read from the same
register without any operation.

-- 
With warm regards,
Sachin
