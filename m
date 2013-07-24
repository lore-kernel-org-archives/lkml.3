Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab3GXG3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:29:06 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36268 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3GXG3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:29:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHz10ao32Y4VRsvjNLe+zaq+hYk4KVgtwFgSLDsN-9Pfpw@mail.gmail.com>
References: <1374600763-19466-1-git-send-email-tobetter@gmail.com>
	<CAK9yfHz10ao32Y4VRsvjNLe+zaq+hYk4KVgtwFgSLDsN-9Pfpw@mail.gmail.com>
Date: Wed, 24 Jul 2013 15:29:03 +0900
Message-ID: <CADoNuNdqF0Y=3pdBCE26AQgkv6uqZQ4uE+BfPSSNxAvuuR+kvg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add USB host node for Exynos4
From: Dongjin Kim <tobetter@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jg1.han@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Jingoo Han

Sorry, its my bad. Typo problem.

I found another patch same with mine,
https://patchwork.kernel.org/patch/2628451, submitted by Jingoo Han
and tested on Exynos4210. Mine is tested on Exynos4412. Both SoC have
same USB host address space, so I think USB host device nodes can be
placed in exynos4.dtsi.

Regards,
Dongjin.

On Wed, Jul 24, 2013 at 12:38 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 23 July 2013 23:02, Dongjin Kim <tobetter@gmail.com> wrote:
>> This patch adds EHCI and OHCI host device nodes for Exynos4.
>>
>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>> ---
>>  arch/arm/boot/dts/exynos4.dtsi |   20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
>> index 3f94fe8..1cdbf89 100644
>> --- a/arch/arm/boot/dts/exynos4.dtsi
>> +++ b/arch/arm/boot/dts/exynos4.dtsi
>> @@ -155,6 +155,26 @@
>>                 status = "disabled";
>>         };
>>
>> +       ehci@12580000 {
>> +               compatible = "samsung,exynos4210-ehci";
>> +               reg = <0x12580000 0x100>;
>> +               interrupts = <0 70 0>;
>> +               status = "disabled";
>> +
>> +               clocks = <&clock 304>;
>> +               clock-names = "usbhost";
>> +       };
>> +
>> +       ohci@12590000 {
>> +               compatible = "samsung,exynos4210-ohci";
>> +               reg = <0x12580000 0x100>;
>
> Register value and node name do not match. Typo?
>
>
>> +               interrupts = <0 70 0>;
>> +               status = "disabled";
>> +
>> +               clocks = <&clock 304>;
>> +               clock-names = "usbhost";
>> +       };
>> +
>>         mfc: codec@13400000 {
>>                 compatible = "samsung,mfc-v5";
>>                 reg = <0x13400000 0x10000>;
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> With warm regards,
> Sachin
