Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3GEOXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:23:36 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:58927 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3GEOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130704075840.GH18898@dyad.programming.kicks-ass.net>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
	<20130704075840.GH18898@dyad.programming.kicks-ass.net>
Date: Fri, 5 Jul 2013 16:23:33 +0200
Message-ID: <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com>
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/4 Peter Zijlstra <peterz@infradead.org>:
> On Thu, Jul 04, 2013 at 01:34:13PM +0800, Alex Shi wrote:
>
>> If the tsc is marked as constant and nonstop, could we set it as system
>> clocksource when do tsc register? w/o checking it on clocksource_watchdog?
>
> I'd not do that; the BIOS can still screw you over, we need some validation.
>
> That said; we do need means to disable the clocksource watchdog -- although I
> suppose Frederic might already have provided this for this NOHZ efforts when I
> wasn't looking.

Nope, I haven't touched that. I prefer not to fiddle with unstable
clocksource for now :)

As for unstable TSCs, if sched_clock_tick() needs to be fed, we simply
don't stop the tick.
