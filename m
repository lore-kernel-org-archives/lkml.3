Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbaFTPdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:33:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57166 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198AbaFTPdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:33:09 -0400
Message-ID: <53A453D1.4040308@ti.com>
Date: Fri, 20 Jun 2014 11:31:29 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com> <CAErSpo6=vi0SR0A3u5BCLgiGxoH48N5R=e8VAnFDG=K61qLxnw@mail.gmail.com>
In-Reply-To: <CAErSpo6=vi0SR0A3u5BCLgiGxoH48N5R=e8VAnFDG=K61qLxnw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/2014 8:08 PM, Bjorn Helgaas wrote:
> On Tue, Jun 10, 2014 at 02:51:19PM -0400, Murali Karicheri wrote:
>> This patch adds a PCIe controller driver for Keystone SoCs. This
>> is based on v1 of the series posted to the mailing list.
>>
>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: Grant Likely <grant.likely@linaro.org>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: Mohit Kumar <mohit.kumar@st.com>
>> CC: Jingoo Han <jg1.han@samsung.com>
>> CC: Bjorn Helgaas <bhelgaas@google.com>
>> CC: Pratyush Anand <pratyush.anand@st.com>
>> CC: Richard Zhu <r65037@freescale.com>
>> CC: Kishon Vijay Abraham I <kishon@ti.com>
>> CC: Marek Vasut <marex@denx.de>
>> CC: Arnd Bergmann <arnd@arndb.de>
>> CC: Pawel Moll <pawel.moll@arm.com>
>> CC: Mark Rutland <mark.rutland@arm.com>
>> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> CC: Kumar Gala <galak@codeaurora.org>
>> CC: Randy Dunlap <rdunlap@infradead.org>
>> CC: Grant Likely <grant.likely@linaro.org>
>>
>>
>> Changelog:
>>
>> V2
>>   - Split the designware pcie enhancement patch to multiple
>>     patches based on functionality added
>>   - Remove the quirk code and add a patch to fix mps/mrss
>>     tuning for ARM. Use kernel command line parameter
>>     pci=pcie_bus_perf to work with Keystone PCI Controller.
>>     Following patch addressed this.
>>       [PATCH v1] ARM: pci: add call to pcie_bus_configure_settings()
>>   - Add documentation for device tree bindings
>>   - Add separate interrupt controller nodes for MSI and Legacy
>>     IRQs and use irq map for legacy IRQ
>>   - Use compatibility to identify v3.65 version of the DW hardware
>>     and use it to customize the designware common code.
>>   - Use reg property for configuration space instead of range
>>   - Other minor updates based on code inspection.
>>
>> V1
>>   - Add an interrupt controller node for Legacy irq chip and use
>>     interrupt map/map-mask property to map legacy IRQs A/B/C/D
>>   - Add a Phy driver to replace the original serdes driver
>>   - Move common application register handling code to a separate
>>     file to allow re-use across other platforms that use older
>>     DW PCIe h/w
>>   - PCI quirk for maximum read request size. Check and override only
>>     if the maximum is higher than what controller can handle.
>>   - Converted to a module platform driver.
>>
>>
>> Murali Karicheri (8):
>>    PCI: designware: add rd[wr]_other_conf API
>>    PCI: designware: refactor host init code to re-use on v3.65 DW pci hw
>>    PCI: designware: update pcie core driver to work with dw hw version
>>      3.65
>>    PCI: designware: add msi controller functions for v3.65 hw
>>    PCI: designware: add PCI controller functions for v3.65 DW hw
>>    phy: Add serdes phy driver for keystone
>>    PCI: keystone: add pcie driver based on designware core driver
>>    ARM: keystone: add pcie related options
>>
>>   .../devicetree/bindings/pci/designware-pcie.txt    |   42 ++
>>   .../devicetree/bindings/pci/pci-keystone.txt       |   56 +++
>>   .../bindings/phy/phy-keystone-serdes.txt           |   25 ++
>>   arch/arm/mach-keystone/Kconfig                     |    1 +
>>   drivers/pci/host/Kconfig                           |   12 +
>>   drivers/pci/host/Makefile                          |    2 +
>>   drivers/pci/host/pci-dw-v3_65-msi.c                |  149 +++++++
>>   drivers/pci/host/pci-dw-v3_65.c                    |  390 ++++++++++++++++++
>>   drivers/pci/host/pci-dw-v3_65.h                    |   34 ++
>>   drivers/pci/host/pci-keystone.c                    |  418 ++++++++++++++++++++
>>   drivers/pci/host/pcie-designware.c                 |  175 +++++---
>>   drivers/pci/host/pcie-designware.h                 |   42 +-
>>   drivers/phy/Kconfig                                |    6 +
>>   drivers/phy/Makefile                               |    1 +
>>   drivers/phy/phy-keystone-serdes.c                  |  230 +++++++++++
>>   15 files changed, 1531 insertions(+), 52 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
>>   create mode 100644 Documentation/devicetree/bindings/phy/phy-keystone-serdes.txt
>>   create mode 100644 drivers/pci/host/pci-dw-v3_65-msi.c
>>   create mode 100644 drivers/pci/host/pci-dw-v3_65.c
>>   create mode 100644 drivers/pci/host/pci-dw-v3_65.h
>>   create mode 100644 drivers/pci/host/pci-keystone.c
>>   create mode 100644 drivers/phy/phy-keystone-serdes.c
> I'm not willing to merge phy-keystone-serdes.c because I don't
> maintain drivers/phy and because of the binary blob of register values
> it contains, but maybe somebody else will.  I assume it could be
> merged by itself before the rest of this.
>
> I'm looking for acks from Mohit and/or Jingoo for the pci/host
> changes, and from Arnd for the devicetree/bindings changes.
>
> Adding these "-dw-3_64" files is sort of ugly.  If that code is only
> used by keystone, maybe it could just be moved to pci-keystone.c?  But
> I'll defer to Mohit and Jingoo on that and the way you modify
> pcie-designware.c.
>
> Bjorn
Bjorn, Jingoo,

Unfortunately I lost Jingoo's email from my Inbox. So I cut-n-paste the 
comment from
internet and respond.

Jingoo Han wrote:-
=============================================================================
I think so, too.

DT maintainers and arch maintainers should review the following
dt bindings.
   .../devicetree/bindings/pci/designware-pcie.txt    |   42 ++
   .../devicetree/bindings/pci/pci-keystone.txt       |   56 +++
Generic PHY maintainer (Kishon Vijay Abraham I) should review the
following phy driver.
   drivers/phy/phy-keystone-serdes.c

 >
 > I'm looking for acks from Mohit and/or Jingoo for the pci/host
 > changes, and from Arnd for the devicetree/bindings changes.
 >
 > Adding these "-dw-3_64" files is sort of ugly.  If that code is only
 > used by keystone, maybe it could just be moved to pci-keystone.c?  But
 > I'll defer to Mohit and Jingoo on that and the way you modify
 > pcie-designware.c.

I agree with Bjorn Helgaas's opinion. These three "-dw-3_64" files
look terrible! I don't have a good way to handle this; however,
moving this code to pci-keystone.c looks better.
======================================================================

The original RFC I had submitted had all of the application space register
handling code as part of the Keystone PCI driver. As per Arnd's comment 
(See
my change log against v1), the code was moved to a separate file so that
the next driver that has same version of the DW hw could re-use this code.
I agree with Arnd and moved the code to v_3_65 specific files.  What is
your proposal?  Do you have objection to the file name? or it's content?

If objection is on the file name,  please suggest alternate names. If you
are okay with the file name, and doesn't like the code, it will be helpful
to review the code and provide specific comments against the patch itself
so that I can address the same.

Murali
