Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab3ECPxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:53:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:45908 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab3ECPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:53:43 -0400
Date: Fri, 3 May 2013 17:53:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RT] sched/workqueue: Only wake up idle workers if not
 blocked on sleeping spin lock
Message-ID: <20130503155340.GD8230@linutronix.de>
References: <1363633969.28194.3.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363633969.28194.3.camel@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-03-18 15:12:49 [-0400]:

>In -rt, most spin_locks() turn into mutexes. One of these spin_lock
>conversions is performed on the workqueue gcwq->lock. When the idle
>worker is worken, the first thing it will do is grab that same lock and
>it too will block, possibly jumping into the same code, but because
>nr_running would already be decremented it prevents an infinite loop.
>
>But this is still a waste of CPU cycles, and it doesn't follow the method
>of mainline, as new workers should only be woken when a worker thread is
>truly going to sleep, and not just blocked on a spin_lock().
>
>Check the saved_state too before waking up new workers.
>
>Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Taking for v3.8-rt.

Sebastian
