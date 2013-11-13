Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab3KMKSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:18:39 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:64807 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3KMKSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:18:35 -0500
Message-ID: <528351F9.3040101@linaro.org>
Date: Wed, 13 Nov 2013 11:18:33 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaQ==?= =?UTF-8?B?Zw==?= 
	<u.kleine-koenig@pengutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: 3.12 fixes
References: <528234B9.7080402@linaro.org> <20131112183553.GQ14892@pengutronix.de> <alpine.DEB.2.02.1311122316270.30673@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1311122316270.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 11:57 PM, Thomas Gleixner wrote:
> On Tue, 12 Nov 2013, Uwe Kleine-König wrote:
>> On Tue, Nov 12, 2013 at 03:01:29PM +0100, Daniel Lezcano wrote:
>>>
>>> Hi Ingo and Thomas,
>>>
>>> this pull request has the following contain:
>>>
>>>   * Laurent Pinchard fixed a missing a clk_put in case the
>>> registering of the sh_mtu[2] drivers fails.
>>>
>>>   * Uwe Kleine-König reuse clockevents_config_and_register for the
>>> at91rm9200_time timer as it was depending on the patch (commit
>>> a4578ea (clockevents: Sanitize ticks to nsec conversion).
>>>
>>> I don't know why Thomas's patch "clockevents: Sanitize ticks to nsec
>>> conversion" appears in the request log because it is not part of the
>>> patches interval I specified for git request pull. The diffstat does
>>> not show the files which should have been changed by the patch. In
>>> any case I kept the changelog untouched since it is what gives me
>>> git and maybe someone can tell me why it appears.
>> Look at:
>>
>> 	git log --oneline --graph --boundary 97b9410..42ab380
>>
>> Then you see that there is Thomas' patch twice. Once the version he
>> committed and sent to Linus (97b9410) and once the version that you get
>> as part of my pull request (a4578ea). To fix this (assuming you don't
>> care much about a stable tree), simply do:
>>
>> 	git rebase 97b9410 42ab380
>>
>> and let the result pull.
>
> The whole misery starts that you decided to play maintainer and grab
> some patches from the mailinglist and then offering them via a pull
> request to me and others. Finally you tricked Daniel to take them,
> which is a different issue.
>
> There is a reason why I ignored that pull request:
>
>   I generally do not pull git trees from people who I'm not
>   trusting. And I have good reasons not to trust you at all.
>
> Aside of that, I decided to give you a chance and actually pulled
> your tree into a temporary branch and found out that it's missing a
> stable annotation. Which made the whole exercise go into /dev/null
>
> Now Linus pulled my version way before Daniel pulled your tree into
> his. And you even commented on my commit that I forgot to add a
> tested-by tag. Yes, I missed that in favour of the stable annotation.
>
> But instead of rebasing your tree or even just withdrawing it and
> resending the at91 patch, you let Daniel pull your thing.
>
> Of course Daniel failed to detect the pointless commit in your pull
> request at the point of merging it and then he starts asking questions
> when he sends the pull request for his aggregated stuff ....
>
> There is a good reason why most maintainers have a strict policy from
> whom they are pulling from and from whom they are just accepting
> patches by mail.
>
> Daniel, please provide me a rebased version, but be more careful
> versus integration of random pull requests next time.

    Yes I will. Thanks for catching this.

I overwrote my branch with a rebased version.

The following changes since commit 97b9410643475d6557d2517c2aff9fd2221141a9:

   clockevents: Sanitize ticks to nsec conversion (2013-10-23 12:51:21 
+0200)

are available in the git repository at:

   git://git.linaro.org/people/dlezcano/linux.git clockevents/fixes

for you to fetch changes up to f578caebe38b87e7923cc03fb135d1e759912709:

   clocksource: sh_tmu: Add clk_prepare/unprepare support (2013-11-13 
11:06:50 +0100)

----------------------------------------------------------------
Laurent Pinchart (4):
       clocksource: sh_mtu2: Release clock when sh_mtu2_register() fails
       clocksource: sh_mtu2: Add clk_prepare/unprepare support
       clocksource: sh_tmu: Release clock when sh_tmu_register() fails
       clocksource: sh_tmu: Add clk_prepare/unprepare support

Uwe Kleine-König (1):
       ARM: at91: rm9200: switch back to clockevents_config_and_register

  arch/arm/mach-at91/at91rm9200_time.c |    7 ++-----
  drivers/clocksource/sh_mtu2.c        |   16 ++++++++++++++--
  drivers/clocksource/sh_tmu.c         |   20 +++++++++++++++++---
  3 files changed, 33 insertions(+), 10 deletions(-)



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

