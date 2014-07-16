Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbaGPMVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:21:00 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64094 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbaGPMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:20:58 -0400
Date: Wed, 16 Jul 2014 14:20:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140716122047.GA9496@gmail.com>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140711132309.GH20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711132309.GH20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> > From: Jiri Olsa <jolsa@redhat.com>
> > 
> > When task exits we close:
> >   1) all events that are installed in task
> >   2) all events owned by task (via file descriptor)
> > 
> > But we don't close children events of 2) events. Those children
> > events stay until the child task exits and are useless with the
> > parent being gone, because we have no way to get to values any
> > more.
> > 
> > Plus if the event stays installed in task even with the owner task
> > gone, it runs the perf callback any time the task forks, for no
> > real reason.
> > 
> > Closing all children events events when the owner task of the
> > parent event is closed.
> 
> So I _think_ the reason we didn't do this is because this is potentially
> very expensive and keeping them around isn't too much bother, they'll
> die eventually.
> 
> But I can't really remember. Ingo any recollections / opinions?

As far as I can remember it's just a historic path dependent 
implementation detail, not really a conscious choice: initially we 
didn't remove events (because we couldn't), and then it remained so 
because it broke nothing.

Thanks,

	Ingo
