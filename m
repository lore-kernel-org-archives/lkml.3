Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaK0Myp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:54:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaK0Myo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:54:44 -0500
Date: Thu, 27 Nov 2014 13:54:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Do not fail on processing out of order event
Message-ID: <20141127125416.GA25752@krava.brq.redhat.com>
References: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
 <20141126154459.GD3808@redhat.com>
 <20141127105603.GA1987@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127105603.GA1987@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:56:03AM +0100, Ingo Molnar wrote:

SNIP

> > > -		pr_oe_time(timestamp,      "out of order event");
> > > +		pr_oe_time(timestamp,      "out of order event\n");
> > >  		pr_oe_time(oe->last_flush, "last flush, last_flush_type %d\n",
> > >  			   oe->last_flush_type);
> > >  
> > > -		/* We could get out of order messages after forced flush. */
> > > -		if (oe->last_flush_type != OE_FLUSH__HALF)
> > > -			return -EINVAL;
> > > +		s->stats.nr_unordered_events++;
> 
> Btw., in the forced flush case we'll get out of order events that 
> are 'expected'. Shouldn't we count them separately and not warn 
> about them, or so?

hum, we warned about them anyway, we just did not fail processing..
and the impact of both cases should be the same.. it's just at the
forced flush we expected/allowed out of order events

so I think it's ok to share the same counter and warn about
them the same way

> 
> > > +	if (session->stats.nr_unordered_events != 0) {
> > > +		ui__warning("%u out of order events recorded.\n",
> > > +			    session->stats.nr_unordered_events);
> > > +	}
> 
> Nit: I'd suggest keeping the message printout on a single line:
>  
> 	if (session->stats.nr_unordered_events != 0) {
> 		ui__warning("%u out of order events recorded.\n", session->stats.nr_unordered_events);
> 
> as IMHO the cure for this col80 linebreak checkpatch warning is 
> worse than the disease! :-)

ok ;-)

> 
> Barring those details:
> 
>   Acked-by: Ingo Molnar <mingo@kernel.org>

thanks,
jirka
