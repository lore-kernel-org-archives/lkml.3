Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab3EJKY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:24:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58344
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab3EJKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:24:27 -0400
Date: Fri, 10 May 2013 12:22:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130510102245.GA31235@dyad.programming.kicks-ass.net>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <20130509150744.GB3039@dyad.programming.kicks-ass.net>
 <20130509152022.GD1628@krava.brq.redhat.com>
 <20130510092741.GE3039@dyad.programming.kicks-ass.net>
 <20130510094053.GF1040@krava.brq.redhat.com>
 <20130510095345.GG3039@dyad.programming.kicks-ass.net>
 <20130510101823.GA18427@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510101823.GA18427@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:18:23PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > so you mean just detect that by opening events with increasing precise 
> > > and see how far we could get.. could be I guess, though the 'precise' 
> > > sysfs attribute seems more fit to me
> > 
> > The other way around, start at ppp end at !p, then use the one that 
> > worked.
> 
> Really, instead of this silly 'probing until it works' notion, how about 
> the radical idea that we pass to the kernel our request, and the kernel 
> fulfills our wish to the best of its ability?
> 
> This could be done as a new PERF_COUNT_HW_CPU_CYCLES_PRECISE event, to 
> which tooling could migrate, without changing existing semantics.
> 
> The problem with the complex probing is that it's totally unnecessary 
> complexity that results from lack of passing the right information to the 
> kernel. Forcing that will only hinder user-space adoption of our precise 
> profiling facilities.

The part I have trouble with is that its a vague request and you'll get a vague
answer.

Its very similar to: 'do something' and getting a string of random bytes back.
Yes it is 'something', request fulfilled.

By doing the probing, userspace knows exactly what it asked and what it'll get.
