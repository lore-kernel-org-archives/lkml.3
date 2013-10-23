Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3JWKgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:36:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50315 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3JWKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:36:11 -0400
Message-ID: <5267A691.8050503@gmail.com>
Date: Wed, 23 Oct 2013 18:36:01 +0800
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
References: <525F8895.5010806@gmail.com> <20131017071445.GA2502@ulmo.nvidia.com> <5260BD8C.7000200@gmail.com> <20131022072443.GB8681@ulmo.nvidia.com> <52663D6D.5000806@gmail.com> <20131022124905.GA24255@ulmo.nvidia.com> <52673178.8070805@gmail.com> <20131023080002.GB7404@ulmo.nvidia.com> <52678D99.8090003@gmail.com> <20131023090925.GC11954@ulmo.nvidia.com>
In-Reply-To: <20131023090925.GC11954@ulmo.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 05:09 PM, Thierry Reding wrote:
> On Wed, Oct 23, 2013 at 04:49:29PM +0800, Mark Zhang wrote:
>> On 10/23/2013 04:00 PM, Thierry Reding wrote:
>>> On Wed, Oct 23, 2013 at 10:16:24AM +0800, Mark Zhang wrote:
>>>> On 10/22/2013 08:49 PM, Thierry Reding wrote:
>>>>> On Tue, Oct 22, 2013 at 04:55:09PM +0800, Mark Zhang wrote:
>>>>>> On 10/22/2013 03:24 PM, Thierry Reding wrote:
>>>>>>> On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
>>>>>> [...]
>>>>>>>>>
>>>>>>>>
>>>>>>>> Okay, I just want to set the "notify" function pointer in "struct
>>>>>>>> platform_pwm_backlight_data", because I want to tune the brightness
>>>>>>>> value before the pwm-bl sets the brightness to hardware. I don't know
>>>>>>>> how to do that, unless we define the platform data explicitly.
>>>>>>>
>>>>>>> Okay, my question should have been what you need the functions for and
>>>>>>> why you think you need them.
>>>>>>>
>>>>>>
>>>>>> If I understanding you correctly, I suppose I've said that: "because I
>>>>>> want to tune the brightness value before the pwm-bl sets the brightness
>>>>>> to hardware".
>>>>>
>>>>> Why do you want to tune the brightness value? What are you trying to
>>>>> achieve?
>>>>>
>>>>
>>>> Oh, Tegra has a feature named PRISM(aka SmartDimmer). It changes the
>>>> color value to make the display looks bright so that we can reduce the
>>>> backlight brightness to save power. So everytime PRISM is triggered, we
>>>> call "backlight_update_status", then in the "notify" callback, we change
>>>> the brightness value which pwm-bl provides by considering the PRISM
>>>> compensations.
>>>
>>> If you automatically call backlight_update_status() everytime PRISM
>>> gives you new data, can't you just pass the correct value in in the
>>> first place so that you don't have to tweak it in the .notify()
>>> callback?
>>
>> OK, how to do that? -- "pass the correct value in in the first place"?
> 
> Well, if you call backlight_update_status(), then you can pass in a
> brightness value, right? You usually do that by setting the backlight's
> props.brightness field.
> 
> So when PRISM gives you new data, you could just read out the current
> brightness, compute the new one based on the current one and the PRISM
> data, set the props.brightness field to that value and then call
> backlight_update_status().
> 

Okay, anyway, I got the idea. Actually it's simpler. :)
I'm just curious that if we can do that in this way, why we need
"notify" anymore?

Mark
> Thierry
> 
