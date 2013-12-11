Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058Ab3LKGiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:38:12 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40097 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3LKGiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:38:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131210140142.GB28456@xps8300>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
	<1386672926-26885-2-git-send-email-gautam.vivek@samsung.com>
	<20131210140142.GB28456@xps8300>
Date: Wed, 11 Dec 2013 12:08:04 +0530
Message-ID: <CAFp+6iENkrSUT=_iv+uZnVpDSGDQGOzF_oyZ6Dmzr8VcQfjztw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] phy: Add provision for tuning phy.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Dec 10, 2013 at 7:31 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi,

Thanks for reviewing this.

>
> On Tue, Dec 10, 2013 at 04:25:23PM +0530, Vivek Gautam wrote:
>> Some PHY controllers may need to tune PHY post-initialization,
>> so that the PHY consumers can call phy-tuning at appropriate
>> point of time.
>>
>> Signed-off-by: vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/phy/phy-core.c  |   20 ++++++++++++++++++++
>>  include/linux/phy/phy.h |    7 +++++++
>>  2 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>> index 03cf8fb..68dbb90 100644
>> --- a/drivers/phy/phy-core.c
>> +++ b/drivers/phy/phy-core.c
>> @@ -239,6 +239,26 @@ out:
>>  }
>>  EXPORT_SYMBOL_GPL(phy_power_off);
>>
>> +int phy_tune(struct phy *phy)
>> +{
>> +     int ret = -ENOTSUPP;
>> +
>> +     mutex_lock(&phy->mutex);
>> +     if (phy->ops->tune) {
>> +             ret =  phy->ops->tune(phy);
>> +             if (ret < 0) {
>> +                     dev_err(&phy->dev, "phy tuning failed --> %d\n", ret);
>> +                     goto out;
>> +             }
>> +     }
>> +
>> +out:
>> +     mutex_unlock(&phy->mutex);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(phy_tune);
>
> I think "setup" instead of "tune" is much more clear and reusable.

I think "setup" will look more like first time setting up the phy,
which is rather served by "init" callback.
This i thought would serve the purpose of over-riding certain PHY
parameters, which would not have been
possible at "init" time.
Please correct my thinking if i am unable to understand your point here.

>
> Thanks,
>
> --
> heikki
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
