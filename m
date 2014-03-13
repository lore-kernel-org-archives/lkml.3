Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaCMXti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:49:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37386 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbaCMXtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:49:36 -0400
Message-ID: <532243F5.4040609@ti.com>
Date: Thu, 13 Mar 2014 18:49:09 -0500
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
References: <1394742919-32163-1-git-send-email-joelf@ti.com> <1394742919-32163-5-git-send-email-joelf@ti.com> <20140313204851.GB23432@atomide.com>
In-Reply-To: <20140313204851.GB23432@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:48 PM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@TI.com> [140313 13:43]:
>> We introduce functions to initialize clocksource and clockevent, use
>> CLOCKSOURCE_OF_DECLARE to declare the clocksource, and handle the clocksource
>> selection on a per-SoC basis (Currently only AM335x is supported). Powering up
>> of the timer will be done with the help of the mach-omap layer function that's
>> introduced earlier in the series.
>>
>> We make a local copy of dmtimer API for use by clocksource, the original
>> dmtimer API in plat-omap is kept as-is till the migration of all SoCs is
>> completed after which it can't be deleted.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  drivers/clocksource/Makefile     |    1 +
>>  drivers/clocksource/omap-timer.c | 1157 ++++++++++++++++++++++++++++++++++++++
>>  drivers/clocksource/omap-timer.h |  422 ++++++++++++++
>>  3 files changed, 1580 insertions(+)
>>  create mode 100644 drivers/clocksource/omap-timer.c
>>  create mode 100644 drivers/clocksource/omap-timer.h
> 
> Hmm this leaves duplicate arch/arm/plat-omap/dmtimer.c code, please

Sure, ofcourse- but how else can we make sure everything works while we do
the migration in steps. We can get rid of the duplicate once everything is
migrated.

> sort out that issue too by allowing omap1 and omap3 still to use
> the legacy timer init functions but with timer code under
> drivers/clocksource/omap-timer.c.

Sorry, I didn't follow. I didn't see OMAP3 using legacy timer stuff. To me
it looks like OMAP3 migration should be straight forward along the same
lines as this RFC patchset. Could you elaborate a bit more what the legacy
functions you mentioned for OMAP1 are? I will just like to keep everything
in drivers/clocksource/ private for now till we're done migrating most
platforms. IMO once we get system timers working for omap2+, then we can
look into omap1 :)

> And not the that drivers/clocksource/omap-timer.h won't be needed at
> all, those defines can stay private to the drivers/clocksource/omap-timer.c.

Actually- I wanted it separate because omap-timer.c is already huge at 1157
lines. Infact the largest among the clocksource drivers. Is that fair?

> So this patch really should just be moving of the code to the new
> location.

To be honest, its not just a simple moving of code, there are new things
such as selecting correct timer, new functions for clockevent and
clocksource init, different handling of clocks etc.

Thanks,
-Joel
