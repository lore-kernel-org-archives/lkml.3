Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaIEP71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:59:27 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42309 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaIEP7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:59:25 -0400
Message-ID: <5409DDCE.7080106@mm-sol.com>
Date: Fri, 05 Sep 2014 18:59:10 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        galak@codeaurora.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        iivanov@mm-sol.com
Subject: Re: [PATCH v3] ARM: dts: qcom: Add initial IFC6540 board device tree
References: <1409763031-16873-1-git-send-email-gdjakov@mm-sol.com> <5409C803.8060007@suse.de>
In-Reply-To: <5409C803.8060007@suse.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 09/05/2014 05:26 PM, Andreas Färber wrote:
<...>
>> +			reg-names = "hc_mem", "core_mem";
>> +			interrupts = <0 123 0>, <0 138 0>;
>
> I see that you've used GPIO_ACTIVE_* above. Is the trailing zero here
> possibly IRQ_TYPE_NONE?
>

Yes, it is. Will update it. Thanks!

>> +			interrupt-names = "hc_irq", "pwr_irq";
>> +			clocks = <&gcc GCC_SDCC1_APPS_CLK>, <&gcc GCC_SDCC1_AHB_CLK>;
>> +			clock-names = "core", "iface";
>> +			status = "disabled";
>> +		};
>> +
>> +		sdhci@f98a4900 {
>> +			compatible = "qcom,sdhci-msm-v4";
>> +			reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
>> +			reg-names = "hc_mem", "core_mem";
>> +			interrupts = <0 125 0>, <0 221 0>;
>> +			interrupt-names = "hc_irq", "pwr_irq";
>> +			clocks = <&gcc GCC_SDCC2_APPS_CLK>, <&gcc GCC_SDCC2_AHB_CLK>;
>> +			clock-names = "core", "iface";
>> +			status = "disabled";
>> +		};
>
> If you assign labels to these two nodes, you can reference them in the
> .dts as &labelname {...};. Same for the uart node. That avoids
> duplicating the hierarchy, detects spelling mistakes at compile time and
> reduces indentation. Cf. the recent ifc6410 patch.

Sure, adding a label will not hurt.

>
> Also, is sdhci the best node name here? Usually it's not supposed to
> reflect the exact interface used (e.g., usb vs. ehci).
>

Ok, I'll figure out something better.

>>   	};
>>   };
>
> Otherwise looks good.
>

Thanks for reviewing!

BR,
Georgi
