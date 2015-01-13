Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbbAML4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:56:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:36522 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbAML4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:56:44 -0500
Date: Tue, 13 Jan 2015 08:56:39 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: perf: PERF_FLAG_FD_OUTPUT has been broken since 2.6.35
Message-ID: <20150113115639.GH29743@kernel.org>
References: <alpine.DEB.2.11.1501081014460.24664@vincent-weaver-1.umelst.maine.edu>
 <20150109160051.GK29390@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1501091123040.27178@vincent-weaver-1.umelst.maine.edu>
 <20150113093603.GK23965@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113093603.GK23965@worktop.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 13, 2015 at 10:36:03AM +0100, Peter Zijlstra escreveu:
> On Fri, Jan 09, 2015 at 11:26:54AM -0500, Vince Weaver wrote:
> > On Fri, 9 Jan 2015, Peter Zijlstra wrote:
> > > > So is this worth fixing seeing as apparently no one uses this feature?

> > > I think there's a fair argument for removing it, Ingo, Acme?

> > could the functionality be replaced with a subsequent call to
> > 	ioctl(PERF_EVENT_IOC_SET_OUTPUT)
 
> Yes.
 
> > Although I suppose there's a possibility for losing a small amount of data 
> > or some other reason that PERF_FLAG_FD_OUTPUT was introduced in the first 
> > place.
 
> That's a natural race without solution. That is, because there is no
> serialization between the sys_perf_event_open() and any possible acts of
> data generation, we can't even talk about loosing data.

> Even if it were all in a single syscall, there is no saying how long
> that syscall would take to complete -- imagine its stuck on memory
> allocation or whatnot. Similarly you could have issued the syscall a wee
> bit later or whatnot.

That is exactly my thinking, the world goes on while we set up perf to
observe it :-)

- Arnaldo
