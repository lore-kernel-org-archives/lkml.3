Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaCNTdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:33:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40724 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871AbaCNTdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:33:47 -0400
Message-ID: <53235980.30909@ti.com>
Date: Fri, 14 Mar 2014 14:33:20 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Rob Herring <robh@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>, Suman Anna <s-anna@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 4/5] clocksource: omap-timer: Introduce clocksource driver
 for OMAP SoCs
References: <1394742919-32163-1-git-send-email-joelf@ti.com> <1394742919-32163-5-git-send-email-joelf@ti.com> <20140313204851.GB23432@atomide.com> <532243F5.4040609@ti.com> <20140314155202.GA27560@atomide.com> <53235963.4080503@ti.com>
In-Reply-To: <53235963.4080503@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 02:32 PM, Joel Fernandes wrote:
> On 03/14/2014 10:52 AM, Tony Lindgren wrote:
>> * Joel Fernandes <joelf@ti.com> [140313 16:52]:
>>> On 03/13/2014 03:48 PM, Tony Lindgren wrote:
>>>> * Joel Fernandes <joelf@TI.com> [140313 13:43]:
>>>>> We introduce functions to initialize clocksource and clockevent, use
>>>>> CLOCKSOURCE_OF_DECLARE to declare the clocksource, and handle the clocksource
>>>>> selection on a per-SoC basis (Currently only AM335x is supported). Powering up
>>>>> of the timer will be done with the help of the mach-omap layer function that's
>>>>> introduced earlier in the series.
>>>>>
>>>>> We make a local copy of dmtimer API for use by clocksource, the original
>>>>> dmtimer API in plat-omap is kept as-is till the migration of all SoCs is
>>>>> completed after which it can't be deleted.
>>>>>
>>>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>>>> ---
>>>>>  drivers/clocksource/Makefile     |    1 +
>>>>>  drivers/clocksource/omap-timer.c | 1157 ++++++++++++++++++++++++++++++++++++++
>>>>>  drivers/clocksource/omap-timer.h |  422 ++++++++++++++
>>>>>  3 files changed, 1580 insertions(+)
>>>>>  create mode 100644 drivers/clocksource/omap-timer.c
>>>>>  create mode 100644 drivers/clocksource/omap-timer.h
>>>>
>>>> Hmm this leaves duplicate arch/arm/plat-omap/dmtimer.c code, please
>>>
>>> Sure, ofcourse- but how else can we make sure everything works while we do
>>> the migration in steps. We can get rid of the duplicate once everything is
>>> migrated.
>>
>> That's not doing incremental changes then. You're not even modifying
>> the existing omap_dm_timer functions, so please do the changes in incremental
>> steps where things keep working throughout the series.
> 
> That is much more work than appears- it is much easier to remove what you
> don't want after everything is moved, than to pick things up part by part
> and move it.. That way we also don't accidentally remove something we
> shouldn't be and introduced more regressions.. right?
> 
> Plus this is an RFC that I whipped up in 2 days so I didn't this
> expectations should be too high ;-)

s/this/think/

