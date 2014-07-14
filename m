Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaGNNXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbaGNNW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:22:58 -0400
Date: Mon, 14 Jul 2014 15:22:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140714132223.GC17761@krava.redhat.com>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140714111833.GU19379@twins.programming.kicks-ass.net>
 <20140714114359.GA17761@krava.redhat.com>
 <20140714130237.GX9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714130237.GX9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 03:02:37PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 01:43:59PM +0200, Jiri Olsa wrote:
> > On Mon, Jul 14, 2014 at 01:18:33PM +0200, Peter Zijlstra wrote:
> > > On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> > > > From: Jiri Olsa <jolsa@redhat.com>
> > > > 
> > > > When task exits we close:
> > > >   1) all events that are installed in task
> > > >   2) all events owned by task (via file descriptor)
> > > > 
> > > > But we don't close children events of 2) events. Those children
> > > > events stay until the child task exits and are useless with the
> > > > parent being gone, because we have no way to get to values any
> > > > more.
> > > > 
> > > > Plus if the event stays installed in task even with the owner task
> > > > gone, it runs the perf callback any time the task forks, for no
> > > > real reason.
> > > > 
> > > > Closing all children events events when the owner task of the
> > > > parent event is closed.
> > > 
> > > Do we need this for the other patches, or is this an unrelated change? 
> > 
> > if we dont do it, the event stays installed without owner and
> > perf fork callback will be called and fail on permission checking
> > (because of owner == NULL) ... so yes, I think it's needed
> 
> Oh, right. Alternatively, we don't need permission checking for inherits
> at all, if we're allowed to create the initial event, we should be good
> for inherits.

I could adress that in follow up patch.. or you want this instead
of this one? IMO we should close those events anyway..

jirka
