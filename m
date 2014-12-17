Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaLQKgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:36:54 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:46336 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbaLQKgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:36:21 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-pci@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/5] PCI: st: Add Device Tree bindings for sti pcie
Date: Wed, 17 Dec 2014 11:34:43 +0100
Message-Id: <1418812486-12394-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_03:2014-12-17,2014-12-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sti pcie is built around a Synopsis Designware PCIe IP.

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 Documentation/devicetree/bindings/pci/st-pcie.txt | 53 +++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/st-pcie.txt

diff --git a/Documentation/devicetree/bindings/pci/st-pcie.txt b/Documentation/devicetree/bindings/pci/st-pcie.txt
new file mode 100644
index 0000000..bd3488f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/st-pcie.txt
@@ -0,0 +1,53 @@
+STMicroelectronics STi PCIe controller
+
+This PCIe host controller is based on the Synopsis Designware PCIe IP
+and thus inherits all the common properties defined in designware-pcie.txt.
+
+Required properties:
+ - compatible: "st,stih407-pcie"
+ - reg: base address and length of the pcie controller, mem-window address
+   and length available to the controller.
+ - interrupts: A list of interrupt outputs of the controller.
+ - interrupt-names: Must include the following entries:
+   "msi": STi interrupt that is asserted when an MSI is received
+ - st,syscfg : should be a phandle of the syscfg node. Also contains syscfg
+   offset for IP configuration.
+ - resets, reset-names: the power-down and soft-reset lines of PCIe IP.
+   Associated names must be "powerdown" and "softreset".
+ - phys, phy-names: the phandle for the PHY device.
+   Associated name must be "pcie_phy"
+
+Optional properties:
+ - reset-gpio: a GPIO spec to define which pin is connected to the bus reset.
+
+Example:
+
+pcie0: pcie@9b00000 {
+	compatible = "st,stih407-pcie", "snps,dw-pcie";
+	device_type = "pci";
+	reg = <0x09b00000 0x4000>,	/* dbi cntrl registers */
+	      <0x2fff0000 0x00010000>,	/* configuration space */
+	      <0x40000000 0x80000000>;	/* lmi mem window */
+	reg-names = "dbi", "config", "mem-window";
+	st,syscfg = <&syscfg_core 0xd8 0xe0>;
+	#address-cells = <3>;
+	#size-cells = <2>;
+	ranges = <0x00000800 0 0x2fff0000 0x2fff0000 0 0x00010000   /* configuration space */
+		  0x82000000 0 0x20000000 0x20000000 0 0x0FFF0000>; /* non-prefetchable memory */
+	num-lanes = <1>;
+	interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>;
+	interrupt-names = "msi";
+	#interrupt-cells = <1>;
+	interrupt-map-mask = <0 0 0 7>;
+	interrupt-map = <0 0 0 1 &intc GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>, /* INT A */
+			<0 0 0 2 &intc GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>, /* INT B */
+			<0 0 0 3 &intc GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>, /* INT C */
+			<0 0 0 4 &intc GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>; /* INT D */
+
+	resets = <&powerdown STIH407_PCIE0_POWERDOWN>,
+		 <&softreset STIH407_PCIE0_SOFTRESET>;
+	reset-names = "powerdown",
+		      "softreset";
+	phys = <&phy_port0 PHY_TYPE_PCIE>;
+	phy-names = "pcie_phy";
+};
-- 
1.9.1

