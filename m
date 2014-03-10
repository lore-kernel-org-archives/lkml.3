Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaCJLFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:05:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42993 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaCJLFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:05:44 -0400
Message-ID: <531D9C64.50809@ti.com>
Date: Mon, 10 Mar 2014 13:05:08 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/8] ARM: dts: dra7-clock: Add "l3init_960m_gfclk" clock
 gate
References: <1394197751-28984-1-git-send-email-rogerq@ti.com> <1394197751-28984-3-git-send-email-rogerq@ti.com> <5319D0B5.6060300@ti.com>
In-Reply-To: <5319D0B5.6060300@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 03:59 PM, Tero Kristo wrote:
> On 03/07/2014 03:09 PM, Roger Quadros wrote:
>> This clock gate description was missing in older Reference manuals.
>> It is present on the SoC to provide 960MHz reference clock to the
>> internal USB PHYs.
> 
> Can you provide a document reference here?
> 

Unfortunately it hasn't yet been included in the TRM.
I have the internal defect ID but I don't think it makes any sense here.

DRA7xx-TRMINC00203

cheers,
-roger

> 
>>
>> Use l3init_960m_gfclk as parent of usb_otg_ss1_refclk960m and
>> usb_otg_ss2_refclk960m.
>>
>> CC: Tero Kristo <t-kristo@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7xx-clocks.dtsi | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> index e96da9a..b8d3a9d 100644
>> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> @@ -1386,6 +1386,14 @@
>>           ti,dividers = <1>, <8>;
>>       };
>>
>> +    l3init_960m_gfclk: l3init_960m_gfclk {
>> +        #clock-cells = <0>;
>> +        compatible = "ti,gate-clock";
>> +        clocks = <&dpll_usb_clkdcoldo>;
>> +        ti,bit-shift = <8>;
>> +        reg = <0x06c0>;
>> +    };
>> +
>>       dss_32khz_clk: dss_32khz_clk {
>>           #clock-cells = <0>;
>>           compatible = "ti,gate-clock";
>> @@ -1533,7 +1541,7 @@
>>       usb_otg_ss1_refclk960m: usb_otg_ss1_refclk960m {
>>           #clock-cells = <0>;
>>           compatible = "ti,gate-clock";
>> -        clocks = <&dpll_usb_clkdcoldo>;
>> +        clocks = <&l3init_960m_gfclk>;
>>           ti,bit-shift = <8>;
>>           reg = <0x13f0>;
>>       };
>> @@ -1541,7 +1549,7 @@
>>       usb_otg_ss2_refclk960m: usb_otg_ss2_refclk960m {
>>           #clock-cells = <0>;
>>           compatible = "ti,gate-clock";
>> -        clocks = <&dpll_usb_clkdcoldo>;
>> +        clocks = <&l3init_960m_gfclk>;
>>           ti,bit-shift = <8>;
>>           reg = <0x1340>;
>>       };
>>
> 

