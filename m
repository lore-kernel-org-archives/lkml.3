Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3HMLGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:06:24 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:35212 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3HMLGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:06:22 -0400
Date: Tue, 13 Aug 2013 13:06:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] tracing: final fixes for events and some
Message-ID: <20130813110618.GA3300@gmail.com>
References: <1375712355.22073.45.camel@gandalf.local.home>
 <20130805143257.GA32639@gmail.com>
 <1375714329.22073.63.camel@gandalf.local.home>
 <20130812181325.GA19405@gmail.com>
 <20130813023922.GA1042@redhat.com>
 <20130812231443.52563398@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812231443.52563398@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 12 Aug 2013 22:39:22 -0400
> Dave Jones <davej@redhat.com> wrote:
> 
> 
> > I'm not sure why I got cc'd on this, but for my part, the perf/tracing 
> > related bugs I've found recently may have been there for ages, but 
> > they were triggerable as non-root users.
> 
> Which bug was able to trigger with non-root? The hash one that you 
> reported? That is something with the function tracer. Are you able to 
> enable function tracing as non-root?
> 
> Or is it because you gave more permissions for non-root to use extra 
> perf commands. Because no one but root should be able to enable function 
> tracing, as that can add a large overhead to the system.

Hm, also, tracepoints should in general only be accessible to root - all 
sorts of random privileged info leaks through tracepoints, a thorough 
review and sanitizing is needed to expose that to users. (and that does 
not consider the complication caused by exposing timing info.)

Thanks,

	Ingo
