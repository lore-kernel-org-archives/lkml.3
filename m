Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437Ab3BNBa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:30:29 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34648 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3BNBa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:30:28 -0500
Message-ID: <511C3E32.9010709@gmail.com>
Date: Wed, 13 Feb 2013 19:30:26 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/4] clocksource: pass DT node pointer to init functions
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <1360264144-20714-2-git-send-email-robherring2@gmail.com> <CAHTX3dKLCbfhBaHKBE=fVTcRReVL6yotA9e_8S70bH+_gajL5Q@mail.gmail.com> <511BC043.4030506@gmail.com> <CAHTX3d+2rGBE3ZBwiHbq7tOi+OE+5KGPh34APzp0NhRP=mBv+w@mail.gmail.com>
In-Reply-To: <CAHTX3d+2rGBE3ZBwiHbq7tOi+OE+5KGPh34APzp0NhRP=mBv+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 11:33 AM, Michal Simek wrote:
> 2013/2/13 Rob Herring <robherring2@gmail.com>:
>> On 02/13/2013 10:21 AM, Michal Simek wrote:
>>> 2013/2/7 Rob Herring <robherring2@gmail.com>:
>>>> From: Rob Herring <rob.herring@calxeda.com>
>>>>
>>>> In cases where we have multiple nodes of the same type, we may need the
>>>> node pointer to know which node was matched. Passing the node pointer
>>>> also keeps the init function from having to match the node a 2nd time.
>>>>
>>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>>> Cc: John Stultz <johnstul@us.ibm.com>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> ---
>>>>  drivers/clocksource/clksrc-of.c |    4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> Tested-by: Michal Simek <michal.simek@xilinx.com>
>>>
>>> The rest is just the same as I have done. Any option to add these
>>> patches to v3.9?
>>
>> I would like to before we have more users to fix, but it will have to be
>> post rc1. If not, Arnd/Olof should be be able to provide a stable branch
>> for 3.10.
> 
> ok

I now see you were trying to get zynq changes in for 3.9. You could add
this patch to your pull request. As is, it is not dependent on some DT
code changes, but the subsequent patches are. I can send the rest after
rc1. It's a bit of a hack with the function call prototype, but nothing
actually breaks. I was going to combine as Arnd suggested, but either
way is probably fine.

> 
>>> Because I need these patches for zynq timer because we have two in the soc.
>>> Is it OK to register several clock source and clockevent devices?
>>
>> If it is 1 DT node, then that should be fine.
> 
> zynq is using two triple timer counter IP . There are also described by two
> different DT nodes because there are separated and uses different baseaddresses.
> 
> Does it mean that if there are 2 DT nodes that it won't work?
> 
> 
> One more thing. Is there any rule which should describe which timer should be
> used for clockevent and for clocksource?

No. This is a common problem. A simple solution is a "linux,clockevent"
property, but I want to avoid that. Ultimately it is some feature of the
h/w that makes you choose. This could be it has an interrupt or not,
higher frequency, has timer compare pins, gets power gated, etc. So you
should describe enough of the h/w properties to make this decision. OMAP
is an example doing this with lots of timers with varying integration
level differences.

Rob

> 
> 
>>> btw: there is still one issue because you can just setup only one
>>> compatibility string.
>>
>> You can have multiple CLOCKSOURCE_OF_DECLARE statements. The gic code
>> does this for irqchips.
> 
> Ok. Will look at it.
> 
> Thanks,
> Michal
> 
> 

