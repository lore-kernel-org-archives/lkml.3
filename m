Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaD1EIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:08:50 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:57558 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaD1EIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1404251039210.1140-100000@iolanthe.rowland.org>
References: <1398424873-20257-1-git-send-email-gautam.vivek@samsung.com>
	<Pine.LNX.4.44L0.1404251039210.1140-100000@iolanthe.rowland.org>
Date: Mon, 28 Apr 2014 09:38:47 +0530
X-Google-Sender-Auth: j5Te8Y92IQqgwe6ygDvfOBAaBos
Message-ID: <CAFp+6iH_HyMk8Y53kUPcySDJHhCNdSfXfp1h9F-398spnQwp4A@mail.gmail.com>
Subject: Re: [PATCH v8 2/2] usb: ehci-exynos: Change to use phy provided by
 the generic phy framework
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Apr 25, 2014 at 8:11 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 25 Apr 2014, Vivek Gautam wrote:
>
>> From: Kamil Debski <k.debski@samsung.com>
>>
>> Add the phy provider, supplied by new Exynos-usb2phy using
>> Generic phy framework.
>> Keeping the support for older USB phy intact right now, in order
>> to prevent any functionality break in absence of relevant
>> device tree side change for ehci-exynos.
>> Once we move to new phy in the device nodes for ehci, we can
>> remove the support for older phys.
>>
>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>> [gautam.vivek@samsung.com: Addressed review comments from mailing list]
>> [gautam.vivek@samsung.com: Kept the code for old usb-phy, and just
>> added support for new exynos5-usb2phy in generic phy framework]
>> [gautam.vivek@samsung.com: Edited the commit message]
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>
>> +static int exynos_ehci_phyg_off(struct phy *phy[])
>> +{
>> +     int i;
>> +     int ret = 0;
>> +
>> +     for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
>> +             if (phy[i])
>> +                     ret = phy_power_off(phy[i]);
>> +
>> +     return ret;
>> +}
>
> Same comment as in the OHCI driver about ret.

Ok, will change this.

>
>> @@ -175,6 +269,7 @@ skip_phy:
>>  fail_add_hcd:
>>       if (exynos_ehci->phy)
>>               usb_phy_shutdown(exynos_ehci->phy);
>> +     exynos_ehci_phyg_off(exynos_ehci->phy_g);
>>  fail_io:
>>       clk_disable_unprepare(exynos_ehci->clk);
>>  fail_clk:
>> @@ -195,6 +290,8 @@ static int exynos_ehci_remove(struct platform_device *pdev)
>>       if (exynos_ehci->phy)
>>               usb_phy_shutdown(exynos_ehci->phy);
>>
>> +     exynos_ehci_phyg_off(exynos_ehci->phy_g);
>> +
>
> In both these places, you need to test exynos_ehci->phyg before calling
> exynos_ehci_phyg_off().
>
> Maybe it would help to add exynos_ehci_phy_enable/disable routines,
> like in the OHCI driver.

Will move these statements as a part of enable()/disable() routines,
put necessary check there.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
