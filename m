Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbASNEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:04:46 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38928 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbASNEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:04:41 -0500
MIME-Version: 1.0
In-Reply-To: <2165161.8vJctS1yVa@wuerfel>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
	<1418812486-12394-3-git-send-email-gabriel.fernandez@linaro.org>
	<2165161.8vJctS1yVa@wuerfel>
Date: Mon, 19 Jan 2015 14:04:39 +0100
Message-ID: <CAG374jB5fcG2-2WnxkN5U-qOw=xP3A5tnTO04Gcqt3cSRhhKmw@mail.gmail.com>
Subject: Re: [PATCH 2/5] PCI: st: Add Device Tree bindings for sti pcie
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
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
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing

On 17 December 2014 at 23:01, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 17 December 2014 11:34:43 Gabriel FERNANDEZ wrote:
>> sti pcie is built around a Synopsis Designware PCIe IP.
>>
>> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  Documentation/devicetree/bindings/pci/st-pcie.txt | 53 +++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/st-pcie.txt
>>
>> diff --git a/Documentation/devicetree/bindings/pci/st-pcie.txt b/Documentation/devicetree/bindings/pci/st-pcie.txt
>> new file mode 100644
>> index 0000000..bd3488f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/st-pcie.txt
>> @@ -0,0 +1,53 @@
>> +STMicroelectronics STi PCIe controller
>> +
>> +This PCIe host controller is based on the Synopsis Designware PCIe IP
>> +and thus inherits all the common properties defined in designware-pcie.txt.
>> +
>> +Required properties:
>> + - compatible: "st,stih407-pcie"
>> + - reg: base address and length of the pcie controller, mem-window address
>> +   and length available to the controller.
>> + - interrupts: A list of interrupt outputs of the controller.
>> + - interrupt-names: Must include the following entries:
>> +   "msi": STi interrupt that is asserted when an MSI is received
>
> You should specify that only one interrupt may be present.
> If you extend the binding, you will need to describe what the
> second one is as well.
>

ok, i will change into:
"
 - interrupts: A list of interrupt outputs of the controller. Must contain an
  entry for each entry in the interrupt-names property.

>> + - st,syscfg : should be a phandle of the syscfg node. Also contains syscfg
>> +   offset for IP configuration.
>> + - resets, reset-names: the power-down and soft-reset lines of PCIe IP.
>> +   Associated names must be "powerdown" and "softreset".
>> + - phys, phy-names: the phandle for the PHY device.
>> +   Associated name must be "pcie_phy"
>
> Names should not have underscores in them in general. "pcie-phy" would
> be fine, but just "pcie" seems good enough, unless there are existing
> drivers that have established a specific naming.
>

just "pcie" is fine for me


BR

Gabriel

>
>         Arnd
>
