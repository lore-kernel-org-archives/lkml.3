Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3LLJ7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:59:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3LLJ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:59:41 -0500
Date: Thu, 12 Dec 2013 10:59:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 6/6] [RFC] kprobes/x86: Call exception handlers
 directly from do_int3/do_debug
In-Reply-To: <52A93E3A.9080600@hitachi.com>
Message-ID: <alpine.LNX.2.00.1312121058220.1413@pobox.suse.cz>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204012856.22118.91079.stgit@kbuild-fedora.novalocal> <20131203213904.5ff1794c@gandalf.local.home> <alpine.LRH.2.00.1312111418550.6318@twin.jikos.cz> <52A93E3A.9080600@hitachi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, Masami Hiramatsu wrote:

> > Yeah, it's broken. Obviously, if you happen to trigger int3 before the 
> > notifier has been registered, it'd cause int3 exception to be unhandled. 
> > See
> > 
> > 	commit 17f41571bb2c4a398785452ac2718a6c5d77180e
> > 	Author: Jiri Kosina <jkosina@suse.cz>
> > 	Date:   Tue Jul 23 10:09:28 2013 +0200
> > 
> > 	    kprobes/x86: Call out into INT3 handler directly instead of using notifier
> > 
> > for one such issue that happened with jump labels.
> > 
> >> Hmm, if there's no users of the int3 notifier, should we just remove it?
> > 
> > Hmm, there are still uprobes, right?
> 
> Right, uprobes still use it, however, since it only handles user-space
> breakpoint, there is no problem.

Agreed. But therefore the notifier can't just be removed, unless uprobes 
are converted to direct call as well (but I don't think that'd be 
beneficial, notifier is sufficient in this case).

-- 
Jiri Kosina
SUSE Labs
