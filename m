Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaKXKrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:47:21 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:43971 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaKXKrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:47:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141124103249.GA26217@ulmo.nvidia.com>
References: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>
	<20141124103249.GA26217@ulmo.nvidia.com>
Date: Mon, 24 Nov 2014 16:17:18 +0530
Message-ID: <CAFp+6iE22FnHeXJZQyhytzGDNfnP4sdnYZuyFtmfzP_JVTVNPQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, Kukjin Kim <kgene@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, Nov 24, 2014 at 4:02 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Nov 24, 2014 at 11:11:23AM +0530, Vivek Gautam wrote:
>> DP PHY now require pmu-system-controller to handle PMU register
>> to control PHY's power isolation. Adding the same to dp-phy
>> node.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
>> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Cc: Kukjin Kim <kgene@kernel.org>
>> ---
>>  arch/arm/boot/dts/exynos5250.dtsi |    2 +-
>>  arch/arm/boot/dts/exynos5420.dtsi |    4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
>> index 0a588b4..bebd099 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -732,7 +732,7 @@
>>
>>       dp_phy: video-phy@10040720 {
>>               compatible = "samsung,exynos5250-dp-video-phy";
>> -             reg = <0x10040720 4>;
>> +             samsung,pmu-syscon = <&pmu_system_controller>;
>>               #phy-cells = <0>;
>>       };
>>
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
>> index 8617a03..1353a09 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -503,8 +503,8 @@
>>       };
>>
>>       dp_phy: video-phy@10040728 {
>> -             compatible = "samsung,exynos5250-dp-video-phy";
>> -             reg = <0x10040728 4>;
>> +             compatible = "samsung,exynos5420-dp-video-phy";
>> +             samsung,pmu-syscon = <&pmu_system_controller>;
>>               #phy-cells = <0>;
>>       };
>>
>
> It seems like these nodes have been in the Linux tree since 3.12 and
> 3.17, respectively and these changes break backwards-compatibility. Has
> anyone thought about the possible consequences?

Sorry for my ignorance, but i have a doubt.
If the bindings and device node both are being changed in the same kernel
version (as fixes),
so that the stable will have both; then the only scenerio of backward
compatibility comes when kernel is upgraded but not dtbs.
Does such upgradation makes sense for distros ?

>
> Although, looking more closely it seems like this isn't the first time
> that backwards-compatibility was broken in these files, so perhaps
> nobody cares...
>
> Thierry



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
