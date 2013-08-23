Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3HWJqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:46:03 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:59686 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3HWJqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:46:01 -0400
Date: Fri, 23 Aug 2013 11:45:56 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Vince Weaver <vince@deater.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130823094556.GB10223@rric.localhost>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823091128.GA19548@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823091128.GA19548@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.13 11:11:28, Borislav Petkov wrote:
> On Thu, Aug 22, 2013 at 02:18:06PM -0400, Vince Weaver wrote:
> > > PERF_EVENT_IOC_ATTACH (Since Linux 3.xx)
> > > PERF_EVENT_IOC_DETACH (Since Linux 3.xx)
> > 
> > I think these aren't very good names for the ioctls.  Maybe something
> > like
> >   PERF_EVENT_IOC_MAKE_PERSISTENT
> >   PERF_EVENT_IOC_UNPERSIST
> > I know that last one's not a real word but I can't think of what the 
> > proper term would be.  Maybe
> >   PERF_EVENT_IOC_RELEASE_PERSISTENT
> >   PERF_EVENT_IOC_RECLAIM_PERSISTENT
> 
> "aren't very good names" is not really an argument I can work with. Why
> not? What if you want to attach/detach to events but not be persistent.
> Which also begs the question how long are we persistent? The whole
> system runtime or until the user decides to detach.
> 
> So ATTACH/DETACH in the sense of attaching processes to events for an
> arbitrary amount of time *and* *not* for the duration of the tracee
> as we do it currently implicitly, is much more generic wrt usage than
> specifying that specific persistent case.

Ok, for clarification, my intention was to say something like 'detach
event from the current process controlling it', or 'attach the event
to the current process that holds the fd'.

Whatever term is the best for this ioctls, I am fine with it. The
above terms look a bit long.

The problem with detach/attach is more that it's actually more
logically to attach first and afterwards detach. This is not the case
here, it's vise versa.

-Robert
