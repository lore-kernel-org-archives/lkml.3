Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946020AbaGRTcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:32:04 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49940 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbaGRTcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <1405696469-7172-5-git-send-email-m-karicheri2@ti.com>
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com> <1405696469-7172-5-git-send-email-m-karicheri2@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 18 Jul 2014 14:31:39 -0500
Message-ID: <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] PCI: add PCI controller for keystone PCIe h/w
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 10:14 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> keystone PCIe controller is based on v3.65 version of the
> designware h/w. Main differences are
>         1. No ATU support
>         2. Legacy and MSI irq functions are implemented in
>            application register space
>         3. MSI interrupts are multiplexed over 8 IRQ lines to the Host
>            side.
> All of the Application register space handing code are organized into
> pci-keystone-dw.c and the functions are called from pci-keystone.c
> to implement PCI controller driver. Also add necessary DT documentation
> for the driver.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mohit Kumar <mohit.kumar@st.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Pratyush Anand <pratyush.anand@st.com>
> CC: Richard Zhu <r65037@freescale.com>
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Marek Vasut <marex@denx.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Grant Likely <grant.likely@linaro.org>
> ---
>  .../devicetree/bindings/pci/pci-keystone.txt       |   71 +++
>  drivers/pci/host/Kconfig                           |    5 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-keystone-dw.c                 |  516 ++++++++++++++++++++
>  drivers/pci/host/pci-keystone.c                    |  385 +++++++++++++++
>  drivers/pci/host/pci-keystone.h                    |   59 +++
>  6 files changed, 1037 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
>  create mode 100644 drivers/pci/host/pci-keystone-dw.c
>  create mode 100644 drivers/pci/host/pci-keystone.c
>  create mode 100644 drivers/pci/host/pci-keystone.h
>
> diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
> new file mode 100644
> index 0000000..9c96164
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
> @@ -0,0 +1,71 @@
> +TI Keystone PCIe interface
> +
> +Keystone PCI host Controller is based on Designware PCI h/w version 3.65.
> +It shares common functions with PCIE Designware core driver and inherit
> +common properties defined in
> +Documentation/devicetree/bindings/pci/designware-pci.txt
> +
> +Please refer to Documentation/devicetree/bindings/pci/designware-pci.txt
> +for the details of designware DT bindings. Additional properties are
> +described here as well propeties that are not applicable.
> +
> +Required Properties:-
> +
> +compatibility: "ti,keystone-pcie"
> +reg:   index 1 is the base address and length of DW application registers.
> +       index 2 is the base address and length of PCI mode configuration
> +       register.
> +       index 3 is the base address and length of PCI device ID register.
> +
> +pcie_msi_intc : Interrupt controller device node for MSI irq chip
> +       interrupt-cells: should be set to 1
> +       interrupt-parent: Parent interrupt controller phandle
> +       interrupts: GIC interrupt lines connected to PCI MSI interrupt lines
> +
> + Example:
> +       pcie_msi_intc: msi-interrupt-controller {
> +                       interrupt-controller;
> +                       #interrupt-cells = <1>;
> +                       interrupt-parent = <&gic>;
> +                       interrupts = <GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 37 IRQ_TYPE_EDGE_RISING>;
> +       };
> +
> +pcie_intc: Interrupt controller device node for Legacy irq chip
> +       interrupt-cells: should be set to 1
> +       interrupt-parent: Parent interrupt controller phandle
> +       interrupts: GIC interrupt lines connected to PCI Legacy interrupt lines
> +
> + Example:
> +       pcie_intc: legacy-interrupt-controller {
> +               interrupt-controller;
> +               #interrupt-cells = <1>;
> +               interrupt-parent = <&gic>;
> +               interrupts = <GIC_SPI 26 IRQ_TYPE_EDGE_RISING>,
> +                       <GIC_SPI 27 IRQ_TYPE_EDGE_RISING>,
> +                       <GIC_SPI 28 IRQ_TYPE_EDGE_RISING>,
> +                       <GIC_SPI 29 IRQ_TYPE_EDGE_RISING>;
> +       };

This seems wrong. Legacy interrupts should be described with
interrupt-map and then PCI child devices have a standard interrupt
specifier.

I'm not sure about MSIs, but I would think they would have a standard
format too.

> +
> +Optional properties:-
> +       phys: phandle to Generic Keystone SerDes phy for PCI
> +       phy-names: name of the Generic Keystine SerDes phy for PCI
> +         - If boot loader already does PCI link establishment, then phys and
> +           phy-names shouldn't be present.
> +       ti,enable-linktrain - Enable Link training.
> +         - If boot loader already does PCI link establishment, then this
> +           shouldn't be present.

Can't you read from the h/w if the link is trained?

Rob
