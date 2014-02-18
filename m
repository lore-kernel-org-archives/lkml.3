Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaBRM44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:56:56 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52268 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaBRM4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:56:55 -0500
Date: Tue, 18 Feb 2014 09:56:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 01/21] perf c2c: Shared data analyser
Message-ID: <20140218125647.GA2350@infradead.org>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-2-git-send-email-dzickus@redhat.com>
 <20140218125206.GE4343@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218125206.GE4343@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 18, 2014 at 01:52:06PM +0100, Jiri Olsa escreveu:
> On Mon, Feb 10, 2014 at 12:28:56PM -0500, Don Zickus wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>

<SNIP>

> > +++ b/tools/perf/util/evlist.h
> > @@ -52,6 +52,13 @@ struct perf_evsel_str_handler {
> >  	void	   *handler;
> >  };
> >  
> > +int __perf_evlist__set_handlers(struct perf_evlist *evlist,
> > +				const struct perf_evsel_str_handler *assocs,
> > +				size_t nr_assocs);
> > +
> > +#define perf_evlist__set_handlers(evlist, array) \
> > +	__perf_evlist__set_handlers(evlist, array, ARRAY_SIZE(array))
> > +
> 
> this is already implemented in session object.. just need to be
> changed to work over any event is globaly usable

This probably has some historical baggage, i.e. I introduced this in
this cset and later brought it to the trunk, perhaps, need to review
this to figure this out, busy right now.

- Arnaldo
