Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705Ab3DCGSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:18:43 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:53995 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762685Ab3DCGSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <515BB951.40702@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
	<1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
	<515BB951.40702@ti.com>
Date: Wed, 3 Apr 2013 11:48:39 +0530
Message-ID: <CAFp+6iG8WdWHXVCANx77OiTXLeZ-4qE4jySWqPLhfR1KOEP4fw@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, dianders@chromium.org, t.figa@samsung.com,
        p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


On Wed, Apr 3, 2013 at 10:38 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
>
> On Monday 01 April 2013 07:24 PM, Vivek Gautam wrote:
>>
>> Adding  APIs to handle runtime power management on PHY
>> devices. PHY consumers may need to wake-up/suspend PHYs
>> when they work across autosuspend.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>   include/linux/usb/phy.h |  141
>> +++++++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 141 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
>> index 6b5978f..01bf9c1 100644
>> --- a/include/linux/usb/phy.h
>> +++ b/include/linux/usb/phy.h
>> @@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(enum
>> usb_phy_type type)
>>                 return "UNKNOWN PHY TYPE";
>>         }
>>   }
>> +
>> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
>> +{
>> +       if (!x || !x->dev) {
>> +               dev_err(x->dev, "no PHY or attached device available\n");
>> +               return;
>> +               }
>> +
>> +       pm_runtime_enable(x->dev);
>> +}
>
>
> IMO we need not have wrapper APIs for runtime_enable and runtime_disable
> here. Generally runtime_enable and runtime_disable is done in probe and
> remove of a driver respectively. So it's better to leave the
> runtime_enable/runtime_disable to be done in *phy provider* driver than
> having an API for it to be done by *phy user* driver. Felipe, what do you
> think?

Thanks!!
That's very true, runtime_enable() and runtime_disable() calls are made by
*phy_provider* only. But a querry here.
Wouldn't in any case a PHY consumer might want to disable runtime_pm on PHY ?
Say, when consumer failed to suspend the PHY properly
(*put_sync(phy->dev)* fails), how much sure is the consumer about the
state of PHY ?


-- 
Thanks & Regards
Vivek
