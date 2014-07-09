Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaGINxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:53:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51158 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaGINxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:53:50 -0400
Message-ID: <53BD4918.2040807@ti.com>
Date: Wed, 9 Jul 2014 09:52:24 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>, <devicetree@vger.kernel.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH v3 0/5] Add Keystone PCIe controller driver
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2014 05:45 PM, Murali Karicheri wrote:
> This patch add PCIe controller driver for Keystone SoCs. This
> is based on v2 of the series posted to the mailing list.
> Keystone PCI controller is based on version 3.65 of the DW
> hardware. This driver re-uses some of the DW core driver
> functions and required modification in some to support
> the old DW h/w based Keystone driver.
> 
> Please review and let me know if you have any comments.
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
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
> 
> Changelog:
> 
> v3
>  - DW application register handling code is now part of
>    Keystone PCI driver. RFC had this code part of Keystone
>    PCI driver, then V1 moved this to a separate file to
>    re-use on other platforms that uses this version of the
>    DW h/w. Then based on comments against v2, this is moved
>    back to Keystone driver.
>  - Keystone SerDes phy driver is removed from this series so that
>    this can be merged independent of that patch
>  - added msi_set_irq()/clear_irq() API's to support Keystone
> 
> V2
>  - Split the designware pcie enhancement patch to multiple
>    patches based on functionality added
>  - Remove the quirk code and add a patch to fix mps/mrss
>    tuning for ARM. Use kernel command line parameter
>    pci=pcie_bus_perf to work with Keystone PCI Controller.
>    Following patch addressed this.
>      [PATCH v1] ARM: pci: add call to pcie_bus_configure_settings()
>  - Add documentation for device tree bindings
>  - Add separate interrupt controller nodes for MSI and Legacy
>    IRQs and use irq map for legacy IRQ
>  - Use compatibility to identify v3.65 version of the DW hardware
>    and use it to customize the designware common code.
>  - Use reg property for configuration space instead of range
>  - Other minor updates based on code inspection. 
> 
> V1
>  - Add an interrupt controller node for Legacy irq chip and use
>    interrupt map/map-mask property to map legacy IRQs A/B/C/D
>  - Add a Phy driver to replace the original serdes driver
>  - Move common application register handling code to a separate
>    file to allow re-use across other platforms that use older
>    DW PCIe h/w
>  - PCI quirk for maximum read request size. Check and override only
>    if the maximum is higher than what controller can handle.
>  - Converted to a module platform driver.
> 
> Murali Karicheri (5):
>   PCI: designware: add rd[wr]_other_conf API
>   PCI: designware: refactor MSI code to work with v3.65 dw hardware
>   PCI: designware: refactor host init code to re-use on keystone PCI
>   PCI: designware: enhance dw core driver to support Keystone PCI host
>     controller
>   PCI: add PCI controller for Keystone PCIe h/w
> 
I haven't given review remarks on public list but had few internal
review discussions with you. So just in case you need some
additional review/ack tags, feel free to include mine.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Once the driver changes gets merged by Bjorn, I can they
merge the DTS related changes via my tree.

Thanks for all the work Murali !!

Regards,
Santosh
