Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaBMOKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:10:32 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37860 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBMOKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:10:03 -0500
Date: Thu, 13 Feb 2014 09:11:49 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
References: <20140130190253.GA11819@redhat.com> <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu> <20140211132956.GY9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Vince Weaver wrote:

> On Tue, 11 Feb 2014, Peter Zijlstra wrote:
> > 
> > I'll see if I can run through the reproduction case by hand.
> 
> I've come up with an even simpler test case with all of the extraneous 
> settings removed.  Included below.
> 
> It is triggered in this case when you have:
> 
>   An event group of breakpoint, cycles, branches
>   An event of instructions with precise=1
>   A tracepoint
> 
> and then you close the tracepoint.

and for what it's worth, it's the cycles event (type=0 config=0) that's 
causing the WARN_ON.

It looks like I'm going to have to resort to sprinkling the code with 
printk()s to solve this one.

Vince
