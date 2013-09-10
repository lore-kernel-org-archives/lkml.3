Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3IJTpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:45:00 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46906 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3IJTo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
References: <10005394.BRCyBMYWy3@tauon>
	<CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
Date: Tue, 10 Sep 2013 12:44:56 -0700
X-Google-Sender-Auth: dNCoYQa5hNQBMCmCi62gX9o4Mbc
Message-ID: <CANcMJZAaDBW2y+xqGrWCwbvpFpbbjd8SV6aSc3T5Z0NSRiXZ+A@mail.gmail.com>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
From: John Stultz <john.stultz@linaro.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 12:38 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Tue, Sep 10, 2013 at 4:31 AM, Stephan Mueller <smueller@chronox.de> wrote:
>> Hi,
>>
>> /dev/random uses the get_cycles() function to obtain entropy in addition to jiffies and the event value of hardware events.
>>
>> Typically the high-resolution timer of get_cycles delivers the majority of entropy, because the event value is quite deterministic and jiffies are very coarse.
>>
> [snip]
>> The following patch uses the clocksource clock for a time value in case get_cycles returns 0. As clocksource may not be available during boot time, a flag is introduced which allows random.c to check the availability of clocksource.

Also, note that at the end of timekeeping_init(), we may not have been
able to access the RTC (as some RTCs require interrupts to access), so
on those systems getnstimeofday() may return something close to 0
until the RTC subsystem initializes and sets the current wall time.

thanks
-john
