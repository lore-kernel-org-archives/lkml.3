Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778Ab3BNOW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:22:57 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40964 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3BNOW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:22:56 -0500
Message-ID: <511CF33C.3020402@gmail.com>
Date: Thu, 14 Feb 2013 08:22:52 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH 1/4] clocksource: pass DT node pointer to init functions
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <1360264144-20714-2-git-send-email-robherring2@gmail.com> <CAHTX3dKLCbfhBaHKBE=fVTcRReVL6yotA9e_8S70bH+_gajL5Q@mail.gmail.com> <511BC043.4030506@gmail.com> <CAHTX3d+2rGBE3ZBwiHbq7tOi+OE+5KGPh34APzp0NhRP=mBv+w@mail.gmail.com> <511C3E32.9010709@gmail.com> <CAHTX3dKcnkjOTY5yyBSwcUH0Rxz+L9ZROeaemMYLexW50Z7Eng@mail.gmail.com>
In-Reply-To: <CAHTX3dKcnkjOTY5yyBSwcUH0Rxz+L9ZROeaemMYLexW50Z7Eng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 12:45 AM, Michal Simek wrote:
> 2013/2/14 Rob Herring <robherring2@gmail.com>:
>> On 02/13/2013 11:33 AM, Michal Simek wrote:
>>> 2013/2/13 Rob Herring <robherring2@gmail.com>:
>>>> On 02/13/2013 10:21 AM, Michal Simek wrote:
>>>>> 2013/2/7 Rob Herring <robherring2@gmail.com>:
>>>>>> From: Rob Herring <rob.herring@calxeda.com>
>>>>>>


>>> One more thing. Is there any rule which should describe which timer should be
>>> used for clockevent and for clocksource?
>>
>> No. This is a common problem. A simple solution is a "linux,clockevent"
>> property, but I want to avoid that.
> 
> Let me describe it a little bit more. I am going to change current
> mainline implementation
> for zynq timer which uses special compatible string to define
> clocksource and clockevent
> device. I don't think this is right way to go because compatible
> string shouldn't point
> to device usage. Which is exact case you wanted to avoid.
> 
>> Ultimately it is some feature of the
>> h/w that makes you choose. This could be it has an interrupt or not,
>> higher frequency, has timer compare pins, gets power gated, etc. So you
>> should describe enough of the h/w properties to make this decision.
> 
> For different timer type, kernel should decide which timer should be
> used. It should be easy to test
> because I can add some timers to the programmable logic (as is done
> for Microblaze) and check
> how kernel decide which clocksource/clockevent device will use. I
> believe there is any logic around.
> 
> 
> For solution with two instances of the same triple timer counters it
> is impossible
> to specify additional h/w property because all of 6 timers are the same.
> And also adding special parameter to IP goes against rule
> that device-tree should describe hw not Linux usage.
> Maybe enough to save information to driver that clocksource and
> clockevent device is registered
> and do not try to register another timer (and also another timer from
> another instance).

So if you don't care which one is used, then use the first one found and
be done with it. You will have to make your init function just return on
subsequent calls.

> 
> Or maybe it can be done via chosen property or via aliases property where
> timer0 alias is that one who should be used for clocksource and
> clockevent device.
> (for my case alias to one instance of triple timer counter).
> 
> I saw some dtses which have aliases timer.
> 
> How good/bad is this option?

It's best if you can avoid aliases IMO.

> 
> 
>> OMAP
>> is an example doing this with lots of timers with varying integration
>> level differences.
> 
> Can you point me that that omap drivers you are talking about?

arch/arm/mach-omap2/timer.c. They have properties such as always on and
secure mode.

Rob

