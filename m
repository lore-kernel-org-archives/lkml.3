Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3K2Rsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:48:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50501 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3K2Rsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:48:38 -0500
Message-Id: <20131129173657.252094369@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Nov 2013 18:36:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/7] sched: Optimize sched_clock bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series is supposed to optimize the kernel/sched/clock.c and x86
sched_clock() implementations.

So far its only been boot tested. So no clue if it really makes the thing
faster, but it does remove the need to disable IRQs.

I'm hoping Eliezer will test this with his benchmark where he could measure a
performance regression between using sched_clock() and local_clock().

It looks like ia64, the only other CONFIG_HAVE_UNSTABLE_SCHED_CLOCK user,
already matches the new expectations -- mostly not requiring IRQs disabled for
calling sched_clock().

