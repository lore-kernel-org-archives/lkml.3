Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaA3RL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:11:28 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:52359 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbaA3RLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:11:25 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2014 12:11:25 EST
Message-ID: <52EA86CD.3080609@mm-sol.com>
Date: Thu, 30 Jan 2014 19:07:25 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
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
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com> <1383753405-23631-2-git-send-email-gdjakov@mm-sol.com> <20131205095218.GH29200@e106331-lin.cambridge.arm.com> <52A1BC32.6060600@mm-sol.com> <20131209093843.GB28379@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131209093843.GB28379@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies for the delayed reply.

On 12/09/2013 11:38 AM, Mark Rutland wrote:
> On Fri, Dec 06, 2013 at 11:59:46AM +0000, Georgi Djakov wrote:
>> On 12/05/2013 11:52 AM, Mark Rutland wrote:
[...]
>
>>>> +
>>>> +- qcom,{vdd,vdd-io}-lpm-sup - specifies whether the supply can be kept in low power mode.
>>>
>>> Boolean? Please specify types on properties.
>>
>> Yes, it is boolean. I'll note it in the documentation. Thanks!
>>
>>>
>>> Can you elaborate on what this means? When can a supply not be kept in
>>> low power mode?
>>
>> The vdd-io for example is a regulator that is always-on and may be
>> shared with multiple other peripherals as well. It should not be
>> disabled by the driver, but instead put in low power mode when unused.
>
> The fact that the regulator is driving other peripherals doesn't seem
> like a property of the SDHCI to me. What are these other peripherals?
>

Agree! I'll drop this property.

> When you say should not be disabled by the driver, do you mean that
> another peripheral's driver shouldn't be able to disable the regulator
> feeding the SDHCI, or the SDHCI driver shouldn't be able to disable a
> regulator in use by another peripheral?
>

The regulator will not be disabled in any case as it will be marked as 
always-on.

> When in low power mode, is the SDHCI functional?
>
>>>
>>>> +- qcom,{vdd,vdd-io}-voltage-level - specifies voltage levels for the supply.
>>>> +	Should be specified in pairs (min, max), units uV.
>>>> +- qcom,{vdd,vdd-io}-current-level - specifies load levels for the supply in lpm
>>>> +	or high power mode (hpm). Should be specified in pairs (lpm, hpm), units uA.
>>>
>>> Can you not query these from the regulator framework?
>>>
>>> If these are configuration, why are they necessary?
>>>
>>
>> As some regulators are shared and can have multiple consumers, these
>> properties can be used for voltage and load current aggregation.
>> The voltage-level is the "supported voltage" by the controller, that
>> also (at least on my platform) matches the corresponding regulator
>> voltage. I probably can drop the voltage-level property and get voltage
>> via the regulator framework helper functions, but the load current
>> values are different for each sdhc.
>>   From the very limited documentation that i have, i think this is
>> describing the hardware configuration and should be in the device-tree.
>
> If these are the voltages / currents supported by the SDHCI, then that
> seems like it makes sense to have in DT, if they're likely to be
> variable in practice. How variable do you expect these to be?
>

The voltages vary depending on the function. For example the vdd-io for 
eMMC is 1.2 - 1.8v, for SD cards 1.8 - 2.95v and for SDIO 1.8v.
So, one way is using -min/-max suffixes and the other can be introducing 
a for ex. "function" property (emmc/card/sdio) and moving the voltage 
range definitions into the driver.

> Also, I'd recommend splitting them in to separate -min and -max
> properties, it makes it far clearer what they're actually for.
>

Thanks,
Georgi
