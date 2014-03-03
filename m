Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaCCPGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:06:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbaCCPGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:06:30 -0500
Date: Mon, 3 Mar 2014 10:05:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140303150531.GZ25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
 <20140228194642.GM25953@redhat.com>
 <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 01:03:31PM -0800, Davidlohr Bueso wrote:
> On Fri, 2014-02-28 at 14:46 -0500, Don Zickus wrote:
> > On Fri, Feb 28, 2014 at 11:08:59AM -0800, Andi Kleen wrote:
> > > Don Zickus <dzickus@redhat.com> writes:
> > > > +
> > > > +static const struct perf_evsel_str_handler handlers[] = {
> > > > +	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
> > > > +	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
> > > 
> 
> Hmm I'm getting this when running a simple record command. 
> 
> invalid or unsupported event: 'cpu/mem-loads/pp'
> 
> This only occurs with c2c, other subcommands work normally. It's as if
> it were an old kernel, but it's Linus' latest. Is this an issue with the
> patch or something I'm missing?
> 
> Furthermore, I see:
> ls /sys/bus/event_source/devices/cpu/events
> branch-instructions  branch-misses  cache-misses  cache-references  cpu-cycles  instructions  mem-loads

Hmm, so based on Andi's reply, I am assuming you are running on a Westmere
(or Nehalem) due to the lack of mem-stores.

If you don't have mem-stores, this tool isn't going to work.  The tool can
only detect contention when sampling reads _and_ writes to the same
addresses.

Cheers,
Don
