Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3JKNvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:51:17 -0400
Received: from science.horizon.com ([71.41.210.146]:50573 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753710Ab3JKNvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:51:16 -0400
Date: 11 Oct 2013 09:51:14 -0400
Message-ID: <20131011135114.24362.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, rostedt@goodmis.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        torvalds@linux-foundation.org
In-Reply-To: <20131011084507.1d691504@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that the scheduler doesn't see that the current task has
> preemption disabled. It only looks at the priorities of the current
> task, and if it can preempt it, it will. It sets the NEED_RESCHED to the
> current task and waits for the preemption to schedule it out.

Ah, got it.  It's a priority inversion problem, and while there is a
standard solution (priority inheritance), if I were to suggest such a
heavyweight solution, Linus would start yelling again and Sarah would
get unhappy, and we all know how that ends up.

Thank you.  I will now cease displaying my ignorance in public.
