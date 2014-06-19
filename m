Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaFSNBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:01:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50538 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaFSNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:00:59 -0400
Message-ID: <53A2DEDA.5050104@ti.com>
Date: Thu, 19 Jun 2014 18:30:10 +0530
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
Subject: Re: [PATCH v2 07/18] ARM: dts: DRA7: Change the parent of apll_pcie_in_clk_mux
 to dpll_pcie_ref_m2ldo_ck
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-8-git-send-email-kishon@ti.com> <53A2C5B4.9080300@ti.com>
In-Reply-To: <53A2C5B4.9080300@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tero,

On Thursday 19 June 2014 04:42 PM, Tero Kristo wrote:
> On 05/29/2014 09:38 AM, Kishon Vijay Abraham I wrote:
>> From: Keerthy <j-keerthy@ti.com>
>>
>> Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
>> from dpll_pcie_ref_ck.
> 
> Why? Needs a better changelog also.

Figure 26-22. DPLL_PCIE_REF Functional Block Diagram in vE of DRA7xx ES1.0 TRM
shows the signal name for the output of post divider (M2) is CLKOUTLDO.

Figure 26-21. PCIe PHY Clock Generator Overview shows CLKOUTLDO is used as
input to apll mux.

So the actual output of dpll should be dpll_pcie_ref_m2ldo_ck instead of
dpll_pcie_ref_ck (which is the input of apll mux).

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
>>   arch/arm/boot/dts/dra7xx-clocks.dtsi |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> index 55e95c5..44993ec 100644
>> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> @@ -1152,7 +1152,7 @@
>>
>>       apll_pcie_in_clk_mux: apll_pcie_in_clk_mux@4ae06118 {
>>           compatible = "ti,mux-clock";
>> -        clocks = <&dpll_pcie_ref_ck>, <&pciesref_acs_clk_ck>;
>> +        clocks = <&dpll_pcie_ref_m2ldo_ck>, <&pciesref_acs_clk_ck>;
>>           #clock-cells = <0>;
>>           reg = <0x021c 0x4>;
>>           ti,bit-shift = <7>;
>>
> 
