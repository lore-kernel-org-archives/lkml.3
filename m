Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaEPUli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:41:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53541 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEPUlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:41:36 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>
Subject: RE: [PATCH v1 0/5] Add Keystone PCIe controller driver
Thread-Topic: [PATCH v1 0/5] Add Keystone PCIe controller driver
Thread-Index: Ac9wVwStLuxIQSTKQyy3QmeKF3q0xAASBxegACn7WPA=
Date: Fri, 16 May 2014 20:40:51 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B704742160@DFLE11.ent.ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <004f01cf70a0$90d7e520$b287af60$%han@samsung.com>
In-Reply-To: <004f01cf70a0$90d7e520$b287af60$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jingoo Han [mailto:jg1.han@samsung.com]
>Sent: Thursday, May 15, 2014 8:49 PM
>To: Karicheri, Muralidharan
>Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; Shilimkar, Santosh; 'Russell King'; 'Grant Likely'; 'Rob Herring';
>'Mohit Kumar'; 'Bjorn Helgaas'; 'Jingoo Han'; 'Pratyush Anand'; 'Richard Zhu'; ABRAHAM,
>KISHON VIJAY; 'Marek Vasut'
>Subject: Re: [PATCH v1 0/5] Add Keystone PCIe controller driver
>
>On Friday, May 16, 2014 1:01 AM, Murali Karicheri wrote:
>>
>> This patch adds a PCIe controller driver for Keystone SoCs. This is
>> based on the origin RFC patch that I had sent earlier. I have
>> incorporated following comments:-
>>
>>  - Add a interrupt controller node for Legacy irq chip and use
>>    interrupt map/map-mask property to map legacy IRQs A/B/C/D
>>  - Add a Phy driver to replace the original serdes driver
>>  - Move common applicaiton register handling code to a separate
>>    file to allow re-use across other platforms that use older
>>    DW PCIe h/w
>>  - PCI quirk for maximum read request size. Check and override only
>>    if the maximum is higher than what controller can handle.
>>  - Converted to a module platform driver.
>>
>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: Grant Likely <grant.likely@linaro.org>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: Mohit Kumar <mohit.kumar@st.com>
>> CC: Jingoo Han <jg1.han@samsung.com>
>> CC: Bjorn Helgaas <bhelgaas@google.com>
>>
>
>Your patches modify 'pcie-designware.c', and affects other PCIe drivers using designware
>PCIe Core IP. Please add the following people to CC list. They are also related to the
>designware PCIe.
>
>  Pratyush Anand <pratyush.anand@st.com>
>  Richard Zhu <r65037@freescale.com>
>  Kishon Vijay Abraham I <kishon@ti.com>
>  Marek Vasut <marex@denx.de>
>
Will forward the patches to the above list as well.

Thanks

Murali
>Best regards,
>Jingoo Han
>
>>
>> Murali Karicheri (5):
>>   ARM: keystone: add pcie related options
>>   pci: designware: enhancements to support keystone pcie
>>   phy: pci serdes phy driver for keystone
>>   pci: dw: add common functions to support old hw based pci driver
>>   pci: keystone: add pcie driver based on designware core driver
>>
>>  .../devicetree/bindings/pci/pcie-keystone.txt      |   68 ++++
>>  arch/arm/mach-keystone/Kconfig                     |    2 +
>>  drivers/pci/host/Kconfig                           |   12 +
>>  drivers/pci/host/Makefile                          |    2 +
>>  drivers/pci/host/pci-dw-old-msi.c                  |  150 ++++++++
>>  drivers/pci/host/pci-dw-old.c                      |  371 ++++++++++++++++++
>>  drivers/pci/host/pci-dw-old.h                      |   30 ++
>>  drivers/pci/host/pci-keystone.c                    |  400 ++++++++++++++++++++
>>  drivers/pci/host/pcie-designware.c                 |  101 +++--
>>  drivers/pci/host/pcie-designware.h                 |   42 +-
>>  drivers/pci/quirks.c                               |   13 +
>>  drivers/phy/Kconfig                                |    6 +
>>  drivers/phy/Makefile                               |    1 +
>>  drivers/phy/phy-keystone.c                         |  230 +++++++++++
>>  14 files changed, 1388 insertions(+), 40 deletions(-)  create mode
>> 100644 Documentation/devicetree/bindings/pci/pcie-keystone.txt
>>  create mode 100644 drivers/pci/host/pci-dw-old-msi.c  create mode
>> 100644 drivers/pci/host/pci-dw-old.c  create mode 100644
>> drivers/pci/host/pci-dw-old.h  create mode 100644
>> drivers/pci/host/pci-keystone.c  create mode 100644
>> drivers/phy/phy-keystone.c
>>
>> --
>> 1.7.9.5

