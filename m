Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3DOOKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:10:24 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:52619 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3DOOKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+xJJ1-UPPrkRLuiFcQN6JotG+1G9WS1LftKk67x-AiZuDBf3Q@mail.gmail.com>
References: <CA+xJJ1-UPPrkRLuiFcQN6JotG+1G9WS1LftKk67x-AiZuDBf3Q@mail.gmail.com>
Date: Mon, 15 Apr 2013 16:10:21 +0200
Message-ID: <CAFTL4hxNw9EJJ3ZvjYR55b6ZF2YQxMA2q80E+obkU21v6QfEow@mail.gmail.com>
Subject: Re: Trouble with full nohz and lttng
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mats Liljegren <mats.liljegren@enea.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/15 Mats Liljegren <mats.liljegren@enea.com>:
> When I use lttng, I keep getting ticks. Without lttng, no ticks. It's the
> same application I run, the same way. The only difference is whether lttng
> logging has been started or not.
>
> The trace says "sched" as reason for not disabled ticks. Using "top" I can't
> see any extra process/thread being created while my application runs, my
> application gets 99-101% of the CPU. There are a couple of kworker threads
> (3), a migration thread and a ksoftirq thread on the same CPU as my
> application, though "top" gives no indication that they do any execution.
>
> Is this a known limitation of lttng, or is there something else going on
> here?

I have no idea. But the "sched" reason means there is more than one
task in the runqueue at some point. It can be a kthread indeed. Or a
user task that gets migrated / woken up in the CPU.

You'll need to check the sched:sched_switch tracepoint.
