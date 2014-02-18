Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaBRWTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:19:07 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:50401 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaBRWTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:19:03 -0500
X-Greylist: delayed 13837 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 17:19:03 EST
Date: Tue, 18 Feb 2014 17:20:57 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
References: <20140130190253.GA11819@redhat.com> <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu> <20140211132956.GY9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu> <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Vince Weaver wrote:

> On Mon, 17 Feb 2014, Peter Zijlstra wrote:
> 
> > Enable CONFIG_FRAME_POINTER for better stack traces; I suspect the
> > list_del_event() is just random stack garbage. The path that makes sense
> > is:
> >   wait_rcu()->__wait_for_common()->schedule_timeout()
> 
> Here's an updated stack trace on 3.14-rc3 with CONFIG_FRAME_POINTER 
> enabled, in case it's helpful:

Still chasing this, although all I can add are these debug messages:

[  140.812003] PROBLEM: n_events=2 n_added=2 VMW: idx=33 state=f00 type=0 config=0 samp_per=5e6069eb0
[  140.812003] ALL: VMW: Num=0 idx=33 state=f00 type=0 config=0 samp_per=5e6069eb0
[  140.812003] ALL: VMW: Num=1 idx=0 state=3 type=0 config=1 samp_per=0

So when the WARN gets triggered there only only two events in the event
list, the NMI watchdog which has already been enabled somehow (that f00
I stuck in, pmu_start sets it to f00 instead of 00 to make sure it wasn't
something stomping on memory) and the precise instructions event.

I still have a hard time following what all the schedule in code is doing.

Vince
