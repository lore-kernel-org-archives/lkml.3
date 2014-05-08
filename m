Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaEHKQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:16:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47243 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaEHKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:16:12 -0400
Message-ID: <536B5967.6020503@ti.com>
Date: Thu, 8 May 2014 15:46:07 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 3/5] usb: musb: core: Convert the musb_platform_reset
 to have a return value.
References: <1399541743-14158-1-git-send-email-george.cherian@ti.com> <1399541743-14158-4-git-send-email-george.cherian@ti.com> <536B52C3.3010109@gmail.com>
In-Reply-To: <536B52C3.3010109@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2014 3:17 PM, Daniel Mack wrote:
> Hi Geroge,
>
> On 05/08/2014 11:35 AM, George Cherian wrote:
>> -static inline void musb_platform_reset(struct musb *musb)
>> +static inline int  musb_platform_reset(struct musb *musb)
>>   {
>> -	if (musb->ops->reset)
>> -		musb->ops->reset(musb);
>> +	if (!musb->ops->reset)
>> +		return -EINVAL;
>> +
>> +	return musb->ops->reset(musb);
>>   }
>>   
>>   static inline int musb_platform_get_vbus_status(struct musb *musb)
>> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
>> index 74c4193..8438200 100644
>> --- a/drivers/usb/musb/musb_dsps.c
>> +++ b/drivers/usb/musb/musb_dsps.c
>> @@ -536,7 +536,7 @@ static int dsps_musb_set_mode(struct musb *musb, u8 mode)
>>   	return 0;
>>   }
>>   
>> -static void dsps_musb_reset(struct musb *musb)
>> +static int dsps_musb_reset(struct musb *musb)
>>   {
>>   	struct device *dev = musb->controller;
>>   	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
>> @@ -548,6 +548,7 @@ static void dsps_musb_reset(struct musb *musb)
>>   	usleep_range(100, 200);
>>   	usb_phy_init(musb->xceiv);
>>   
>> +	return 1;
> Could we follow the general kernel rule here and return 0 for success,
> and < 0 on failure?
I made this to return 1, just because the next patch in the series would 
make it
return session_restart. Depending on which the musb_platform_reset() 
would return
whether actual reset of IP (reset_done) is done or not .

>
>
>
> Thanks,
> Daniel
>


-- 
-George

