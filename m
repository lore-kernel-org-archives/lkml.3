Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3ILAXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:23:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64069 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3ILAXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:23:36 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52310984.30809@roeck-us.net>
Date: Wed, 11 Sep 2013 17:23:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 3/6] extcon-gpio: Add support for active-low presence
 detect pins
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net> <1377836978-24082-4-git-send-email-linux@roeck-us.net> <522FD20C.6080404@samsung.com> <20130911022513.GA5251@roeck-us.net> <52310355.7060004@samsung.com>
In-Reply-To: <52310355.7060004@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 04:57 PM, Chanwoo Choi wrote:
> Hi Guenter,
>
> As I mentioned on previous reply, I modify patch name as following:
> extcon-gpio: Add support for active-low presence detect pins
> ->
> extcon: gpio: Add support for active-low presence detect pins
>
> I prefer you could add patch description. Also, you should test

As mentioned before, I sent out v2 of this patch before I read your comments
to the previous patch.

> on extcon latest branch to protect merge conflict. This patch
> has conflict issue on extcon-linus branch. I fix up and applied it.
>
I'll make sure to so that in the future.

> And I think you might use tab size is 4 characters. you should change tab size
> from 4 characters to 8 characters. You can check linux kernel coding sytle on

Thanks for the reminder, but the problem is a different one. See below.

> "/kernel/Documentation/CodingStyle - chapter 1: Indentation".
>
> On 09/11/2013 11:25 AM, Guenter Roeck wrote:
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v2: Document gpio_active_low variable in gpio_extcon_platform_data
>>      Rewrite active-low logic to be easier to read.
>>
>>   drivers/extcon/extcon-gpio.c       |    4 ++++
>>   include/linux/extcon/extcon-gpio.h |    5 +++++
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>> index 862743b..8491f86 100644
>> --- a/drivers/extcon/extcon-gpio.c
>> +++ b/drivers/extcon/extcon-gpio.c
>> @@ -34,6 +34,7 @@
>>   struct gpio_extcon_data {
>>   	struct extcon_dev edev;
>>   	unsigned gpio;
>> +	bool gpio_active_low;
>>   	const char *state_on;
>>   	const char *state_off;
>>   	int irq;
>> @@ -49,6 +50,8 @@ static void gpio_extcon_work(struct work_struct *work)
>>   			     work);
>>
>>   	state = gpio_get_value(data->gpio);
>> +	if (data->gpio_active_low)
>> +		state = !state;
>>   	extcon_set_state(&data->edev, state);
>>   }
>>
>> @@ -96,6 +99,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>
>>   	extcon_data->edev.name = pdata->name;
>>   	extcon_data->gpio = pdata->gpio;
>> +	extcon_data->gpio_active_low = pdata->gpio_active_low;
>>   	extcon_data->state_on = pdata->state_on;
>>   	extcon_data->state_off = pdata->state_off;
>>   	if (pdata->state_on && pdata->state_off)
>> diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
>> index 2d8307f..51ef15c 100644
>> --- a/include/linux/extcon/extcon-gpio.h
>> +++ b/include/linux/extcon/extcon-gpio.h
>> @@ -27,6 +27,10 @@
>>    * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
>>    * @name	The name of this GPIO extcon device.
>>    * @gpio	Corresponding GPIO.
>> + * @gpio_active_low:
>> + * 		Boolean describing whether gpio active state is 1 or 0
>> + * 		If true, low state of gpio means active.
>> + * 		If false, high state of gpio means active.
>
> I think you may use tab size is 4 characters.
>
No, that isn't it. When I cut-and-pasted your proposed text I was not careful enough
and did not remove a space after the '*'. No idea how it got there, but it isn't the
tab setting.

Usually I _do_ run my patches through checkpatch.pl to avoid problems like that.
Sorry, my bad; looks like I was shooting too quickly last night and didn't do that.

Guenter

