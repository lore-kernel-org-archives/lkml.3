Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaCKO1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbaCKO1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:27:02 -0400
Date: Tue, 11 Mar 2014 10:26:50 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
Message-ID: <20140311142650.GB13756@redhat.com>
References: <20140307150920.881849073@goodmis.org> <20140307151202.210588176@goodmis.org> <241011797.35066.1394481694124.JavaMail.zimbra@efficios.com> <y0mr469e9t0.fsf@fche.csb> <20140310225820.0f02025d@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310225820.0f02025d@gandalf.local.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven -

> > So it is a deferred-activation kind of call, with no way of knowing
> > when or if the tracepoints will start coming in.  Why is that
> > supported at all, considering that clients could monitor modules
> > coming & going via the module_notifier chain, and update registration
> > at that time?
> 
> That's my argument.

Was there an answer?


> > >> +	entry = get_tracepoint(name);
> > >> +	/* Make sure the entry was enabled */
> > >> +	if (!entry || !entry->enabled)
> > >> +		ret = -ENODEV;
> > 
> > For what it's worth, I agree with Mathieu that this sort of successful
> > failure result code is a problem for tracking what needs cleanup and
> > what doesn't.  (In systemtap's case, if this change gets merged, we'll
> > have to treat -ENODEV as if it were 0.)
> 
> Does systemtap enable tracepoints before they are created? That is, do
> you allow enabling of a tracepoint in a module that is not loaded yet?

We have no formal opinion on whether or not this makes sense.  If the
kernel permits it, fine.

> If not, than you want this as an error.

But it's not exactly an error!  It's a success of sorts, and means
that later on we have to unregister the callback, just as if it were
successful.


- FChE
