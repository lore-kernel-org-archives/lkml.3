Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaDOFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:09:27 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:46379 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaDOFJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <534BF28E.7040906@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
	<1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
	<534BF28E.7040906@samsung.com>
Date: Tue, 15 Apr 2014 10:39:24 +0530
X-Google-Sender-Auth: CKFQvGOzlGdqHV8OamNNJ0RRsd0
Message-ID: <CAFp+6iF8rgJAMckYYm82roARLfa3F2vA3Hwv-xv8EWQcpj1T+w@mail.gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, kishon <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, Apr 14, 2014 at 8:07 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 08/04/14 16:36, Vivek Gautam wrote:
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> index 28f9edb..6d99ba9 100644
>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> @@ -74,3 +74,45 @@ phy-consumer@12340000 {
>>
>>  Refer to DT bindings documentation of particular PHY consumer devices for more
>>  information about required PHYs and the way of specification.
>> +
>> +Samsung Exynos5 SoC series USB DRD PHY controller
>> +--------------------------------------------------
>> +
>> +Required properties:
>> +- compatible : Should be set to one of the following supported values:
>> +     - "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
>> +     - "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
>> +- reg : Register offset and length of USB DRD PHY register set;
>> +- clocks: Clock IDs array as required by the controller
>> +- clock-names: names of clocks correseponding to IDs in the clock property;
>> +            Required clocks:
>> +     - phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP clock),
>> +            used for register access.
>> +     - ref: PHY's reference clock (usually crystal clock), associated by
>> +            phy name, used to determine bit values for clock settings
>> +            register.
>> +     Additional clock required for Exynos5420:
>> +     - usb30_sclk_100m: Additional special clock used for PHY operation
>> +                        depicted as 'sclk_usbphy30' in CMU of Exynos5420.
>> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
>> +                       control pmu registers for power isolation.
>
> Why to append "-phandle" to the property's name ? If this is for PMU
> perhaps make it more explicit and name it: samsung,pmu-syscon or
> samsung,pmureg ?

Right, thanks for pointing out this.
Will rename it to samsung,pmu-syscon. That will be inline with the
phandle it points to.
