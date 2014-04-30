Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbaD3NBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:01:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:51114 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707AbaD3NBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:01:40 -0400
Message-ID: <5360F42C.9080401@linutronix.de>
Date: Wed, 30 Apr 2014 15:01:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, Theodore Ts o <tytso@mit.edu>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] sched_clock: also call register_current_timer_delay()
 if possible
References: <1398860614-29469-1-git-send-email-bigeasy@linutronix.de> <20140430124800.GC21876@arm.com>
In-Reply-To: <20140430124800.GC21876@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 02:48 PM, Will Deacon wrote:
> Hi Sebastian,

Hi Will,

> As long as sched_clock is guaranteed to be a fixed frequency, always-on
> clocksource then this could work, but it removes the flexibility of having
> a separate delay clock and sched clock (is this useful?).



> Looking at your patch, I noticed that we need to extend the
> register_current_timer_delay function to deal with clocks that aren't as
> wide as cycle_t, otherwise we don't delay() for long enough when the clock
> overflows (this is potentially already an issue for architected timers <
> 64-bit). Could you cook a patch for that please?

Sure, I would change the type from long to u64 and fix all users. Would
that be okay for you?

> 
> Will

Sebastian
