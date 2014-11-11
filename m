Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaKKFQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:16:56 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:57006 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaKKFQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:16:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141107115845.GA2062@red-moon>
References: <1415193331-14790-1-git-send-email-k.chander@samsung.com>
	<20141107115845.GA2062@red-moon>
Date: Tue, 11 Nov 2014 10:46:53 +0530
X-Google-Sender-Auth: AH-S0DZF22I-A20Md-Tir7HzN7s
Message-ID: <CADWw7Oh_A9PTHKLDNKHBwAvS5pNe34CqZusQ9WxKCZo_YjO=4A@mail.gmail.com>
Subject: Re: [PATCH v4] arm64: dts: exynos7: add support for cpuidle core
 power down
From: Chander Kashyap <k.chander@samsung.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Chander Kashyap <k.chander@samsung.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2014 at 5:28 PM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:
> On Wed, Nov 05, 2014 at 01:15:31PM +0000, Chander Kashyap wrote:
>> Exynos7 has core power down state where cores can be powered off independently.
>
> "...has a core power down idle state..."
>
>> This patch adds support for this state.
>
> "...for this idle state."
>
>> Entry latency for the core power down is calculated as follows:
>> 1. Time difference is measured between cpuidle entry and exit.
>> 2. WFI is skipped for measuring the time.
>> 3. Select the worst case time in the set of 100000 cpuidle transactions,
>>    with varying load.
>>
>> Exit latency and target residency are supplied as per HW team
>
> "Exit latency and min residency values are supplied by the HW team."
>
> Target residency is a kernel naming scheme, non-existent in the idle state
> bindings.
>
> Please take time to write proper commit logs, thanks.
>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> ---
>> This patch has following dependencies:
>>       - [PATCH v5 0/8] arch: arm64: Enable support for Samsung Exynos7 SoC
>>               http://www.spinics.net/lists/linux-samsung-soc/msg37047.html
>> Changes in v2:
>>       - Moved the cpu-idle-state property after reg property
>>       - removed the status property.
>>
>> Changes in v3:
>>       - Added the Entry latency calculation in commit message.
>> Changes in v4:
>>       - Corrected the commit message.
>>       - Corrected the entry latency value.
>>
>>  arch/arm64/boot/dts/exynos/exynos7.dtsi |   17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> index 50ae936..444dde1 100644
>> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> @@ -37,6 +37,7 @@
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>
> enable-method should be after reg, it is not an ordering issues added
> by this patch but I still do not like that.

This is being taken care in new patch for Exynos7 support.

>
> Other than that, please take some time to rewrite the commit log and
> ask to fix the ordering above, you can add my:
>

Yes i will change as suggested.

Thanks for the review.

> Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>
>>                       reg = <0x0>;
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>>               };
>>
>>               cpu@1 {
>> @@ -44,6 +45,7 @@
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>>                       reg = <0x1>;
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>>               };
>>
>>               cpu@2 {
>> @@ -51,6 +53,7 @@
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>>                       reg = <0x2>;
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>>               };
>>
>>               cpu@3 {
>> @@ -58,6 +61,20 @@
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>>                       reg = <0x3>;
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>> +             };
>> +
>> +             idle-states {
>> +                     entry-method = "arm,psci";
>> +
>> +                     CPU_SLEEP: cpu-sleep {
>> +                             compatible = "arm,idle-state";
>> +                             local-timer-stop;
>> +                             arm,psci-suspend-param = <0x0010000>;
>> +                             entry-latency-us = <34>;
>> +                             exit-latency-us = <150>;
>> +                             min-residency-us = <2100>;
>> +                     };
>>               };
>>       };
>>
>> --
>> 1.7.9.5
>>
>>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
