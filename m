Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3IKCjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:39:36 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53061 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3IKCjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:39:35 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522FD7E4.90101@roeck-us.net>
Date: Tue, 10 Sep 2013 19:39:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2 2/6] extcon-gpio: Use gpio driver/chip debounce if
 supported
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net> <1377836978-24082-3-git-send-email-linux@roeck-us.net> <20130911021618.GA2657@roeck-us.net> <522FD58A.6070407@samsung.com>
In-Reply-To: <522FD58A.6070407@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 07:29 PM, Chanwoo Choi wrote:
> On 09/11/2013 11:16 AM, Guenter Roeck wrote:
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v2: rephrase patch subject
>>      call gpio_set_debounce before registering extcon device,
>>      and set debounce_jiffies only if the call was not successful
>>
>>   drivers/extcon/extcon-gpio.c |    8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>> index 77d35a7..e5a4405 100644
>> --- a/drivers/extcon/extcon-gpio.c
>> +++ b/drivers/extcon/extcon-gpio.c
>> @@ -100,7 +100,13 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>   	extcon_data->state_off = pdata->state_off;
>>   	if (pdata->state_on && pdata->state_off)
>>   		extcon_data->edev.print_state = extcon_gpio_print_state;
>> -	extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
>> +	if (pdata->debounce) {
>> +		ret = gpio_set_debounce(extcon_data->gpio,
>> +					pdata->debounce * 1000);
>> +		if (ret < 0)
>> +			extcon_data->debounce_jiffies =
>> +				msecs_to_jiffies(pdata->debounce);
>> +	}
>>
>>   	ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
>>   	if (ret < 0)
>>
>
> I'd like you to add patch description for patch feature.
> So I add a little description about using gpio_set_debounce()
>
> I modify patch name as following to maintain patch naming style of extcon.
> Before
> 	extcon-gpio: Do not unnecessarily initialize variables
> 	extcon-gpio: Use gpio driver/chip debounce if supported
> After
> 	extcon: gpio: Do not unnecessarily initialize variables
> 	extcon: gpio: Use gpio driver/chip debounce if supported
>
No problem. I'll try to remember next time. Too late for patch 3/6, though.
Sorry for that.

> Applied it on extcon-linus.
> You can check it on extcon-linus branch in a few minutes.
>
Thanks,
Guenter

