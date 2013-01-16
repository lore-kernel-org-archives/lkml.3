Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3APWGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:06:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3APWGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:06:51 -0500
Date: Wed, 16 Jan 2013 14:06:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] context_tracking: Add comments on interface and
 internals
Message-Id: <20130116140648.e5e93ac7.akpm@linux-foundation.org>
In-Reply-To: <1358372961.23211.8.camel@gandalf.local.home>
References: <87wqvdl1n8.fsf@sejong.aot.lge.com>
	<1358352997-29585-1-git-send-email-fweisbec@gmail.com>
	<20130116131832.7b3bede0.akpm@linux-foundation.org>
	<1358372961.23211.8.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 16:49:21 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2013-01-16 at 13:18 -0800, Andrew Morton wrote:
> > On Wed, 16 Jan 2013 17:16:37 +0100
> 
> > I still don't understand NOHZ's role in this whole thing :(
> 
> It's not for idle NOHZ, but "process" NOHZ.
> 
> That is if we have only one task running on a CPU, we don't want a tick
> interrupt to bother it. This is because there's lots of users out there
> that want an uninterrupted task. A task that doesn't ever get bothered
> by the kernel. If it's in userspace, it stays in userspace (no
> interrupts), until it calls into the kernel itself (syscall). Even when
> its in the kernel, we still don't need the tick interrupt if its the
> only task.

oh, is that what TIF_NOHZ does ;)

> But the scheduler isn't the only thing that uses this tick. To remove
> the tick, we need to satisfy all the other users (printk, delayed work,
> u/s-times).
> 
> To still keep up the stats of user and kernel times for the task, we
> need to record when the task switches from user to kernel and back
> again. Hence the context tracking code.
> 
> Makes more sense?

yup thanks.
