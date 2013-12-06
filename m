Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3LFL7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:59:14 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54718 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab3LFL7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:59:11 -0500
Message-ID: <52A1BC32.6060600@mm-sol.com>
Date: Fri, 06 Dec 2013 13:59:46 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>
Subject: Re: [PATCH v7 1/2] mmc: sdhci-msm: Initial SDHCI MSM driver documentation
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com> <1383753405-23631-2-git-send-email-gdjakov@mm-sol.com> <20131205095218.GH29200@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131205095218.GH29200@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 11:52 AM, Mark Rutland wrote:
> Hi,
>
> Apologies for the late reply.

Hi Mark, thanks for the review!

>
> On Wed, Nov 06, 2013 at 03:56:44PM +0000, Georgi Djakov wrote:
>> This patch adds documentation for Qualcomm SDHCI MSM driver.
>> It contains the differences between the core properties in mmc.txt
>> and the properties used by the sdhci-msm driver.
>
> Nit, but this is documentation of the binding, not the driver.
>

Ok, sure!

>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>>   .../devicetree/bindings/mmc/sdhci-msm.txt          |   92 ++++++++++++++++++++
>>   1 file changed, 92 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
>> new file mode 100644
>> index 0000000..8f1a52d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
>> @@ -0,0 +1,92 @@
>> +* Qualcomm SDHCI controller (sdhci-msm)
>> +
>> +This file documents differences between the core properties in mmc.txt
>> +and the properties used by the sdhci-msm driver.
>> +
>> +Required properties:
>> +- compatible: should contain "qcom,sdhci-msm"
>> +- reg: should contain SDHC, SD Core register map
>
> As this seems to depend on reg-names, it would be nice to write this in
> terms of reg-names (as with clocks and clock-names).
>
>

Ok, thanks!

>> +- reg-names: indicates various resources passed to driver (via reg proptery) by name
>> +	"reg-names" examples are "hc_mem" and "core_mem"
>
> Either there are a fixed set of names you expect (and therefore these
> aren't examples but rather a definition), or this property is useless.
> Please either define the set of names or remove this property.
>
>> +- interrupts: should contain SDHC interrupts
>> +- interrupt-names: indicates interrupts passed to driver (via interrupts property) by name
>> +	"interrupt-names" examples are "hc_irq" and "pwr_irq"
>
> Likewise for both points.
>

Ok!

>> +- vdd-supply: phandle to the regulator for the vdd (flash core voltage) supply.
>> +- vddio-supply: phandle to the regulator for the vdd-io (i/o voltage) supply.
>> +- pinctrl-names: Should contain only one value - "default".
>> +- pinctrl-0: Should specify pin control groups used for this controller.
>> +- clocks: A list of phandle + clock-specifier pairs for the clocks listed in clock-names
>> +- clock-names: Should contain the following:
>> +	"iface" - Main peripheral bus clock (PCLK/HCLK - AHB Bus clock) (required)
>> +	"core"	- SDC MMC clock (MCLK) (required)
>> +	"bus"	- SDCC bus voter clock (optional)
>
> This looks good :)
>
>> +
>> +Optional properties:
>> +- qcom,bus-speed-mode: specifies the supported bus speed modes by host
>> +	The supported bus speed modes are:
>> +	"HS200_1p8v" - indicates that host can support HS200 at 1.8v
>> +	"HS200_1p2v" - indicates that host can support HS200 at 1.2v
>> +	"DDR_1p8v" - indicates that host can support DDR mode at 1.8v
>> +	"DDR_1p2v" - indicates that host can support DDR mode at 1.2v
>
> Is this a list of strings, or does the unit only support one of these?
>
> This could be a set of boolean properties instead, is this likely to
> expand in future?
>

It is meant to be list of strings, and many can be supported. But i will 
drop this property from this initial version, and maybe add it later as 
boolean properties! Thanks!

>> +
>> +- qcom,{vdd,vdd-io}-lpm-sup - specifies whether the supply can be kept in low power mode.
>
> Boolean? Please specify types on properties.

Yes, it is boolean. I'll note it in the documentation. Thanks!

>
> Can you elaborate on what this means? When can a supply not be kept in
> low power mode?

The vdd-io for example is a regulator that is always-on and may be 
shared with multiple other peripherals as well. It should not be 
disabled by the driver, but instead put in low power mode when unused.

>
>> +- qcom,{vdd,vdd-io}-voltage-level - specifies voltage levels for the supply.
>> +	Should be specified in pairs (min, max), units uV.
>> +- qcom,{vdd,vdd-io}-current-level - specifies load levels for the supply in lpm
>> +	or high power mode (hpm). Should be specified in pairs (lpm, hpm), units uA.
>
> Can you not query these from the regulator framework?
>
> If these are configuration, why are they necessary?
>

As some regulators are shared and can have multiple consumers, these 
properties can be used for voltage and load current aggregation.
The voltage-level is the "supported voltage" by the controller, that 
also (at least on my platform) matches the corresponding regulator 
voltage. I probably can drop the voltage-level property and get voltage 
via the regulator framework helper functions, but the load current 
values are different for each sdhc.
 From the very limited documentation that i have, i think this is 
describing the hardware configuration and should be in the device-tree.

Thanks,
Georgi
