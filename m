Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3GXF7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 01:59:25 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47405 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3GXF7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 01:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHw98L-FUtX7v32FyE4UN308uYpJXx8oxDuYgYZk1uUp_A@mail.gmail.com>
References: <1374600682-19376-1-git-send-email-tobetter@gmail.com>
	<CAK9yfHw98L-FUtX7v32FyE4UN308uYpJXx8oxDuYgYZk1uUp_A@mail.gmail.com>
Date: Wed, 24 Jul 2013 14:59:21 +0900
Message-ID: <CADoNuNe1t8KENvdwZXzg8tZAVNuqobV7gXAaVVuSVZX8LEc2xg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add USBPHY nodes to Exynos4x12
From: Dongjin Kim <tobetter@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Sachin,

On Wed, Jul 24, 2013 at 2:12 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Dongjin,
>
> On 23 July 2013 23:01, Dongjin Kim <tobetter@gmail.com> wrote:
>> This patch adds device nodes for USBPHY to Exynos4x12.
>>
>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>> ---
>>  arch/arm/boot/dts/exynos4x12.dtsi |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
>> index 01da194..9c3335b 100644
>> --- a/arch/arm/boot/dts/exynos4x12.dtsi
>> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
>> @@ -73,4 +73,22 @@
>>                 clock-names = "sclk_fimg2d", "fimg2d";
>>                 status = "disabled";
>>         };
>> +
>> +       usbphy@125B00000 {
>
> Extra 0 above.
>
This is my bad, I will fix.

>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               compatible = "samsung,exynos4x12-usb2phy";
>> +               reg = <0x125B0000 0x100>;
>> +               ranges;
>> +
>> +               clocks = <&clock 2>, <&clock 305>;
>> +               clock-names = "xusbxti", "otg";
>> +               status = "disabled";
>> +
>> +               usbphy-sys {
>> +                       /* USB device and host PHY_CONTROL registers */
>> +                       reg = <0x10020704 0xc>,
>> +                             <0x1001021c 0x4>;
>> +               };
>> +       };
>>  };
>
> Please add this node after tmu node (satisfies alphabetical order as
> well as increasing address value)
No tmu node in exynos4x12.dtsi in mainline v3.11-rc2 yet, even in
Kukjin's branch.

>
>
> --
> With warm regards,
> Sachin
