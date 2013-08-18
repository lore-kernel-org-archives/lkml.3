Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3HRVVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:21:13 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36700 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3HRVVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:21:11 -0400
Message-ID: <521156EF.3090201@gmail.com>
Date: Mon, 19 Aug 2013 01:21:19 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 0/5] ARM: Initial support for Marvell Armada 1500
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <201308172132.59402.arnd@arndb.de>
In-Reply-To: <201308172132.59402.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 09:32 PM, Arnd Bergmann wrote:
> On Friday 16 August 2013, Sebastian Hesselbarth wrote:
>> This is a RFC adding initial support for the Marvell Armada 1500
>> (88DE3100) found on various consumer devices (Chromecast, GoogleTV).
>>
>> Actually, it is a two-fold RFC also raising discussions on mach-mvebu
>> cleanup roadmap to allow other SoCs to hop into it. While mach-mvebu
>> originally was created to add support for Armada 370/XP and merge
>> existing Marvell Orion familiy into it, I am not so sure about
>> Armada 1500 fits that well (the mbus has gone!).
>>
>> If you are brave enough to try this on any GoogleTV, hit Google for
>> instructions on how to get a unlocked u-boot and void your warranty :)
>> The patches are based on v3.11-rc5 directly.
>>
>> This cover letter and the separate patches have also been Cc'd to the
>> respective maintainers to clear up some questions before posting a real
>> patch set.
>
> Great stuff!

Thanks! I thought you'd be interested in this, so I Cc'd you :)

> Regarding the question about the directory, is there going to be any
> shared code with the files present in mach-mvebu, e.g. the SMP support
> that I assume is planned for a later point?

I must admit, I never had a close look at the gory early start-up
internals, so all of this is quite new to me. Of course, I plan to
use both cores and therefore add SMP.

> If there is shared code, it's probably best to have it in here. Otherwise
> I don't care either way: We have precedent for fairly unrelated platforms
> (ev2+shmobile, or the mach-bcm) being in the same directory for practical
> reasons, and you can also create an almost empty directory now as we are
> likely going to consolidate all "trivial" platforms in the future. Once
> the l2x0 and clock init code as well as the early mapping has been
> addressed, there won't be any platform code left.

As Thomas already mentioned, Armada 1500 doesn't fit mach-mvebu exactly
because it's from a different business unit within Marvell. And it is
kind of different from what I expected, most notably register addresses
are really different (see mvebu.S).

We either put it into mach-mvebu and pretend to consolidate Marvell SoCs
in there. Pro would be that it is close to other Armadas there, con is
that Armada is codename for virtually any Marvell SoC lately.

If we want a new mach- directory, I'd suggest either mach-berlin which
looks like some nickname for 88de3xxx SoCs or simply boring
mach-88de3xxx.

Sebastian
