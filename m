Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3KEM0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:26:04 -0500
Received: from mail.eperm.de ([89.247.134.16]:56329 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab3KEMZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:25:49 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 05 Nov 2013 13:25:40 +0100
Message-ID: <4763730.CsXSbevC1J@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131103233207.GA5105@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon> <3537770.iLHXPOXMiU@tauon> <20131103233207.GA5105@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. November 2013, 00:32:07 schrieb Pavel Machek:

Hi Pavel,

>Hi!
>
>> Another friend of mine mentioned that he assumes the rise and fall
>> times of transistors varies very slightly and could be the main
>> reason for the jitter. I do not think that this is really the case,
>> because our gates that form the CPU instructions comprise of many
>> transistors. The combined raise/fall jitter should cancel each other
>> out.
>
>Plus, there's clock that should make sure that this jitter does not
>matter.
>
>> >There should be way to extract entropy more directly from various
>> >oscillator effects, no?
>> 
>> I am working a different way of measuring such oscillator effects by
>> using the high-resolution timer of the CPU and measure it with a
>> Jiffies-based snapshotting window. So, here I would combine two
>> timers
>> that are differently generated. If their frequencies would be
>> relative
>> prime to each other, we would measure a direct oscillator effect.
>
>I guess main problem is machines that do not have high-resolution
>timer on the CPU (rdtsc). They do not get enough entropy during boot,
>and the hell breaks loose.

That is right. That is also why I try to use the clocksource framework 
if the get_cycles righ-resolution timer is not available.
>
>But they usually _do_ have RTC or other clock, not driven by CPU
>oscilator. Good.
>
>What about just
>
>while (!enough_entropy) {
>      cur_time = read_rtc();
>      simulated_tsc = 0;
>      while (cur_time == read_rtc())
>      	    simulated_tsc++;
>      gain_entropy_from(simulated_tsc)
>}

That is an interesting piece of code -- what would you do in the 
gain_entropy_from function?
>
>(Where enough_entropy should be something like 128 bits).
>
>This should work, we know why it works (drift between rtc and cpu
>clock) and it does _not_ need rdtsc-style fast source.
>
>Disadvantage is that it burns cpu, but, well, you only need 128

That disadvantage should be no problem, because at the time we need 
entropy, burning some CPU cycles are ok. Encryption burns even more CPU 
cycles :-)

>bits. Asuming the rtc used has 100Hz resolution, enough entropy should
>be collected in under 2 seconds. That's acceptable adition to time it
>takes generating ssh keys on slow cpu.
>									
Pavel


Ciao
Stephan
