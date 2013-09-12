Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3ILQjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:39:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49556 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3ILQjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:39:37 -0400
Message-ID: <5231EE43.5090900@arm.com>
Date: Thu, 12 Sep 2013 17:39:31 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: cinifr <cinifr@gmail.com>
CC: Mark Rutland <Mark.Rutland@arm.com>, "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for clocksource
 in ARMv7.
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com> <1378968687-8200-4-git-send-email-cinifr@gmail.com> <20130912112452.GA22013@e106331-lin.cambridge.arm.com> <CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com>
In-Reply-To: <CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 12 Sep 2013 16:39:32.0723 (UTC) FILETIME=[A89FCC30:01CEAFD6]
X-MC-Unique: 113091217393402101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/13 17:07, cinifr wrote:
>> This cannot be a compile-time option as above in a multiplatform build.
>> Other paltforms (e.g. KVM guests) *must* use the virtual counters to get
>> any semblance of a consistent view of time.
> Yes I accept compile-time option is not perfect  in my pre email,
> But,Why Ohter paltforms *must* use the virtual counters? I think KVM
> should not limit how to use arch timer in its guest OS. Of cause, if
> KVM guest use vct can be more efficiency then that use pct. but KVM
> should and must support guest OS to access pct.

The virtual counter is there for a good reason: it allows a virtual
machine to:
- see its time starting at zero
- be migrated to another host without seeing time shifting one way or
another.

So using the physical counter in a VM is a recipe for disaster if you're
doing any kind of time tracking. The counter being used for
sched_clock(), we cannot afford to see it being shifted one way or another.

If you have issues with the use of the virtual counter, I suggest you
fix your firmware to have a consistent CNTVOFF across CPUs. And/or even
better, boot your kernel in HYP mode, as it will take care of setting
CNTVOFF to zero.

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

