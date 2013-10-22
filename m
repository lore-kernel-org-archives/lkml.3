Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3JVClv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 22:41:51 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58672 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3JVClu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 22:41:50 -0400
Message-ID: <5265E5E6.30908@gmail.com>
Date: Tue, 22 Oct 2013 10:41:42 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
References: <525F8895.5010806@gmail.com> <20131017071445.GA2502@ulmo.nvidia.com> <5260BD8C.7000200@gmail.com>
In-Reply-To: <5260BD8C.7000200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Thierry...

Mark
On 10/18/2013 12:48 PM, Mark Zhang wrote:
> On 10/17/2013 03:14 PM, Thierry Reding wrote:
>> On Thu, Oct 17, 2013 at 02:49:57PM +0800, Mark Zhang wrote:
>>> Hi,
>>>
>>> This is the first time I send mail to linux-pwm, I didn't read through
>>> the mails in this list, so if somebody already asked this question, I'm
>>> sorry about that.
>>>
>>> I wanna set some fops in "struct platform_pwm_backlight_data". But the
>>> currrent probe function in pwm_bl.c says:
>>>
>>> -------
>>> if (!data) {
>>> 	ret = pwm_backlight_parse_dt(&pdev->dev, &defdata);
>>> 	if (ret < 0) {
>>> 		dev_err(&pdev->dev, "failed to find platform data\n");
>>> 		return ret;
>>> 	}
>>>
>>> 	data = &defdata;
>>> }
>>> -------
>>>
>>> This looks like if we set the platform data for pwm backlight device,
>>> "pwm_backlight_parse_dt" will never have a chance to be called, which
>>> means the stuffs I defined in backlight DT node will be ignored.
>>>
>>> If I don't set the platform data for pwm backlight device, according to
>>> the pwm_backlight_probe, I will never have a chance to set some fops
>>> which I need(like "notify", "check_fb"...).
>>>
>>> So, what I suppose to do now? Maybe there is a way to set function
>>> pointers in DT?
>>
>> Perhaps you could describe in more detail what you need the functions
>> for.
>>
> 
> Okay, I just want to set the "notify" function pointer in "struct
> platform_pwm_backlight_data", because I want to tune the brightness
> value before the pwm-bl sets the brightness to hardware. I don't know
> how to do that, unless we define the platform data explicitly.
> 
> Mark
>> Generally you're not supposed to mix DT and platform data. Without more
>> info that's about all I can say.
>>
>> Thierry
>>
