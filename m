Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3GKTXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:23:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3GKTXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:23:21 -0400
Date: Thu, 11 Jul 2013 21:23:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@akamai.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mathieu.desnoyers@efficios.com
Subject: Re: [RFC] [PATCH 0/2] x86: make jump labels use int3-based breakpoint
 instead of stop_machine()
In-Reply-To: <1373560944.17876.41.camel@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1307112122020.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>  <51DDDFB3.3020004@akamai.com>  <alpine.LNX.2.00.1307110159490.25858@pobox.suse.cz> <1373560944.17876.41.camel@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Steven Rostedt wrote:

> On Thu, 2013-07-11 at 02:04 +0200, Jiri Kosina wrote:
> 
> > I even have preliminary (completely untested) patch, but would like to 
> > have this merged/acked in the first round before proceeding with porting 
> > ftrace to the new interface.
> > 
> > > Also, I wonder if its worth batching up updates. For example, right now 
> > > we simply update each call-site one at a time even if its associated 
> > > with the same control variable.
> > 
> > That does seem to make sense indeed, but it's not really closely tied to 
> > this patchset, is it?
> 
> If you want to have ftrace use this interface, then we need to support
> batch processing. And you will need to do it with an iterator as well.
> We can not allocate 30,000 locations to run this on. Ftrace has its own
> table, and uses the ftrace iterator to traverse it.
> 
> Thus you would need to do something like:

Yup, I have been looking at the ftrace implementation and came to this 
conclusion; thanks for confirmation.
That's exactly why I wanted to postpone converting ftrace before agreement 
on text_poke_bp() is reached and jump labels are converted.

Thanks,

-- 
Jiri Kosina
SUSE Labs
