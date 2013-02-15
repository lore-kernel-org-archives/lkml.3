Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3BOFJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:09:30 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:57836 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3BOFJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:09:28 -0500
MIME-Version: 1.0
In-Reply-To: <1a5501ce064c$8d2ed1a0$a78c74e0$@samsung.com>
References: <CAFp+6iFgaT9D2hR0pX34jo2g+GHftmA0Mw3y96-oKe0KakZOxA@mail.gmail.com>
	<1358315143-16620-1-git-send-email-gautam.vivek@samsung.com>
	<1a5501ce064c$8d2ed1a0$a78c74e0$@samsung.com>
Date: Fri, 15 Feb 2013 10:39:25 +0530
Message-ID: <CAFp+6iHn1A0qBV0jE8qZoVgjWZDbSGXi5QV=hpUvErzf7BC4Sw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] ARM: Exynos5250: Enabling ehci-s5p driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com,
        Thomas Abraham <thomas.ab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 4:05 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Vivek Gautam wrote:
>>
>> Adding EHCI device tree node for Exynos5250 along with
>> the device base adress and gpio line for vbus.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> Changes from v4:
>>  - Added gpio line for VBUS of USB2.0 on snow board.
>>
>>  .../devicetree/bindings/usb/exynos-usb.txt         |   25
>> ++++++++++++++++++++
>>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +++
>>  arch/arm/boot/dts/exynos5250-snow.dts              |    4 +++
>>  arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++
>>  4 files changed, 39 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/usb/exynos-
>> usb.txt
>>
>> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> new file mode 100644
>> index 0000000..e8bbb47
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>> @@ -0,0 +1,25 @@
>> +Samsung Exynos SoC USB controller
>> +
>> +The USB devices interface with USB controllers on Exynos SOCs.
>> +The device node has following properties.
>> +
>> +EHCI
>> +Required properties:
>> + - compatible: should be "samsung,exynos4210-ehci" for USB 2.0
>> +   EHCI controller in host mode.
>> + - reg: physical base address of the controller and length of memory
>> mapped
>> +   region.
>> + - interrupts: interrupt number to the cpu.
>> +
>> +Optional properties:
>> + - samsung,vbus-gpio:  if present, specifies the GPIO that
>> +   needs to be pulled up for the bus to be powered.
>> +
>> +Example:
>> +
>> +     usb@12110000 {
>> +             compatible = "samsung,exynos4210-ehci";
>> +             reg = <0x12110000 0x100>;
>> +             interrupts = <0 71 0>;
>> +             samsung,vbus-gpio = <&gpx2 6 1 3 3>;
>> +     };
>> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> index 942d576..7363e14 100644
>> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>> @@ -204,4 +204,8 @@
>>               samsung,mfc-r = <0x43000000 0x800000>;
>>               samsung,mfc-l = <0x51000000 0x800000>;
>>       };
>> +
>> +     usb@12110000 {
>> +             samsung,vbus-gpio = <&gpx2 6 1 3 3>;
>> +     };
>>  };
>> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts
>> b/arch/arm/boot/dts/exynos5250-snow.dts
>> index 17dd951..47b6b84 100644
>> --- a/arch/arm/boot/dts/exynos5250-snow.dts
>> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
>> @@ -40,4 +40,8 @@
>>                               <&gpc4 5 2 3 0>, <&gpc4 6 2 3 0>;
>>               };
>>       };
>> +
>> +     usb@12110000 {
>> +             samsung,vbus-gpio = <&gpx1 1 1 3 3>;
>> +     };
>>  };
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>> b/arch/arm/boot/dts/exynos5250.dtsi
>> index 30485de..2cbe53e 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -275,6 +275,12 @@
>>               #size-cells = <0>;
>>       };
>>
>> +     usb@12110000 {
>> +             compatible = "samsung,exynos4210-ehci";
>> +             reg = <0x12110000 0x100>;
>> +             interrupts = <0 71 0>;
>> +     };
>> +
>>       amba {
>>               #address-cells = <1>;
>>               #size-cells = <1>;
>> --
>> 1.7.6.5
>
> Looks good to me and applied this and "[PATCH v3 2/4] ARM: Exynos5250:
> Enabling ohci-exynos driver" in Samsung tree.
>
> Note, I think, you need to implement to use pinctrl for this instead of old
> gpio bindings next time, probably after release v3.9-rc1.
>

Sure, will add the necessary pinctrl support replacing the old gpio bindings,
and post the same asap. :-)

> Ah, one more, please use subject lines appropriate like others, "ARM: dts:
> ....".
>

Sorry, for misleading subject line, will keep commit titles
aligned-with in future,

> Thanks.
>
> - Kukjin
>


-- 
Thanks & Regards
Vivek
