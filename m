Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaDNIMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:12:34 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:64247 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaDNIM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:12:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140412033718.GA18777@saruman.home>
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
	<20140412033718.GA18777@saruman.home>
Date: Mon, 14 Apr 2014 13:35:12 +0530
Message-ID: <CAFp+6iF9Xk=uCUi6q_AEbGKL6LYxoa6kECUPXzUS4E3B9+CWYg@mail.gmail.com>
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio on/off
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, kishon <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Sat, Apr 12, 2014 at 9:07 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Apr 09, 2014 at 05:24:45PM +0530, Vivek Gautam wrote:
>> Adding support to enable/disable VBUS hooked to a gpio
>> to enable vbus supply on the port.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Based on 'phy-exynos5-usbdrd' patches:
>> [PATCH V4 0/5] Add Exynos5 USB 3.0 phy driver based on generic PHY framework
>> http://www.spinics.net/lists/linux-usb/msg105507.html
>>
>>  drivers/phy/phy-exynos5-usbdrd.c |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
>> index ff54a7c..5ca7485 100644
>> --- a/drivers/phy/phy-exynos5-usbdrd.c
>> +++ b/drivers/phy/phy-exynos5-usbdrd.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>>  #include <linux/of_address.h>
>> +#include <linux/of_gpio.h>
>>  #include <linux/phy/phy.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/mutex.h>
>> @@ -176,6 +177,7 @@ struct exynos5_usbdrd_phy {
>>       struct clk *ref_clk;
>>       unsigned long ref_rate;
>>       unsigned int refclk_reg;
>> +     int gpio;
>>  };
>>
>>  #define to_usbdrd_phy(inst) \
>> @@ -460,6 +462,9 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
>>       if (!IS_ERR(phy_drd->usb30_sclk))
>>               clk_prepare_enable(phy_drd->usb30_sclk);
>>
>> +     /* Toggle VBUS gpio - on */
>> +     gpio_set_value(phy_drd->gpio, 1);
>
> It seems like you'd be better off using a regulator_enable() call for
> this.

Sure, i will use a regulator for this vbus settings.


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
