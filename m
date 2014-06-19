Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaFSMqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:46:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45380 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaFSMql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:46:41 -0400
Message-ID: <53A2DB81.5070105@ti.com>
Date: Thu, 19 Jun 2014 18:15:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        Keerthy <j-keerthy@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v2 06/18] ARM: dts: DRA7: Add divider table to optfclk_pciephy_div
 clock
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-7-git-send-email-kishon@ti.com> <53A2C52C.6020606@ti.com>
In-Reply-To: <53A2C52C.6020606@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tero,

On Thursday 19 June 2014 04:40 PM, Tero Kristo wrote:
> On 05/29/2014 09:38 AM, Kishon Vijay Abraham I wrote:
>> From: Keerthy <j-keerthy@ti.com>
>>
>> Add divider table to optfclk_pciephy_div clock. The Documentation
>> for divider clock can be found at ../clock/ti/divider.txt
> 
> This patch requires a better changelog. Why is the change done, any TRM refs etc.?

The 8th bit of CM_CLKMODE_APLL_PCIE can be programmed to either 0x0 or 0x1
based on if the divider value is 0x2 or 0x1.

Figure 26-21. PCIe PHY Clock Generator Overview in vE of DRA7xx ES1.0 shows the
block diagram of Clock Generator Subsystem of PCIe PHY module. We have to do a
bypass (divided by 1) in order to get the correct PCIE_PHY_DIV_GCLK
frequency.

Thanks
Kishon
> 
> -Tero
> 
>>
>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Tero Kristo <t-kristo@ti.com>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7xx-clocks.dtsi |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> index c767687..55e95c5 100644
>> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> @@ -1170,6 +1170,7 @@
>>           clocks = <&apll_pcie_ck>;
>>           #clock-cells = <0>;
>>           reg = <0x021c>;
>> +        ti,dividers = <2>, <1>;
>>           ti,bit-shift = <8>;
>>           ti,max-div = <2>;
>>       };
>>
> 
