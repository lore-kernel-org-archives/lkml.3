Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaGGN6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:58:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbaGGN6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:58:31 -0400
Date: Mon, 7 Jul 2014 15:58:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
In-Reply-To: <20140703200750.648550267@goodmis.org>
Message-ID: <alpine.LNX.2.00.1407071557170.1655@pobox.suse.cz>
References: <20140703200750.648550267@goodmis.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Steven Rostedt wrote:

> [ NOT READY FOR INCLUSION! ]
> 
> Note, this is based off of my remove ftrace_start/stop() patch set.
> 
> I've been wanting to do this for years, and just never gotten around to it.
> But with all this talk of kpatch and kgraft live kernel patching using
> the ftrace infrastructure, it seems like a good time to do it.
> 
> The way the function callback mechanism works in ftrace is that if there's
> only one function callback registered, it will set the mcount/fentry
> trampoline to call that function directly. But as soon as you register
> another callback, the mcount trampoline calls a loop function that iterates
> over all the registered callbacks (ftrace_ops) checking their hash tables
> to see if the called function matches the ops before calling its callback.
> This happens even if the two registered functions are not even tracing
> the same function!
> 
> This really sucks if you are tracing all functions, and then add a kprobe
> or perf event that traces a single function. That will cause all the
> other functions being traced to perform the loop test.
[ ... snip ... ]

For the record -- I just did a quick test, and kGraft works nicely on top 
of this patchset.

Will be looking into the patches more closely later this week.

-- 
Jiri Kosina
SUSE Labs
