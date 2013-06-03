Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab3FCOei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:34:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:49003 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab3FCOee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:34:34 -0400
Date: Mon, 3 Jun 2013 16:34:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tobias Waldekranz <tobias@waldekranz.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit
 systems
In-Reply-To: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1306031622520.2905@ionos>
References: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2601;0cOn Mon, 3 Jun 2013, Tobias Waldekranz wrote:
> In ktime_get_update_offsets, calculate the current time in the same
> way as in ktime_get.
> 
> On 32-bit systems, the current time is truncated via the call to
> ktime_set, the following subtraction of offs_real will result in an
> inaccurate time when the current number of seconds since epoch can no
> longer fit in 31-bits (2038-01-19 03:14:07 UTC). This will send
> hrtimer_interrupt into an infinite loop on some architectures (arm),
> or emit an oops on others(x86).

If we really want to survive 2038, then we need to get rid of the
timespec based representation of time in the kernel alltogether and
switch all related code over to a scalar nsec 64bit storage.

Just "fixing" some random parts of the code in a "make it work
somehow" way is a pointless exercise IMO.

We already had long discussions about how the timekeeping code should
be restructured to address that and other problems at least on the
kernel side and switching everything to scalar storage is definitely
the way to go.

Though even if we fix that we still need to twist our brains around
the timespec/timeval based user space interfaces. That's going to be
the way more interesting challenge.

Thanks,

	tglx
