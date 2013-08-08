Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab3HHKHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:07:52 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14921 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100Ab3HHKHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:07:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Aug 2013 03:07:50 -0700
Message-ID: <52036DF8.8000903@nvidia.com>
Date: Thu, 8 Aug 2013 18:07:52 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: Guenter Roeck <linux@roeck-us.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <520359E9.1000600@roeck-us.net> <52036920.4050808@nvidia.com> <1375955834.368114617@f197.i.mail.ru>
In-Reply-To: <1375955834.368114617@f197.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 05:57 PM, Alexander Shiyan wrote:
>> On 08/08/2013 04:42 PM, Guenter Roeck wrote:
>>> On 08/07/2013 11:56 PM, Wei Ni wrote:
>>>> The device lm90 can be controlled by the vdd rail.
>>>> Adding the power control support to power on/off the vdd rail.
>>>> And make sure that power is enabled before accessing the device.
>>>>
>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>>> ---
>>>>   drivers/hwmon/lm90.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
> [...]
>>> I consider the messages unnecessary and confusing. You are polluting the log
>>> of pretty much every PC user who has one of the supported chips in the system,
>>> and of everyone else not using regulators for this chip.
>>
>> Ok, I will remove these codes.
>> So I will write something like:
>> if (!IS_ERR(data->lm90_reg)) {
>>     ret = regulator_enable(data->lm90_reg);
>>     if (ret < 0) {
>>         dev_err();
>>         return ret;
>>     }
>> } else {
>>     if (PTR_ERR(data->lm90_reg) == -EPROBE_DEFER)
>>         return -EPRPBE_DEFER;
>>
>>         data->lm90_reg = !!IS_ERR(data->lm90_reg);

BTW, since it may return EPROBE_DEFER, these codes should be put in the
beginning of the probe() function, should before allocate lm90_data.

> 
> No. You do not need this line.
> 
> Just use in remove():
> if (!IS_ERR(data->lm90_reg))
> regulator_disable(data->lm90_reg);
> 
> ---
> 

