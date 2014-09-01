Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaIAH5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:57:41 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:44738 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaIAH5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140828191625.GQ16689@saruman.home>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
	<1409212920-28526-4-git-send-email-gautam.vivek@samsung.com>
	<20140828191625.GQ16689@saruman.home>
Date: Mon, 1 Sep 2014 13:27:38 +0530
X-Google-Sender-Auth: 8i0MGmt9bihpfK7vMFjNA_D6l4c
Message-ID: <CAFp+6iFrx6RJJjkuLpy+2RGsscpf2PXUATABJq8oPL+XhE_+vQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Fri, Aug 29, 2014 at 12:46 AM, Felipe Balbi <balbi@ti.com> wrote:
> hi,
>
> On Thu, Aug 28, 2014 at 01:31:58PM +0530, Vivek Gautam wrote:
>> @@ -457,11 +458,19 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
>>       clk_prepare_enable(phy_drd->ref_clk);
>>
>>       /* Enable VBUS supply */
>> +     if (phy_drd->vbus_boost) {
>> +             ret = regulator_enable(phy_drd->vbus_boost);
>> +             if (ret) {
>> +                     dev_err(phy_drd->dev,
>> +                             "Failed to enable VBUS boost supply\n");
>> +                     goto fail_vbus;
>> +             }
>> +     }
>
> really this is nitpicking, but can you add a blank line here just make
> my inner child happy ? :-)

Sure will add an extra line here and similar instances of this change.

>
>> @@ -470,6 +479,9 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
>>
>>       return 0;
>>
>> +fail_vbus_boost:
>> +     if (phy_drd->vbus_boost)
>> +             regulator_disable(phy_drd->vbus_boost);
>
> same here
>
> --
> balbi



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
