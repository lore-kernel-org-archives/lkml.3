Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaD1EGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:06:16 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:37082 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaD1EGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1404251031260.1140-100000@iolanthe.rowland.org>
References: <1398424683-20168-2-git-send-email-gautam.vivek@samsung.com>
	<Pine.LNX.4.44L0.1404251031260.1140-100000@iolanthe.rowland.org>
Date: Mon, 28 Apr 2014 09:36:12 +0530
X-Google-Sender-Auth: e7fw8-6rl1oTskNwEkDq-4VWK2Q
Message-ID: <CAFp+6iG2s5Ddj2F2Xfy3fm9VyW7_G-+YDpeL3iVhur3gng7KvA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] usb: ohci-exynos: Add facility to use phy provided
 by the generic phy framework
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


On Fri, Apr 25, 2014 at 8:06 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 25 Apr 2014, Vivek Gautam wrote:
>
>> Add support to consume phy provided by Generic phy framework.
>> Keeping the support for older usb-phy intact right now, in order
>> to prevent any functionality break in absence of relevant
>> device tree side change for ohci-exynos.
>> Once we move to new phy in the device nodes for ohci, we can
>> remove the support for older phys.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>
>
>> +static int exynos_ohci_phyg_on(struct phy *phy[])
>> +{
>> +     int i;
>> +     int ret = 0;
>> +
>> +     for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
>> +             if (phy[i])
>> +                     ret = phy_power_on(phy[i]);
>> +     if (ret)
>> +             for (i--; i >= 0; i--)
>> +                     if (phy[i])
>> +                             phy_power_off(phy[i]);
>> +
>> +     return ret;
>> +}
>> +
>> +static int exynos_ohci_phyg_off(struct phy *phy[])
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
> You probably shouldn't break out of this loop if ret is nonzero; you
> should continue to power off the remaining phys.

ok, will remove the 'ret' check in for loop.

>
> I'd be inclined to put these two routines directly into
> exynos_ohci_phy_enable() and exynos_ohci_phy_disable(), since they
> aren't used anywhere else.

Sure, will make these routines as a part of exynos_ohci_phy_enable()
and exynos_ohci_phy_disable().

>
>> @@ -151,6 +253,7 @@ skip_phy:
>>
>>  fail_add_hcd:
>>       exynos_ohci_phy_disable(pdev);
>> +     exynos_ohci_phyg_off(exynos_ohci->phy_g);
>
> Why did you add this line?  It doesn't do anything useful, because
> exynos_ohci_phy_disable() already calls exynos_ohci_phyg_off().

Ah ! my bad, will remove this.


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
