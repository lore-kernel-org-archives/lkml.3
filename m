Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBRVdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:33:21 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38239 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBRVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:33:19 -0500
MIME-Version: 1.0
In-Reply-To: <1392564830-5868-1-git-send-email-sthokal@xilinx.com>
References: <1392564830-5868-1-git-send-email-sthokal@xilinx.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Feb 2014 14:32:58 -0700
Message-ID: <CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
Subject: Re: [PATCH] pcie: Add Xilinx PCIe Host Bridge IP driver
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Arnd]

On Sun, Feb 16, 2014 at 8:33 AM, Srikanth Thokala <sthokal@xilinx.com> wrote:
> This is the driver for Xilinx AXI PCIe Host Bridge Soft IP
>
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
> ---
> - Rebased on v3.14.0-rc2
> ---
>  .../devicetree/bindings/pci/xilinx-pcie.txt        |   43 +
>  drivers/pci/host/Kconfig                           |    7 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-xilinx.c                      |  985 ++++++++++++++++++++
>  4 files changed, 1036 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>  create mode 100644 drivers/pci/host/pci-xilinx.c
>
> diff --git a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
> new file mode 100644
> index 0000000..66a2487
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
> @@ -0,0 +1,43 @@
> +* Xilinx AXI PCIe Root Port Bridge DT description
> +
> +Required properties:
> +- #address-cells: Address representation for root ports, set to <3>
> +- #size-cells: Size representation for root ports, set to <2>
> +- compatible: Should contain "xlnx,axi-pcie-1.00.a"
> +- reg: Should contain AXI PCIe registers location and length
> +- interrupts: Should contain AXI PCIe interrupt
> +- ranges: ranges for the PCI memory regions
> +       Please refer to the standard PCI bus binding document for a more
> +       detailed explanation
> +- xlnx,axibar-num: Number of memory regions configured in the hardware,
> +       maximum being three which is configurable in the hardware.
> +- xlnx,include-rc: Root Port (=1) or End Point (=0)
> +- xlnx,pciebar2axibar-0: Translation address from PCIe to AXI
> +       Only one PCIe BAR is applicable in Root port mode, it can be
> +       either 32/64-bit. If it is 64-bit BAR, lower 32 bits are present
> +       in 'xlnx,pciebar2axibar-0' and Upper 32 bits in 'xlnx,pciebar2
> +       axibar-1'. And if it is 32-bit BAR, only 'xlnx,pciebar2axibar-0'
> +       is valid
> +
> +Optional properties
> +- xlnx,pciebar-as: PCIe BAR aperture size is 32 (=0) or 64-bit (=1).
> +- xlnx,pciebar2axibar-1: Translation address from PCIe to AXI, contains
> +       upper 32 bits if PCIe BAR size is 64-bit. When xlnx,pciebar-as
> +       is set, this is a required property and should contain a valid
> +       value (other than FF's)

I hardly know anything about DT, but xlnx,pciebar2axibar-0,
xlnx,pciebar-as, and xlnx,pciebar2axibar-1 look strange to me.  Is
that really the DT way of dealing with 32/64-bit BARs and host bridge
address translation?  I don't see similar things in the other files in
Documentation/devicetree/bindings/pci/, even though some of the other
drivers/pci/host/*.c files do use pci_add_resource_offset(), which
indicates that they support address translation.

Please also include a MAINTAINERS update for drivers/pci/host/pci-xilinx.c.

Bjorn
