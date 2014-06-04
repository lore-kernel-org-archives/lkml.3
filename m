Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaFDLlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:41:11 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38632 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaFDLlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:41:09 -0400
MIME-Version: 1.0
Date: Wed, 4 Jun 2014 17:11:08 +0530
Message-ID: <CAKohponiCH35ZBTicCkVV3KoJzCWrnJExeR9HqwSMv+QDp36gg@mail.gmail.com>
Subject: [Query] Can we use normal timers (kernel/timer.c) while in NO_HZ_FULL mode?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While working on the ONESHOT_STOPPED mode I came across
another confusing scenario..

Normal timers (kernel/timer.c) don't configure clockevent devices
at all but they always rely on PERIODIC tick interrupts to get them
scheduled. i.e. normal timers would be only serviced at next tick
interrupt (in both LOW & HIGH resolution modes)..

Suppose we have entered into NO_HZ_FULL mode (we made
sure that there are no normal timers queued) and a normal
timer was added after that. We will add it to the timer list but
as there is no tick-sched timer, we wouldn't be able to service
the normal timer until next time tick fires again (MAX 1 second
currently)..

And once we remove this MAX 1 second limitation, we might
not service this normal timer for long..

Does this problem statement make sense? Or we don't have
any such problem?

--
viresh
