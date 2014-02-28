Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaB1VRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:17:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaB1VRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:17:37 -0500
Date: Fri, 28 Feb 2014 22:17:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] x86: Rename copy_from_user_nmi() to
 copy_from_user_trace()
Message-ID: <20140228211730.GG14089@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
 <20140228092341.12a40f7c@gandalf.local.home>
 <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
 <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
 <20140228154026.GH9987@twins.programming.kicks-ass.net>
 <5310B60F.30806@zytor.com>
 <20140228112946.1f194397@gandalf.local.home>
 <20140228143316.211d4034@gandalf.local.home>
 <20140228204621.GA14089@laptop.programming.kicks-ass.net>
 <20140228160139.3762b511@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228160139.3762b511@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 04:01:39PM -0500, Steven Rostedt wrote:
> OK, I'll go with that. So instead of an _nmi() which it has nothing to
> do with NMIs, 

Well, how is 'safe to use from NMI' nothing to do with NMIs?

> how about making it like spin_lock_irq() and a more
> descriptive name about what it does?
> 
>  copy_from_user_savecr2()

So how expensive are these CR2 reads? Because if they're more expensive
than one or two cycles (normal instructions) I'd really rather not put
them in there.

I seem to have missed what was wrong with Jiri's patch. Are we worried
about the function trace events?

So IF we're going to push them into this side of things; I'd really
rather see the CR2 foo in perf_callchain_user() and make
arch_perf_out_copy_user() a real function which includes the CR2 goo
too.
