Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaEBRmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:42:51 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:59019 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaEBRmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:42:50 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 2 May 2014 13:46:27 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140502172731.GK30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu> <20140502154217.GW11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu>
 <20140502162234.GX11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu> <20140502172731.GK30445@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Peter Zijlstra wrote:

> On Fri, May 02, 2014 at 12:43:17PM -0400, Vince Weaver wrote:
> > On Fri, 2 May 2014, Peter Zijlstra wrote:
> > 
> > > In principle the vfs file refcounting should be responsible for that.
> > > But I'll go over it in a bit.
> > 
> > The poll code is ancient and the C-parser in my head really can't handle 
> > it very well.
> 
> Yeah, that code isn't my favourite part either..
> 
> > Anyway for completeness this is the kind of thing I'm seeing.
> > The poll() manpage isn't very clear about what is supposed to happen if 
> > you poll() on a closed file descriptor.
> 
>               POLLNVAL
>                      Invalid request: fd not open (output only).
> 
> Seems applicable..

You're right and it seems to return that properly, so having poll be 
active might just be a weird co-incidence.

> Also, could you send your entire diff this way so we're more or less
> staring at the same code again?

that last test I ran was just 3.15-rc1 plus the last patch you sent,
plus a patch to allow -pg on the event.c file, plus an unrelated one that 
works around the current make-kpkg debian breakage.

Vince
