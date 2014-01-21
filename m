Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaAUTBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:01:47 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:35900 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaAUTBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:01:45 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 14:01:45 EST
Message-ID: <52DEC237.9080404@jolla.com>
Date: Tue, 21 Jan 2014 20:53:43 +0200
From: Kalle Jokiniemi <kalle.jokiniemi@jolla.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@ring0.de>, Pavel Machek <pavel@ucw.cz>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com> <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com> <20140120164926.GB23051@amd.pavel.ucw.cz> <20140120171010.GB29971@arm.com> <20140120175431.GB25439@amd.pavel.ucw.cz> <20140120182532.GB25920@earth.universe>
In-Reply-To: <20140120182532.GB25920@earth.universe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20.01.2014 20:25, Sebastian Reichel wrote:
> On Mon, Jan 20, 2014 at 06:54:32PM +0100, Pavel Machek wrote:
>> On Mon 2014-01-20 17:10:29, Catalin Marinas wrote:
>>> On Mon, Jan 20, 2014 at 04:49:26PM +0000, Pavel Machek wrote:
>>>>> To save energy, the higher frequencies should be avoided and only used
>>>>> when the application performance requirements can not be satisfied
>>>>> otherwise (e.g. spread tasks across more cpus if possible).
>>>>
>>>> I argue this is untrue for any task where user waits for its
>>>> completion with screen on. (And that's quite important subset).
>>>>
>>>> Lets take Nokia n900 as an example.
>>>>
>>>> (source http://wiki.maemo.org/N900_Hardware_Power_Consumption)
>>>>
>>>> Sleeping CPU: 2mA
>>>> Screen on: 230mA
>>>> CPU loaded: 250mA
>>>>
>>>> Now, lets believe your numbers and pretend system can operate at 33%
>>>> of speed with 11% power consumption.
>>>>
>>>> Lets take task that takes 10 seconds on max frequency:
>>>>
>>>>        ~ 10s * 470mA     	     	    = 4700mAs
>>>>
>>>> You suggest running at 33% speed, instead; that means 30 seconds on
>>>> low requency.
>>>>
>>>> CPU on low: 25mA (assumed).
>>>>
>>>>       ~ 30s * 255mA			    = 7650mAs
>>>>
>>>> Hmm. So race to idle is good thing on Intel machines, and it is good
>>>> thing on ARM design I have access to.
>>>
>>> Race to idle doesn't mean that the screen goes off as well. Let's say
>>> the screen stays on for 1 min and the CPU needs to be running for 10s
>>> over this minute, in the first case you have:
>>
>> No, it does not. I just assumed user is continuing to use his
>> machine. Obviously, waiting 60 seconds with screen on will make the
>> difference look smaller. But your solution still means user has to
>> wait longer _and_ you consume more battery doing so.
>>
>> And this is for any task where user waits for result with screen
>> on. Like rendering a webpage. Like opening settings screen. Like
>> installing application.
>>
>> There are not too many background tasks on a cellphone.
>>
>> But hey, maybe you are right and running at lowest possible frequency
>> is right. Please provide concrete numbers like I did.
>
> So what about using the display status information for power
> management? Basically always using the lowest frequency should be ok
> on phones if the display is disabled?

Well, not really. There are a looot of devices running linux kernel, and 
there are always devices and use cases that can't operate if you 
hardcode something like that.

It is good to know what the problematic use cases are, but it usually 
does not end well if you optimize for specifics. End users are 
unpredictable in ways they utilize their devices :)

And these days audio playback power optimization in smart phones is 
mostly for the product spec marketing purposes anyways :P

I think the discussion has been going into right direction:
- find what data we have to make better decisions
- find ways to utilize that data

And then in the end the big smart phone manufacturers will twist that to 
their use cases in horrible ways to meet product specs on tight 
schedules :D But at least the starting point will be closer to target.

Even on N900 dvfs is beneficial for audio playback. But it was not 
because of CPU consuming less, it was because the peripheral bus 
frequency was tied to CPU frequency. There we ended up removing a very 
low 125MHz cpu operating point so that the device ran at highest 
possible 250MHz CPU rate (to idle quickly) while still keeping the lower 
peripheral bus speed.

So we raced to idle and used DVFS.. how nice :)

- Kalle

>
> -- Sebastian
>
