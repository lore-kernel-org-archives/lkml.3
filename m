Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3BMJPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:15:20 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56882 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3BMJPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:15:17 -0500
Date: Wed, 13 Feb 2013 10:15:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130213091512.GC7630@gmail.com>
References: <20130207094650.76302f47@riff.lan>
 <20130207185608.GA25223@gmail.com>
 <20130207191345.GA28960@gmail.com>
 <20130207195257.GA29985@gmail.com>
 <20130207150838.02226207@riff.lan>
 <20130208141841.GB30334@gmail.com>
 <20130208085828.02e61518@riff.lan>
 <20130211095457.GF23932@gmail.com>
 <87d2w5ovc0.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2w5ovc0.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi,
> 
> On Mon, 11 Feb 2013 10:54:58 +0100, Ingo Molnar wrote:
> > * Clark Williams <williams@redhat.com> wrote:
> >
> >> I figured that was coming. :)
> >
> > ;-)
> >
> >> I'll look at it again and see about pulling the 
> >> autogroup/cgroup stuff into it's own header. After that it's 
> >> probably going to require some serious changes.
> >> 
> >> Any suggestions?
> >
> > I'd suggest doing it as finegrained as possible - potentially 
> > one concept at a time. I wouldn't mind a dozen small files in 
> > include/linux/sched/ - possibly more.
> 
> What about the .c files?  AFAICS the sched/core.c and 
> sched/fair.c are rather huge and contain various concepts 
> which might be separated to their own files.  It'd be better 
> reorganizing them too IMHO.

I'd be more careful about those, because there's various 
scheduler patch-sets floating modifying them.

sched.h is much more static and it is the one that actually gets 
included in like 60% of all *other* .c files, adding a few 
thousand lines to every .o compilation and causing measurable 
compile time overhead ...

So sched.h splitting is something we should really do, if 
there's people interested in and capable of pulling it off.

Thanks,

	Ingo
