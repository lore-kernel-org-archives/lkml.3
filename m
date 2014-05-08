Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaEHFLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:11:19 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35151 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaEHFLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:11:18 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 8 May 2014 01:14:56 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140507215430.GH8607@moon>
Message-ID: <alpine.DEB.2.10.1405080111280.9135@vincent-weaver-1.umelst.maine.edu>
References: <20140506202307.GA1458@moon> <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu> <20140506214630.GB1458@moon> <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu> <20140507164902.GD1444@moon> <20140507165811.GG1444@moon>
 <alpine.DEB.2.10.1405071305010.6340@vincent-weaver-1.umelst.maine.edu> <20140507182410.GA8607@moon> <alpine.DEB.2.10.1405071713590.7020@vincent-weaver-1.umelst.maine.edu> <20140507215144.GG8607@moon> <20140507215430.GH8607@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Cyrill Gorcunov wrote:

> > > The NMI issue is probably the only one that is p4 related, and I do get 
> > > the NMI warnings on other machines too, it's just the p4 is the only one 
> > > where it brings down the machine.
> > 
> > Vince, could you please provde more details on that? Is it possible
> > to somehow log which events were used by perf?
> 
> There were a bug in p4 pmu Don (CC'ed) fixed not that long ago but I fear
> not all corner cases might be covered yet.

I hit the NMI warnings somewhat often on Intel hardware (Haswell, Core2) 
but it usually doesn't make the system unusable like it does on p4.

I can try to get a trace, although I'm not sure it will be useful.  I 
spent a lot of time getting a reproducible test case for the same warnings 
on core2 and it was unclear what the proble was and it was never fixed.

The messages look like this:

[ 2944.203423] Uhhuh. NMI received for unknown reason 31 on CPU 0.
[ 2944.208006] Do you have a strange power saving mode enabled?
[ 2944.208006] Dazed and confused, but trying to continue
[ 2944.208006] Uhhuh. NMI received for unknown reason 21 on CPU 0.
[ 2944.208006] Do you have a strange power saving mode enabled?
[ 2944.208006] Dazed and confused, but trying to continue
[ 2944.208006] Uhhuh. NMI received for unknown reason 31 on CPU 0.
[ 2944.208006] Do you have a strange power saving mode enabled?
[ 2944.208006] Dazed and confused, but trying to continue

repeating forever, system is unusable.

Vince
