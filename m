Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaBMRd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:33:29 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:38611 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaBMRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:33:28 -0500
Date: Thu, 13 Feb 2014 12:35:18 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
References: <20140130190253.GA11819@redhat.com> <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu> <20140211132956.GY9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Vince Weaver wrote:
> On Wed, 12 Feb 2014, Vince Weaver wrote:
> > 
> > It is triggered in this case when you have:
> > 
> >   An event group of breakpoint, cycles, branches
> >   An event of instructions with precise=1
> >   A tracepoint
> > 
> > and then you close the tracepoint.
> 
> and for what it's worth, it's the cycles event (type=0 config=0) that's 
> causing the WARN_ON.

The plot thickens.  The WARN_ON is not caused by the cycles event that we 
open, but it's caused by the NMI Watchdog cycles event.

I'm not sure if that's useful info or not.

Vince
