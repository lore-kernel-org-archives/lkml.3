Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3A1K5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:57:47 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:59634 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751638Ab3A1K5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:57:44 -0500
Message-ID: <510659A3.7070906@epfl.ch>
Date: Mon, 28 Jan 2013 11:57:39 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pwm: Add pwm_cansleep() as exported API to users
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch> <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch> <20130126054024.GB29243@avionic-0098.adnet.avionic-design.de> <51063AB5.2060108@ti.com> <51064687.5090605@epfl.ch> <20130128095754.GA23134@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130128095754.GA23134@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/01/2013 10:57, Thierry Reding a écrit :
> On Mon, Jan 28, 2013 at 10:36:07AM +0100, Florian Vaussard wrote:
>> Hello,
>>
>> Le 28/01/2013 09:45, Peter Ujfalusi a écrit :
>>> hi Thierry,
>>>
>>> On 01/26/2013 06:40 AM, Thierry Reding wrote:
> [...]
>>>>> +{
>>>>> +	return pwm->chip->can_sleep;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(pwm_cansleep);
>>>>
>>>> Would it make sense to check for NULL pointers here? I guess that
>>>> passing NULL into the function could be considered a programming error
>>>> and an oops would be okay, but in that case there's no point in making
>>>> the function return an int. Also see my next comment.
>>>
>>> While it is unlikely to happen it is better to be safe, something like this
>>> will do:
>>>
>>> return pwm ? pwm->chip->can_sleep : 0;
>>>
>>
>> Ok. And what about:
>>
>> BUG_ON(pwm == NULL);
>> return pwm->chip->can_sleep;
>
> I don't think we need that. In case pwm == NULL, dereferencing it will
> oops anyway. So either we make it safe and return an error code, or we
> let it oops without explicit BUG_ON().
>

Calling this function with a NULL pointer is a programming error, so there
is no error codes for such errors. I propose to return bool, and let it
oops if such case happens.

Regards,

Florian
