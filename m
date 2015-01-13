Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbbAMJgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:36:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbbAMJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:36:14 -0500
Date: Tue, 13 Jan 2015 10:36:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: PERF_FLAG_FD_OUTPUT has been broken since 2.6.35
Message-ID: <20150113093603.GK23965@worktop.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1501081014460.24664@vincent-weaver-1.umelst.maine.edu>
 <20150109160051.GK29390@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1501091123040.27178@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501091123040.27178@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 11:26:54AM -0500, Vince Weaver wrote:
> 
> On Fri, 9 Jan 2015, Peter Zijlstra wrote:
> > > So is this worth fixing seeing as apparently no one uses this feature?
> > 
> > I think there's a fair argument for removing it, Ingo, Acme?
> 
> could the functionality be replaced with a subsequent call to
> 	ioctl(PERF_EVENT_IOC_SET_OUTPUT)

Yes.

> Although I suppose there's a possibility for losing a small amount of data 
> or some other reason that PERF_FLAG_FD_OUTPUT was introduced in the first 
> place.

That's a natural race without solution. That is, because there is no
serialization between the sys_perf_event_open() and any possible acts of
data generation, we can't even talk about loosing data.

Even if it were all in a single syscall, there is no saying how long
that syscall would take to complete -- imagine its stuck on memory
allocation or whatnot. Similarly you could have issued the syscall a wee
bit later or whatnot.

> In addition, if we remove PERF_FLAG_FD_OUTPUT would there then be any 
> reason to keep PERF_FLAG_FD_NO_GROUP around?

Good point, I think there was another potential user of that proposed
recently, but I can't quite remember where or what. Let me try and go
find that.
