Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaB1WDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:03:08 -0500
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:36577 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaB1WCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:02:55 -0500
Message-ID: <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
From: Davidlohr Bueso <davidlohr@hp.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Date: Fri, 28 Feb 2014 13:03:31 -0800
In-Reply-To: <20140228194642.GM25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
	 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
	 <87lhwvawc4.fsf@tassilo.jf.intel.com> <20140228194642.GM25953@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 14:46 -0500, Don Zickus wrote:
> On Fri, Feb 28, 2014 at 11:08:59AM -0800, Andi Kleen wrote:
> > Don Zickus <dzickus@redhat.com> writes:
> > > +
> > > +static const struct perf_evsel_str_handler handlers[] = {
> > > +	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
> > > +	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
> > 

Hmm I'm getting this when running a simple record command. 

invalid or unsupported event: 'cpu/mem-loads/pp'

This only occurs with c2c, other subcommands work normally. It's as if
it were an old kernel, but it's Linus' latest. Is this an issue with the
patch or something I'm missing?

Furthermore, I see:
ls /sys/bus/event_source/devices/cpu/events
branch-instructions  branch-misses  cache-misses  cache-references  cpu-cycles  instructions  mem-loads

Thanks!



