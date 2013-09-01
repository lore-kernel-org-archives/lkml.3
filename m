Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab3IARzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 13:55:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61111 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3IARzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 13:55:36 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52237F96.2090008@roeck-us.net>
Date: Sun, 01 Sep 2013 10:55:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] hwmon: Introduce hwmon_device_register_with_groups
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net> <1378003742-18685-2-git-send-email-linux@roeck-us.net> <20130901162441.GB32712@kroah.com>
In-Reply-To: <20130901162441.GB32712@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2013 09:24 AM, Greg Kroah-Hartman wrote:
> This looks good, just one minor question about the
> non-driver-core-related code:
>
>> +struct device *
>> +hwmon_device_register_with_groups(struct device *dev, const char *name,
>> +				  void *drvdata,
>> +				  const struct attribute_group **groups)
>>   {
>> -	struct device *hwdev;
>> -	int id;
>> +	struct hwmon_device *hwdev;
>> +	int err, id;
>>
>>   	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
>>   	if (id < 0)
>>   		return ERR_PTR(id);
>
> Don't you need a lock around the ida_simple_get call to ensure hwmon_ida
> is not being used at the same time twice?  Or does the ida framework
> handle that ok?
>

ida_simple_get handles the locking as far as I can see. Other callers don't use
local locks either, so I guess it must be working.

Guenter

