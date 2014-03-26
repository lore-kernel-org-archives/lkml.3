Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaCZPUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:20:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52077 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaCZPUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:20:49 -0400
Message-ID: <5332F01A.6090307@ti.com>
Date: Wed, 26 Mar 2014 20:49:54 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, <rnayak@ti.com>,
        "paul@pwsan.com" <paul@pwsan.com>
Subject: Re: [RFC PATCH 02/12] pci: host: pcie-dra7xx: add support for pcie-dra7xx
 controller
References: <1395842272-15267-1-git-send-email-kishon@ti.com>	<1395842272-15267-3-git-send-email-kishon@ti.com> <CAL_JsqKeQvbU24V2-3KQuFoLwkL31DEcEEVDenfTA0P++Hn_fQ@mail.gmail.com>
In-Reply-To: <CAL_JsqKeQvbU24V2-3KQuFoLwkL31DEcEEVDenfTA0P++Hn_fQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 26 March 2014 08:15 PM, Rob Herring wrote:
> On Wed, Mar 26, 2014 at 8:57 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Added support for pcie controller in dra7xx. This driver re-uses
>> the designware core code that is already present in kernel.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  Documentation/devicetree/bindings/pci/ti-pci.txt |   35 ++
>>  drivers/pci/host/Kconfig                         |   10 +
>>  drivers/pci/host/Makefile                        |    1 +
>>  drivers/pci/host/pcie-dra7xx.c                   |  411 ++++++++++++++++++++++
>>  4 files changed, 457 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
>>  create mode 100644 drivers/pci/host/pcie-dra7xx.c
>>
>> diff --git a/Documentation/devicetree/bindings/pci/ti-pci.txt b/Documentation/devicetree/bindings/pci/ti-pci.txt
>> new file mode 100644
>> index 0000000..0528c47
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/ti-pci.txt
>> @@ -0,0 +1,35 @@
>> +TI PCI Controllers
>> +
>> +PCIe Designware Controller
>> +This node should have the properties described in "designware-pcie.txt".
>> + - compatible: Should be "ti,dra7xx-pcie""
>> + - reg : Address and length of the register set for the device.
>> + - phys : the phandle for the PHY device (used by generic PHY framework)
>> + - phy-names : the names of the PHY corresponding to the PHYs present in the
>> +   *phy* phandle.
>> + - resets: phandle used if reset is handled be soc
> 
> s/be/by/ ?
> 
>> + - reset-names: name given to the phandle
>> + - ti,device-type: Should be 1 - EP TYPE, 2 - LEG EP TYPE OR 3 - RC TYPE
> 
> I don't think this makes sense. I'd imagine we'd need the binding to
> look quite a bit different if endpoint mode was actually supported. I

right, it makes sense to remove the ti,device-type altogether as this driver
only supports RC.
> think I would start defining endpoint mode with a different compatible
> string and go from there.
> 
>> +
>> +Example:
>> +pcie@51000000 {
>> +       compatible = "ti,dra7xx-pcie";
>> +       reg = <0x51002000 0x14c>, <0x51000000 0x2000>, <0x4A002540 0x1f>, <0x4A003c24 0x4>, <0x4AE07310 0x4>;
> 
> This is different number of entries from your actual dts. You need to
> define how many reg entries, what they are, and the order.

Ok. Will fix it.

Thanks
Kishon
