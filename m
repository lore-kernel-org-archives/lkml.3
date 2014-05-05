Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaEEIzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:55:44 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49209 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaEEIzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:55:42 -0400
Date: Mon, 5 May 2014 10:55:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
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
Message-ID: <20140505085537.GA32196@gmail.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1398958771.git.jpoimboe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> [...]
> 
> kpatch checks the backtraces of all tasks in stop_machine() to 
> ensure that no instances of the old function are running when the 
> new function is applied.  I think the biggest downside of this 
> approach is that stop_machine() has to idle all other CPUs during 
> the patching process, so it inserts a small amount of latency (a few 
> ms on an idle system).

When live patching the kernel, how about achieving an even 'cleaner' 
state for all tasks in the system: to freeze all tasks, as the suspend 
and hibernation code (and kexec) does, via freeze_processes()?

That means no tasks in the system have any real kernel execution 
state, and there's also no problem with long-sleeping tasks, as 
freeze_processes() is supposed to be fast as well.

I.e. go for the most conservative live patching state first, and relax 
it only once the initial model is upstream and is working robustly.

Thanks,

	Ingo
