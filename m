Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3JEDZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 23:25:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:63901 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3JEDZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 23:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1037,1371106800"; 
   d="scan'208";a="370099200"
Date: Fri, 4 Oct 2013 20:25:40 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 4/6] trace: Make UPROBES depend on PERF_EVENTS
Message-ID: <20131005032540.GA3363@tassilo.jf.intel.com>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-5-git-send-email-andi@firstfloor.org>
 <20131004205253.64dc04c9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004205253.64dc04c9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 08:52:53PM -0400, Steven Rostedt wrote:
> On Fri,  4 Oct 2013 14:39:46 -0700
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > UPROBES need the perf events code, so add a dependency
> > from PERF_EVENTS to UPROBES.
> 
> Can you please be a bit more specific on what uprobes requires of perf?
> That is, what part of the perf events code is needed, and why?

Without this dependency, when UPROBE_EVENT is enabled and PERF_EVENTS disabled 
I first get

warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENT && PERF_EVENTS)
warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENT && PERF_EVENTS)

and then later lots of errors like 

arch/x86/built-in.o: In function `do_notify_resume':
/home/ak/lsrc/git/linux-2.6/arch/x86/kernel/signal.c:743: undefined reference to `uprobe_notify_resume'
arch/x86/built-in.o: In function `arch_uprobe_exception_notify':
/home/ak/lsrc/git/linux-2.6/arch/x86/kernel/uprobes.c:637: undefined reference to `uprobe_pre_sstep_notifier'
/home/ak/lsrc/git/linux-2.6/arch/x86/kernel/uprobes.c:643: undefined reference to `uprobe_post_sstep_notifier'
kernel/built-in.o: In function `mmput':
/home/ak/lsrc/git/linux-2.6/kernel/fork.c:608: undefined reference to `uprobe_clear_state'

I'm not fully sure why UPROBES has the && PERF_EVENTS; I didn't add that.

-Andi
