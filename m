Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaBMOtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:49:09 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53588 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBMOtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:49:07 -0500
MIME-Version: 1.0
In-Reply-To: <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
	<218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
Date: Thu, 13 Feb 2014 15:49:06 +0100
Message-ID: <CAFTL4hwRYMa+Ouc=VRCnG6g=18JxRJ1yYHKxiikBEdRP_f-k2Q@mail.gmail.com>
Subject: Re: [RFC] sched: Add a new lockless wake-from-idle implementation
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-13 2:40 GMT+01:00 Andy Lutomirski <luto@amacapital.net>:
> This is a strawman proposal to simplify the idle implementation, eliminate
> a race

Please describe the race in question.

>
> Benefits over current code:
>  - ttwu_queue_remote doesn't use an IPI unless needed
>  - The diffstat should speak for itself :)

Actually referring to the diffstat alone sounds dangerous here. Sure
this simplifies the code, I'm all for negative diffstat, and probably
it avoids a few IPIs, but this comes at the cost of added non-cheap
atomic_xchg() calls in some critical fastpath like resched_task()
path, the timer enqueue path and the inner idle loop.

So it's not like this all comes for free. I'm not saying we don't want
it but at least some serious measurements is needed.
