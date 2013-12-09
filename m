Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565Ab3LIRjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:39:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48273 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3LIRjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:39:46 -0500
Message-ID: <52A6005E.3060506@wwwdotorg.org>
Date: Mon, 09 Dec 2013 10:39:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] pinctrl: tegra: Add devicetree binding document
 for Tegra124
References: <1386585140-1137-1-git-send-email-ldewangan@nvidia.com> <20131209105155.GC29303@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131209105155.GC29303@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 03:51 AM, Mark Rutland wrote:
> On Mon, Dec 09, 2013 at 10:32:19AM +0000, Laxman Dewangan wrote:
>> This device tree binding document describes the Tegra124 pincontrol
>> DT bindings. This document lists all valid properties, names, mux
>> options of Tegra124 pins.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>> Changes from V1:
>> - Referred the dt-binding header file on describing the nodes.
>>
>>  .../bindings/pinctrl/nvidia,tegra124-pinmux.txt    |  147 ++++++++++++++++++++
>>  1 files changed, 147 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
>>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
>> new file mode 100644
>> index 0000000..12ef772
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
>> @@ -0,0 +1,147 @@
>> +NVIDIA Tegra124 pinmux controller
>> +
>> +The Tegra124 pinctrl binding is very similar to the Tegra20 and Tegra30
>> +pinctrl binding, as described in nvidia,tegra20-pinmux.txt and
>> +nvidia,tegra30-pinmux.txt. In fact, this document assumes that binding as
>> +a baseline, and only documents the differences between the two bindings.
>> +
>> +Required properties:
>> +- compatible: "nvidia,tegra124-pinmux"
>> +- reg: Should contain the register physical address and length for each of
>> +  the pad control and mux registers. The first bank of address must be the
>> +  driver strength pad control register address and second bank address must
>> +  be pinmux register address.
> 
> The wording here could be improved. The first sentence implies an entry
> for each individual register but I assume these are actually banks of
> registers (the sizes in the exanple imply this). The second sentence is
> more sepcific.
> 
> How about something like:
> 
> reg: Should contain a list of base address and size pairs for:
>  * first entry - the driver strength and pad control registers

If this patch gets revised, please s/driver/drive/ here.

>  * second entry - the pinmux registers
> 
> Are these banks well defined? Where do they end?

Yes, the SoC includes specific banks of registers for those two types of
configuration. The banks end at whatever address contains the last
define register of that type.

> Is there likely to be anything built as an extension of this? Does it
> possibly make sense to use reg-names?

Any new SoC would get a new binding, since all the other configuration
parameters (lists of valid pins, groups, functions) would be different,
so there's no need for future compatibility here.
