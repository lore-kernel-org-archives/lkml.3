Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaIEQAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:00:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaIEQAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:00:37 -0400
Message-ID: <5409DE22.3070506@suse.de>
Date: Fri, 05 Sep 2014 18:00:34 +0200
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Georgi Djakov <gdjakov@mm-sol.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, iivanov@mm-sol.com
Subject: Re: [PATCH v3] ARM: dts: qcom: Add initial IFC6540 board device tree
References: <1409763031-16873-1-git-send-email-gdjakov@mm-sol.com> <5409C803.8060007@suse.de> <070D3E01-139E-4EC2-928F-31B8CA5E1BD7@codeaurora.org>
In-Reply-To: <070D3E01-139E-4EC2-928F-31B8CA5E1BD7@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.09.2014 17:20, schrieb Kumar Gala:
> On Sep 5, 2014, at 9:26 AM, Andreas Färber <afaerber@suse.de> wrote:
>> Am 03.09.2014 18:50, schrieb Georgi Djakov:
>>> diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
>>> index 21d01e5..1f130bc 100644
>>> --- a/arch/arm/boot/dts/qcom-apq8084.dtsi
>>> +++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
>>> @@ -3,6 +3,7 @@
>>> #include "skeleton.dtsi"
>>>
>>> #include <dt-bindings/clock/qcom,gcc-apq8084.h>
>>> +#include <dt-bindings/gpio/gpio.h>
>>>
>>> / {
>>> 	model = "Qualcomm APQ 8084";
>>> @@ -203,5 +204,27 @@
>>> 			clock-names = "core", "iface";
>>> 			status = "disabled";
>>> 		};
>>> +
>>> +		sdhci@f9824900 {
>>> +			compatible = "qcom,sdhci-msm-v4";
>>> +			reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
>>> +			reg-names = "hc_mem", "core_mem";
>>> +			interrupts = <0 123 0>, <0 138 0>;
>>
>> I see that you've used GPIO_ACTIVE_* above. Is the trailing zero here
>> possibly IRQ_TYPE_NONE?
>>
>>> +			interrupt-names = "hc_irq", "pwr_irq";
>>> +			clocks = <&gcc GCC_SDCC1_APPS_CLK>, <&gcc GCC_SDCC1_AHB_CLK>;
>>> +			clock-names = "core", "iface";
>>> +			status = "disabled";
>>> +		};
>>> +
>>> +		sdhci@f98a4900 {
>>> +			compatible = "qcom,sdhci-msm-v4";
>>> +			reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
>>> +			reg-names = "hc_mem", "core_mem";
>>> +			interrupts = <0 125 0>, <0 221 0>;
>>> +			interrupt-names = "hc_irq", "pwr_irq";
>>> +			clocks = <&gcc GCC_SDCC2_APPS_CLK>, <&gcc GCC_SDCC2_AHB_CLK>;
>>> +			clock-names = "core", "iface";
>>> +			status = "disabled";
>>> +		};
>>
>> If you assign labels to these two nodes, you can reference them in the
>> .dts as &labelname {...};. Same for the uart node. That avoids
>> duplicating the hierarchy, detects spelling mistakes at compile time and
>> reduces indentation. Cf. the recent ifc6410 patch.
> 
> Got no issues with introducing the labels, but I’d like to keep the hierarchy in the .dts file.

Any explanation why? The Samsung guys have been very strict to adopt
this new style, with inherited nodes sorted alphabetically after / {};,
and the ifc6540 is a new .dts we could apply the new pattern to.

But if you don't reference the node anywhere, there's no real benefit to
adding a label in the first place. It can still be done once needed.

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
