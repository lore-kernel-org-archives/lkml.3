Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaEBIiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:38:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaEBIh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:37:58 -0400
Date: Fri, 2 May 2014 10:37:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
In-Reply-To: <cover.1398958771.git.jpoimboe@redhat.com>
Message-ID: <alpine.LRH.2.00.1405021030540.22053@twin.jikos.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Josh Poimboeuf wrote:

> Since Jiri posted the kGraft patches [1], I wanted to share an
> alternative live patching solution called kpatch, which is something
> we've been working on at Red Hat for quite a while.

Hi Josh, Seth,

thanks a lot for following up to our RFC with your submission, I am pretty 
sure this will help to energize the discussion and will provoke ideas for 
further improvements.

[ ... snip ... ]
> kpatch vs kGraft
> ----------------
> 
> I think the biggest difference between kpatch and kGraft is how they
> ensure that the patch is applied atomically and safely.
> 
> kpatch checks the backtraces of all tasks in stop_machine() to ensure
> that no instances of the old function are running when the new function
> is applied.  I think the biggest downside of this approach is that
> stop_machine() has to idle all other CPUs during the patching process,
> so it inserts a small amount of latency (a few ms on an idle system).

Completely agreed with your comparative analysis, thanks for a nice 
summary.

Additional thing that I believe is important to add here: with the 
"stop-machine / check all tasks" aproach, there might be situations where 
you'll always fail to patch the system; if there is a long-time sleeper in 
the patched callchain, such a single sleeper is enough to make the 
patching of the whole system impossible.

With the lazy/gradual aproach implemented in kGraft, the whole system is 
gradually moving towards "fully patched" state and once all the sleepers 
blocking the process wake up, it ultimately converges to the fully patched 
state.

Thanks,

-- 
Jiri Kosina
SUSE Labs

