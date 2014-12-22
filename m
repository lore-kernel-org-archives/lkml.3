Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaLVErd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 23:47:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbaLVErb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 23:47:31 -0500
Message-ID: <5497A1FA.1090808@redhat.com>
Date: Mon, 22 Dec 2014 10:15:46 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-pci@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/5] PCI: st: Add Device Tree bindings for sti pcie
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org> <1418812486-12394-3-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1418812486-12394-3-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 17 December 2014 04:04 PM, Gabriel FERNANDEZ wrote:
> sti pcie is built around a Synopsis Designware PCIe IP.
>
> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>   Documentation/devicetree/bindings/pci/st-pcie.txt | 53 +++++++++++++++++++++++
>   1 file changed, 53 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/pci/st-pcie.txt
>
> diff --git a/Documentation/devicetree/bindings/pci/st-pcie.txt b/Documentation/devicetree/bindings/pci/st-pcie.txt
> new file mode 100644
> index 0000000..bd3488f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/st-pcie.txt
> @@ -0,0 +1,53 @@
> +STMicroelectronics STi PCIe controller
> +
> +This PCIe host controller is based on the Synopsis Designware PCIe IP
> +and thus inherits all the common properties defined in designware-pcie.txt.
> +
> +Required properties:
> + - compatible: "st,stih407-pcie"
> + - reg: base address and length of the pcie controller, mem-window address
> +   and length available to the controller.
> + - interrupts: A list of interrupt outputs of the controller.
> + - interrupt-names: Must include the following entries:
> +   "msi": STi interrupt that is asserted when an MSI is received
> + - st,syscfg : should be a phandle of the syscfg node. Also contains syscfg
> +   offset for IP configuration.
> + - resets, reset-names: the power-down and soft-reset lines of PCIe IP.
> +   Associated names must be "powerdown" and "softreset".
> + - phys, phy-names: the phandle for the PHY device.
> +   Associated name must be "pcie_phy"
> +
> +Optional properties:
> + - reset-gpio: a GPIO spec to define which pin is connected to the bus reset.
> +
> +Example:
> +
> +pcie0: pcie@9b00000 {
> +	compatible = "st,stih407-pcie", "snps,dw-pcie";
> +	device_type = "pci";
> +	reg = <0x09b00000 0x4000>,	/* dbi cntrl registers */
> +	      <0x2fff0000 0x00010000>,	/* configuration space */
> +	      <0x40000000 0x80000000>;	/* lmi mem window */
> +	reg-names = "dbi", "config", "mem-window";
> +	st,syscfg = <&syscfg_core 0xd8 0xe0>;
> +	#address-cells = <3>;
> +	#size-cells = <2>;
> +	ranges = <0x00000800 0 0x2fff0000 0x2fff0000 0 0x00010000   /* configuration space */

Pass it through reg property.
See: arch/arm/boot/dts/spear1310.dtsi or any other dw pcie's dtsi.


@Jingoo, Mohit: I would suggest following changes so that no upcoming 
platform can add it through ranges.

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 4fc03b7f1cee..f21570847d08 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -143,8 +143,7 @@
                         #address-cells = <3>;
                         #size-cells = <2>;
                         device_type = "pci";
-                       ranges = <0x00000800 0 0x01f00000 0x01f00000 0 
0x00080000 /* configuration space */
-                                 0x81000000 0 0          0x01f80000 0 
0x00010000 /* downstream I/O */
+                       ranges = 0x81000000 0 0          0x01f80000 0 
0x00010000 /* downstream I/O */
                                   0x82000000 0 0x01000000 0x01000000 0 
0x00f00000>; /* non-prefetchable memory */
                         num-lanes = <1>;
                         interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 7a24fee1e7ae..72593a77455e 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -1197,14 +1197,14 @@

                 pcie: pcie@0x08000000 {
                         compatible = "fsl,imx6sx-pcie", "snps,dw-pcie";
-                       reg = <0x08ffc000 0x4000>; /* DBI */
+                       reg = <0x08ffc000 0x4000>, /* DBI */
+                               <0x08f00000 0x80000>;
+                       reg-names = "dbi", "config";
                         #address-cells = <3>;
                         #size-cells = <2>;
                         device_type = "pci";
-                                 /* configuration space */
-                       ranges = <0x00000800 0 0x08f00000 0x08f00000 0 
0x00080000
                                   /* downstream I/O */
-                                 0x81000000 0 0          0x08f80000 0 
0x00010000
+                       ranges =  0x81000000 0 0          0x08f80000 0 
0x00010000
                                   /* non-prefetchable memory */
                                   0x82000000 0 0x08000000 0x08000000 0 
0x00f00000>;
                         num-lanes = <1>;
diff --git a/drivers/pci/host/pcie-designware.c 
b/drivers/pci/host/pcie-designware.c
index df781cdf13c1..0b22b42e1ff9 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -409,19 +409,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
                         pp->mem_mod_base = of_read_number(parser.range -
                                                           parser.np + 
na, ns);
                 }
-               if (restype == 0) {
-                       of_pci_range_to_resource(&range, np, &pp->cfg);
-                       pp->cfg0_size = resource_size(&pp->cfg)/2;
-                       pp->cfg1_size = resource_size(&pp->cfg)/2;
-                       pp->cfg0_base = pp->cfg.start;
-                       pp->cfg1_base = pp->cfg.start + pp->cfg0_size;
-
-                       /* Find the untranslated configuration space 
address */
-                       pp->cfg0_mod_base = of_read_number(parser.range -
-                                                          parser.np + 
na, ns);
-                       pp->cfg1_mod_base = pp->cfg0_mod_base +
-                                           pp->cfg0_size;
-               }
         }

         ret = of_pci_parse_bus_range(np, &pp->busn);


Regards
Pratyush

> +		  0x82000000 0 0x20000000 0x20000000 0 0x0FFF0000>; /* non-prefetchable memory */
> +	num-lanes = <1>;
> +	interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>;
> +	interrupt-names = "msi";
> +	#interrupt-cells = <1>;
> +	interrupt-map-mask = <0 0 0 7>;
> +	interrupt-map = <0 0 0 1 &intc GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>, /* INT A */
> +			<0 0 0 2 &intc GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>, /* INT B */
> +			<0 0 0 3 &intc GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>, /* INT C */
> +			<0 0 0 4 &intc GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>; /* INT D */
> +
> +	resets = <&powerdown STIH407_PCIE0_POWERDOWN>,
> +		 <&softreset STIH407_PCIE0_SOFTRESET>;
> +	reset-names = "powerdown",
> +		      "softreset";
> +	phys = <&phy_port0 PHY_TYPE_PCIE>;
> +	phy-names = "pcie_phy";
> +};
>
