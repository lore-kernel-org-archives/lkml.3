Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3KRQ3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 11:29:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36181 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab3KRQ3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 11:29:46 -0500
Message-ID: <528A4015.5040405@ti.com>
Date: Mon, 18 Nov 2013 18:28:05 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <wim@iguana.be>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <galak@kernel.crashing.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: Fwd: [PATCH 4/8] watchdog: davinci: add GET_STATUS option support
References: <1383680783-12114-5-git-send-email-ivan.khoronzhuk@ti.com> <527A28CE.2070802@ti.com> <528828E7.6060404@roeck-us.net> <528A2252.7040605@ti.com> <20131118162426.GA15610@roeck-us.net>
In-Reply-To: <20131118162426.GA15610@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 06:24 PM, Guenter Roeck wrote:
> On Mon, Nov 18, 2013 at 04:21:06PM +0200, ivan.khoronzhuk wrote:
>> On 11/17/2013 04:24 AM, Guenter Roeck wrote:
>>> On 11/06/2013 03:32 AM, ivan.khoronzhuk wrote:
>>>> When watchdog timer is expired we can know about it thought
>>>
>>> thought -> through or with
>>>
>>
>> Ok
>>
>>>> GET_STATUS ioctl option.
>>>>
>>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>>> ---
>>>>    drivers/watchdog/davinci_wdt.c |   13 +++++++++++++
>>>>    1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/drivers/watchdog/davinci_wdt.c
>>>> b/drivers/watchdog/davinci_wdt.c
>>>> index 6cbf2e1..a371b2d 100644
>>>> --- a/drivers/watchdog/davinci_wdt.c
>>>> +++ b/drivers/watchdog/davinci_wdt.c
>>>> @@ -144,6 +144,18 @@ static unsigned int
>>>> davinci_wdt_get_timeleft(struct watchdog_device *wdd)
>>>>        return wdd->timeout - timer_counter;
>>>>    }
>>>>
>>>> +static unsigned int davinci_wdt_status(struct watchdog_device *wdd)
>>>> +{
>>>> +    u32 val;
>>>> +    struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
>>>> +
>>>> +    val = ioread32(davinci_wdt->base + WDTCR);
>>>> +    if (val & WDFLAG)
>>>> +        return WDIOF_CARDRESET;
>>>> +
>>>       "Card previously reset the CPU"
>>>
>>> Is this really accurate / correct ?
>>>
>>> My understanding is that the status is supposed to return the reason for
>>> a previous reset/reboot,
>>> not the curent condition.
>>>
>>
>> Actually it is not so good correlate with the purpose, but I grasped
>> several examples like watchdog/pcwd.c; watchdog/w83977f_wdt.c;
>> watchdog/of_xilinx_wdt.c and saw that I can use it in meaning "the card initiated reset.
>> After the WDT is overflowed it sets WDFLAG, so I can use it.
>> It is more useful while debugging and if it is doubtful I can drop it.
>>
> The usual reaction to a watchdog timer event is a reset, so I am somewhat
> doubtful if this is of any use in practice, other than maybe to show that it
> isn't working.
>
> Anyway, I always dislike it when people point out other wrong usages of an API
> (or anything, really) as argument to do the same. Speeding isn't legal either,
> no matter how many people do it. FWIW, the wrong usages you pointed out should
> in my opinion be removed, and if Wim agrees I'll be happy to submit patches to
> do it.
>
> If you need debugging information, there is always debugfs. There should be
> no need to hijack an API which is supposed to be used for something else.
>
> Guenter
>

I'll drop it

-- 
Regards,
Ivan Khoronzhuk
