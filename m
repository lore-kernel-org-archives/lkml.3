Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaCQLG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:06:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbaCQLG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:06:57 -0400
Date: Mon, 17 Mar 2014 11:45:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 5/5] perf tools: Share process map groups within process
 threads
Message-ID: <20140317104533.GB6469@krava.brq.redhat.com>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-6-git-send-email-jolsa@redhat.com>
 <871ty1thgk.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ty1thgk.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:25:15PM +0900, Namhyung Kim wrote:
> On Fri, 14 Mar 2014 15:00:06 +0100, Jiri Olsa wrote:
> > +	if (!mg) {
> > +		struct thread *leader = thread__get_leader(thread);
> > +
> > +		if (!leader)
> > +			return NULL;
> > +
> > +		if (leader->mg)
> > +			mg = leader->mg;
> > +		else
> > +			mg = thread__map_groups_alloc(leader);
> > +
> > +		if (leader != thread)
> > +			thread->mg = mg;
> > +
> > +		mg->refcnt++;
> 
> What's the value of mg->refcnt here in case of leader != thread and
> leader->mg was not allocated originally?  I think it's 1 - but shouldn't
> it be 2 since it's referenced from both of leader and the thread now?

right you are..

I need to initialize refcnt to 1 in thread__map_groups_alloc
and increase it only for the '(leader != thread)' case

I'll add some test for this

thanks,
jirka
