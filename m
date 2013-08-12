Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3HLQoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:44:17 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39536 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3HLQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:44:16 -0400
Message-ID: <520910DA.4000203@gmail.com>
Date: Mon, 12 Aug 2013 18:44:10 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Alexander Shiyan <shc_work@mail.ru>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/3] ARM: Introduce atomic MMIO clear/set
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com> <20130810140237.GB3080@localhost> <20130810140927.GC3080@localhost> <1376149388.716003514@f150.i.mail.ru> <20130810155552.GB17936@localhost> <20130812154646.GA5460@localhost>
In-Reply-To: <20130812154646.GA5460@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/13 17:46, Ezequiel Garcia wrote:
>> Indeed, syscon looks like a nice match for this use case.
>> (although it still looks like an overkill to me).
>>
>> I've been trying to implement a working solution based in syscon but I'm
>> unable to overcome an issue.
>>
>> The problem is that we need the register/regmap to initialize the clocksource
>> driver for this machine (aka the timer). Of course, this happens at a
>> *very* early point, way before the syscon driver is available... :-(
>>
>> Maybe someone has an idea?
>
> Sebastian, Russell: I can't find the previous mail where you proposed
> this solution to address the shared register issue between Kirkwood's
> watchdog and clocksource.

Russell first mentioned an atomic modify function here:
http://archive.arm.linux.org.uk/lurker/message/20130618.113606.d7d4fe4b.en.html

Linus Walleij already suggested mfd/syscon as a container
for protected register accesses later.

> Is this what you had in mind?

The pro of a generic atomic clear/set is that we can use it
very early, on all platforms, and from totally unrelated
drivers. As you already mentioned, using syscon from timers will
get us into into trouble, because it has not been registered.

> Do you think trying to use a regmap could be better (given we can
> sort out the problem explained above)?

Given the small number of registers we need to protect and especially
for using it in timers, I'd prefer your proposal. Otherwise, I guess,
we would have to mimic mfd/syscon for time-orion and time-armada-370-xp
and make wdt-orion depend on it. I doubt we can make any use of
mfd/syscon for the timer use case.

Sebastian
