Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3KER4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:56:07 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59699 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3KER4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:56:04 -0500
MIME-Version: 1.0
In-Reply-To: <00fe01ceda0a$941957a0$bc4c06e0$%debski@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
	<1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
	<527744B2.4090303@ti.com>
	<030d01ced946$d6e23490$84a69db0$%debski@samsung.com>
	<52779D28.9000905@ti.com>
	<CAFp+6iH7vQ-OtMFL4pyr4tFDRchH4oh1Z0753WNgrHiUzj+kzw@mail.gmail.com>
	<00fe01ceda0a$941957a0$bc4c06e0$%debski@samsung.com>
Date: Tue, 5 Nov 2013 23:26:01 +0530
Message-ID: <CAFp+6iE_EgPJCSHqRrNDMhmc6ODtM=LogVyfG8SpR6TPH0MicA@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Julius Werner <jwerner@chromium.org>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,


On Tue, Nov 5, 2013 at 3:06 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
>> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com]
>> Sent: Tuesday, November 05, 2013 8:20 AM
>> To: Kishon Vijay Abraham I
>> Cc: Kamil Debski; Vivek Gautam; Linux USB Mailing List; linux-samsung-
>> soc@vger.kernel.org; linux-kernel@vger.kernel.org;
>> devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> linux-doc@vger.kernel.org; Greg KH; Kukjin Kim; Sylwester Nawrocki;
>> Tomasz Figa; Felipe Balbi; Julius Werner; Jingoo Han
>> Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
>>
>> Hi Kishon,
>>
>>
>>
>> On Mon, Nov 4, 2013 at 6:42 PM, Kishon Vijay Abraham I <kishon@ti.com>
>> wrote:
>> > Hi,
>> >
>> >
>> > On Monday 04 November 2013 03:45 PM, Kamil Debski wrote:
>> >>
>> >> Hi Kishon,
>> >>
>> >>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
>> >>> Sent: Monday, November 04, 2013 7:55 AM
>> >>>
>> >>> Hi Vivek,
>> >>>
>> >>> On Thursday 31 October 2013 01:15 PM, Vivek Gautam wrote:
>> >>>>
>> >>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>> >>>> The new driver uses the generic PHY framework and will interact
>> >>>> with
>> >>>> DWC3 controller present on Exynos5 series of SoCs.
>> >>>
>> >>>
>> >>> In Exynos, you have a single IP that supports both USB3 and USB2
>> PHY
>> >>> right? I think that needs to be mentioned here.
>> >>
>> >>
>> >> As far as I know the IP is different.
>> >
>> >
>> > Ok. Sometime back Vivek was mentioning about a single IP for both
>> USB3
>> > and USB2. Thought it should be this driver. Anyway thanks for the
>> clarification.
>>
>> Right Kishon, I had mentioned that Exynos5's dwc3 controller have a
>> single IP for USB2 and USB3 phy.
>> From what i see, on exynos5 systems the dwc3 controller uses a combo of
>> usb 2 (utmi+) and usb 3 (pipe 3) phy (with base address starting
>> 0x12100000).
>>
>> Kamil, Tomasz,
>>
>> Please correct me if i am wrong.
>
> I have the Exynos 5250 documentation and I found two phy register ranges:
> 1) USB 2.0 PHY having the base address of 0x1213 0000
>         Chapter 33. USB 2.0 Host Controller
>         Subchapter 33.5.2 Phy Control Register p. 1696
>         First register's description is
>         "USB2.0 phy control register"
> 2) USB 3.0 PHY (I guess) with the base address 0x1210 0000
>         Chapter 35. USB 3.0 DRD Controller
>         Subchapter 35.4.6 PHY Control Register p. 1872
>
> Jingoo, could you comment on the above? You may know more than we do :)
>
> In addition, I have a question to you Vivek - does your USB 3.0
> PHY support both host and device?

Yes, this PHY driver supports both Host as well as device type of
operations of DWC3 controller.
This driver is a straight port from older driver available at
drivers/usb/phy/phy-samsung-usb3.c which also had been tested
for host as well as device operation of DWC3.

>
> [snip]
>
> Best wishes,
> Kamil Debski
>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
