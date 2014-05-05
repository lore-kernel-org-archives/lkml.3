Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbaEEN06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:26:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbaEEN04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:26:56 -0400
Date: Mon, 5 May 2014 08:26:38 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140505132638.GA14432@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <20140505085537.GA32196@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140505085537.GA32196@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 10:55:37AM +0200, Ingo Molnar wrote:
> 
> * Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > [...]
> > 
> > kpatch checks the backtraces of all tasks in stop_machine() to 
> > ensure that no instances of the old function are running when the 
> > new function is applied.  I think the biggest downside of this 
> > approach is that stop_machine() has to idle all other CPUs during 
> > the patching process, so it inserts a small amount of latency (a few 
> > ms on an idle system).
> 
> When live patching the kernel, how about achieving an even 'cleaner' 
> state for all tasks in the system: to freeze all tasks, as the suspend 
> and hibernation code (and kexec) does, via freeze_processes()?
> 
> That means no tasks in the system have any real kernel execution 
> state, and there's also no problem with long-sleeping tasks, as 
> freeze_processes() is supposed to be fast as well.
> 
> I.e. go for the most conservative live patching state first, and relax 
> it only once the initial model is upstream and is working robustly.

I had considered doing this before, but the problem I found is that many
kernel threads are unfreezable.  So we wouldn't be able to check whether
its safe to replace any functions in use by those kernel threads.

-- 
Josh
