Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaGWI0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:26:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41075 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757367AbaGWI0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:26:15 -0400
Message-ID: <53CF718C.1060109@ti.com>
Date: Wed, 23 Jul 2014 13:55:48 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <jg1.han@samsung.com>,
        <mohit.kumar@st.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>
Subject: Re: [PATCH v3 0/4] dra7: Add PCIe support
References: <1405587643-13808-1-git-send-email-kishon@ti.com> <20140722213306.GB25432@google.com>
In-Reply-To: <20140722213306.GB25432@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 23 July 2014 03:03 AM, Bjorn Helgaas wrote:
> On Thu, Jul 17, 2014 at 02:30:39PM +0530, Kishon Vijay Abraham I wrote:
>> Changes from v2:
>> * Added myself as MAINTAINER of pcie dra7xx driver
>>
>> Changes from v1:
>> * fixed dw_pcie_prog_viewport_io_outbound() to use untranslated address
>> * split dra7xx patch into driver part and documentation part
>>
>> [1] is split into separate series in order for individual subsystem
>> Maintainers to pick up the patches. This series handles the PCIe
>> support for DRA7.
>>
>> Rebased to pci -next.
>>
>> [1] -> https://lkml.org/lkml/2014/5/29/258
>>
>> Kishon Vijay Abraham I (4):
>>   PCI: designware: Configuration space should be specified in 'reg'
>>   PCI: designware: use untranslated address while programming ATU
>>   Documentation: pci: ti: Add dt binding documentation for PCIe in
>>     DRA7xx
>>   PCI: host: pcie-dra7xx: add support for pcie-dra7xx controller
>>
>>  .../devicetree/bindings/pci/designware-pcie.txt    |    4 +
>>  Documentation/devicetree/bindings/pci/ti-pci.txt   |   59 +++
>>  MAINTAINERS                                        |    8 +
>>  drivers/pci/host/Kconfig                           |   10 +
>>  drivers/pci/host/Makefile                          |    1 +
>>  drivers/pci/host/pci-dra7xx.c                      |  458 ++++++++++++++++++++
>>  drivers/pci/host/pcie-designware.c                 |   72 ++-
>>  drivers/pci/host/pcie-designware.h                 |    4 +
>>  8 files changed, 600 insertions(+), 16 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
>>  create mode 100644 drivers/pci/host/pci-dra7xx.c
> 
> I applied these to pci/host-designware for v3.17.  This will not be in my
> first pull request because I'm going on vacation and won't have time to get
> everything through -next and tagged.  But I'm planning a second pull
> request that will include this.
> 
> Mohit, I applied your ack of "use untranslated address" from the v1 posting
> (your mail of Jul 09) to the corresponding patch here, since Kishon didn't
> carry it forward.  Let me know if that's not OK.
> 
> I also squashed the last two patches into one so the DT binding
> documentation goes along with the dra7xx driver addition.
> 

Thanks Bjorn.

-Kishon
> Bjorn
> 
