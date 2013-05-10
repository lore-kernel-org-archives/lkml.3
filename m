Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3EJJz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:55:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58178
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab3EJJz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:55:28 -0400
Date: Fri, 10 May 2013 11:53:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130510095345.GG3039@dyad.programming.kicks-ass.net>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <20130509150744.GB3039@dyad.programming.kicks-ass.net>
 <20130509152022.GD1628@krava.brq.redhat.com>
 <20130510092741.GE3039@dyad.programming.kicks-ass.net>
 <20130510094053.GF1040@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510094053.GF1040@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:40:53AM +0200, Jiri Olsa wrote:
> nope, but I need a automated way to find out if PEBS
> is supported in system

Create an event, see what happens ;-) But I suppose you want to know if it
should have worked vs does it actually work? Yeah, I suppose what you did
is the right thing there.

I was just completely missing the rationale earlier.

> > > having maximum precise enabled with just single 'p' seemed
> > > like good idea
> > 
> > Doesn't seem like to me; that takes away the possibility to use less.
> 
> hm, we could have another modifier to get system precise value
> 'P' maybe.. and keep the 'p' logic

That might be a possibility indeed.

> > Also, you really don't need the max_precise for that either. At worst you'll
> > have a number of unsuccessful event creations.
> 
> so you mean just detect that by opening events with increasing
> precise and see how far we could get.. could be I guess, though
> the 'precise' sysfs attribute seems more fit to me

The other way around, start at ppp end at !p, then use the one that worked.
