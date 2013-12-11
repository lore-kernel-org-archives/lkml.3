Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957Ab3LKIR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:17:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37725 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab3LKIR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:17:26 -0500
Message-ID: <52A81F89.4010603@ti.com>
Date: Wed, 11 Dec 2013 13:47:13 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH RFC 1/4] phy: Add provision for tuning phy.
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>	<1386672926-26885-2-git-send-email-gautam.vivek@samsung.com>	<20131210140142.GB28456@xps8300> <CAFp+6iENkrSUT=_iv+uZnVpDSGDQGOzF_oyZ6Dmzr8VcQfjztw@mail.gmail.com>
In-Reply-To: <CAFp+6iENkrSUT=_iv+uZnVpDSGDQGOzF_oyZ6Dmzr8VcQfjztw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 December 2013 12:08 PM, Vivek Gautam wrote:
> Hi,
> 
> 
> On Tue, Dec 10, 2013 at 7:31 PM, Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
>> Hi,
> 
> Thanks for reviewing this.
> 
>>
>> On Tue, Dec 10, 2013 at 04:25:23PM +0530, Vivek Gautam wrote:
>>> Some PHY controllers may need to tune PHY post-initialization,
>>> so that the PHY consumers can call phy-tuning at appropriate
>>> point of time.
>>>
>>> Signed-off-by: vivek Gautam <gautam.vivek@samsung.com>
>>> ---
>>>  drivers/phy/phy-core.c  |   20 ++++++++++++++++++++
>>>  include/linux/phy/phy.h |    7 +++++++
>>>  2 files changed, 27 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>> index 03cf8fb..68dbb90 100644
>>> --- a/drivers/phy/phy-core.c
>>> +++ b/drivers/phy/phy-core.c
>>> @@ -239,6 +239,26 @@ out:
>>>  }
>>>  EXPORT_SYMBOL_GPL(phy_power_off);
>>>
>>> +int phy_tune(struct phy *phy)
>>> +{
>>> +     int ret = -ENOTSUPP;
>>> +
>>> +     mutex_lock(&phy->mutex);
>>> +     if (phy->ops->tune) {
>>> +             ret =  phy->ops->tune(phy);
>>> +             if (ret < 0) {
>>> +                     dev_err(&phy->dev, "phy tuning failed --> %d\n", ret);
>>> +                     goto out;
>>> +             }
>>> +     }
>>> +
>>> +out:
>>> +     mutex_unlock(&phy->mutex);
>>> +
>>> +     return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(phy_tune);
>>
>> I think "setup" instead of "tune" is much more clear and reusable.
> 
> I think "setup" will look more like first time setting up the phy,
> which is rather served by "init" callback.
> This i thought would serve the purpose of over-riding certain PHY
> parameters, which would not have been
> possible at "init" time.
> Please correct my thinking if i am unable to understand your point here.

how about 'calibrate'?

Thanks
Kishon
> 
>>
>> Thanks,
>>
>> --
>> heikki
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

