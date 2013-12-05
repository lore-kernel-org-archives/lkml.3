Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3LEIRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:17:49 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35908 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3LEIRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:17:47 -0500
MIME-Version: 1.0
In-Reply-To: <2442031.907VFG2eGN@amdc1032>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
	<1386151747-3209-3-git-send-email-gautam.vivek@samsung.com>
	<2442031.907VFG2eGN@amdc1032>
Date: Thu, 5 Dec 2013 13:47:45 +0530
Message-ID: <CAFp+6iH8Sobgjrxj4jmXwhLOCaJSRqe3v6wSFm7wU0vQu5qyDg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dt: exynos5250: Enable support for generic USB 3.0 phy
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Julius Werner <jwerner@chromium.org>,
        Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Dec 4, 2013 at 6:20 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> Hi,
>
> Does the old phy-samsung-usb3 driver currently work on Exynos5250?  If yes,
> then this patch should be merged with patch #1 to preserve bisectability.

Yes, the old phy-samsung-usb3 driver works well on Exynos5250 currently.
Ok, will merge it with patch #1
[PATCH v2 1/4] phy: Add new Exynos5 USB 3.0 PHY driver

Thanks for pointing out.

>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
> On Wednesday, December 04, 2013 03:39:05 PM Vivek Gautam wrote:
>> Update device tree bindings for DWC3 controller and
>> USB 3.0 phy present on Exynos 5250 SoC, to start using
>> the phy driver based on generic phy framework.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos5250.dtsi |   16 ++++++----------
>>  1 files changed, 6 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
>> index 9db5047..7444717 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -475,22 +475,18 @@
>>                       compatible = "synopsys,dwc3";
>>                       reg = <0x12000000 0x10000>;
>>                       interrupts = <0 72 0>;
>> -                     usb-phy = <&usb2_phy &usb3_phy>;
>> +                     phys = <&usb3_phy>;
>> +                     phy-names = "usb3-phy";
>>               };
>>       };
>>
>>       usb3_phy: usbphy@12100000 {
>>               compatible = "samsung,exynos5250-usb3phy";
>>               reg = <0x12100000 0x100>;
>> -             clocks = <&clock 1>, <&clock 286>;
>> -             clock-names = "ext_xtal", "usbdrd30";
>> -             #address-cells = <1>;
>> -             #size-cells = <1>;
>> -             ranges;
>> -
>> -             usbphy-sys {
>> -                     reg = <0x10040704 0x8>;
>> -             };
>> +             clocks = <&clock 286>, <&clock 1>;
>> +             clock-names = "phy", "usb3phy_refclk";
>> +             samsung,syscon-phandle = <&pmu_syscon>;
>> +             #phy-cells = <0>;
>>       };
>>
>>       usb@12110000 {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
