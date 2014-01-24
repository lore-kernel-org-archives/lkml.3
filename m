Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaAXUUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:20:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:59482 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaAXUUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:20:43 -0500
Date: Fri, 24 Jan 2014 21:20:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>,
        Joakim Hernberg <jbh@alchemy.lu>, Joe Korty <joe.korty@ccur.com>,
        Muli Baron <muli.baron@gmail.com>
Subject: Re: [PATCH RT v2] timer: Raise softirq if there's irq_work
Message-ID: <20140124202039.GA32662@linutronix.de>
References: <20140124145157.1f30d447@gandalf.local.home>
 <20140124150933.22d8c20a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140124150933.22d8c20a@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2014-01-24 15:09:33 [-0500]:

>[ Talking with Sebastian on IRC, it seems that doing the irq_work_run()
>  from the interrupt in -rt is a bad thing. Here we simply raise the
>  softirq if there's irq work to do. This too boots on my i7 ]

It is okay in general because most of the users should not run in bare
interrupt context. The only exception here is the nohz_full_kick_work
thing.

>After trying hard to figure out why my i7 box was locking up with the
>new active_timers code, that does not run the timer softirq if there
>are no active timers, I took an extra look at the softirq handler and
>noticed that it doesn't just run timer softirqs, it also runs irq work.
>
>This was the bug that was locking up the system. It wasn't missing a
>timer, it was missing irq work. By always doing the irq work callbacks,
>the system boots fine.
>
>No need to check for defined(CONFIG_IRQ_WORK). When that's not set the
>"irq_work_needs_cpu()" is a static inline that returns false.
>
>Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thank you Steven, this makes sense.

Sebastian
