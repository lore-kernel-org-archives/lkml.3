Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbaIRDuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:50:23 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:40637 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbaIRDuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1409171051520.1579-100000@iolanthe.rowland.org>
References: <1410952662-4297-2-git-send-email-gautam.vivek@samsung.com>
	<Pine.LNX.4.44L0.1409171051520.1579-100000@iolanthe.rowland.org>
Date: Thu, 18 Sep 2014 09:20:20 +0530
X-Google-Sender-Auth: fmWCeQHr858FV_zZ7FuTAP-VgAk
Message-ID: <CAFp+6iGVGJKrKZLBAsZG5o+EBCQgQUbayhP4UiQNQf6=SVcibA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy support
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,


On Wed, Sep 17, 2014 at 8:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 17 Sep 2014, Vivek Gautam wrote:
>
>> Now that we have completely moved from older USB-PHY drivers
>> to newer GENERIC-PHY drivers for PHYs available with USB controllers
>> on Exynos series of SoCs, we can remove the support for the same
>> in our host drivers too.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>
> I don't see why you made your changes in this awkward way.  For
> instance...
>
>> @@ -59,49 +54,39 @@ static int exynos_ehci_get_phy(struct device *dev,
>>  {
>>       struct device_node *child;
>>       struct phy *phy;
>> -     int phy_number;
>> -     int ret = 0;
>> +     int phy_num;
>
> Why rename this variable?  Wasn't the original name good enough?

fair enough, don't need to rename the variable.

>
>> +     int ret;
>>
>>       for_each_available_child_of_node(dev->of_node, child) {
>> -             ret = of_property_read_u32(child, "reg", &phy_number);
>> +             ret = of_property_read_u32(child, "reg", &phy_num);
>>               if (ret) {
>>                       dev_err(dev, "Failed to parse device tree\n");
>>                       of_node_put(child);
>>                       return ret;
>>               }
>>
>> -             if (phy_number >= PHY_NUMBER) {
>> +             if (phy_num >= PHY_NUMBER) {
>>                       dev_err(dev, "Invalid number of PHYs\n");
>>                       of_node_put(child);
>>                       return -EINVAL;
>>               }
>>
>> -             phy = devm_of_phy_get(dev, child, NULL);
>> +             exynos_ehci->phy[phy_num] = devm_of_phy_get(dev, child, NULL);
>> +             phy = exynos_ehci->phy[phy_num];
>
> Why make two changes, resulting in more code, when you could have made
> just one change?
>
>                 phy = devm_of_phy_get(dev, child, NULL);
> +               exynos_ehci->phy[phy_num] = phy;

Right. i don't know what state of mind i was in while making these changes.
i should have kept the changes to minimal.

>
> Also, the patch description should mention that you are adding support
> for EPROBE_DEFER.

Sure, will add that description.




-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
