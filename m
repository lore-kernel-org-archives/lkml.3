Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3APPJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:09:20 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:52889 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3APPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:09:18 -0500
MIME-Version: 1.0
In-Reply-To: <2542030.a14I18dBkO@flatron>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
	<1358257112-19595-3-git-send-email-gautam.vivek@samsung.com>
	<2542030.a14I18dBkO@flatron>
Date: Wed, 16 Jan 2013 20:39:16 +0530
Message-ID: <CAFp+6iFsTj+F4MN0EKQueVpzju+OYV75C1thxVC8udv3tm9raw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] ARM: Exynos5250: Enabling ohci-exynos driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        kgene.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,


On Wed, Jan 16, 2013 at 1:14 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Vivek,
>
> On Tuesday 15 of January 2013 19:08:30 Vivek Gautam wrote:
>> Adding OHCI device tree node for Exynos5250 along with
>> the device base address.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  .../devicetree/bindings/usb/exynos-usb.txt         |   15
>> +++++++++++++++ arch/arm/boot/dts/exynos5250.dtsi                  |
>> 6 ++++++ 2 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> b/Documentation/devicetree/bindings/usb/exynos-usb.txt index
>> e8bbb47..f66fcdd 100644
>> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> @@ -23,3 +23,18 @@ Example:
>>               interrupts = <0 71 0>;
>>               samsung,vbus-gpio = <&gpx2 6 1 3 3>;
>>       };
>> +
>> +OHCI
>> +Required properties:
>> + - compatible: should be "samsung,exynos4210-ohci" for USB 2.0
>> +   OHCI companion controller in host mode.
>> + - reg: physical base address of the controller and length of memory
>> mapped +   region.
>> + - interrupts: interrupt number to the cpu.
>> +
>> +Example:
>> +     usb@12120000 {
>> +             compatible = "samsung,exynos4210-ohci";
>> +             reg = <0x12120000 0x100>;
>> +             interrupts = <0 71 0>;
>> +     };
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>> b/arch/arm/boot/dts/exynos5250.dtsi index 2cbe53e..ebb0907 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -281,6 +281,12 @@
>>               interrupts = <0 71 0>;
>>       };
>>
>> +     usb@12120000 {
>> +             compatible = "samsung,exynos4210-ohci";
>> +             reg = <0x12120000 0x100>;
>> +             interrupts = <0 71 0>;
>
> For Samsung platforms we decided per board enabling of nodes and so this
> node should also contain:
>
>                 status = "disabled";
>
> while in dts file of board using ohci there would be an overriding entry:
>
>         usb@12120000 {
>                 status = "okay";
>         };
>

Yes, i could see that for exynos4x dt.

> I know that Exynos5250 has not been yet converted into this convention,
> but using it when adding new devices will simplify the process.
>

Sure, will change this and other patches for usb as suggested.
Thanks for the review. :-)



-- 
Thanks & Regards
Vivek
