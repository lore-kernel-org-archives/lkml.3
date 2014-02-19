Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaBSCmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:42:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaBSCmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:42:49 -0500
Date: Tue, 18 Feb 2014 21:42:09 -0500
From: Don Zickus <dzickus@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 01/21] perf c2c: Shared data analyser
Message-ID: <20140219024209.GK25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-2-git-send-email-dzickus@redhat.com>
 <20140218125206.GE4343@krava.brq.redhat.com>
 <20140218125647.GA2350@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218125647.GA2350@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:56:47AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 18, 2014 at 01:52:06PM +0100, Jiri Olsa escreveu:
> > On Mon, Feb 10, 2014 at 12:28:56PM -0500, Don Zickus wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> <SNIP>
> 
> > > +++ b/tools/perf/util/evlist.h
> > > @@ -52,6 +52,13 @@ struct perf_evsel_str_handler {
> > >  	void	   *handler;
> > >  };
> > >  
> > > +int __perf_evlist__set_handlers(struct perf_evlist *evlist,
> > > +				const struct perf_evsel_str_handler *assocs,
> > > +				size_t nr_assocs);
> > > +
> > > +#define perf_evlist__set_handlers(evlist, array) \
> > > +	__perf_evlist__set_handlers(evlist, array, ARRAY_SIZE(array))
> > > +
> > 
> > this is already implemented in session object.. just need to be
> > changed to work over any event is globaly usable
> 
> This probably has some historical baggage, i.e. I introduced this in
> this cset and later brought it to the trunk, perhaps, need to review
> this to figure this out, busy right now.

No worries, I will dig into it and try to use the right function calls.

Cheers,
Don
