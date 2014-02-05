Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaBENZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:25:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaBENZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:25:15 -0500
Date: Wed, 5 Feb 2014 11:24:50 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Handle PERF_RECORD_HEADER_EVENT_TYPE properly
Message-ID: <20140205132450.GA3685@infradead.org>
References: <1391524668-12546-1-git-send-email-jolsa@redhat.com>
 <20140205055552.GD30094@gmail.com>
 <20140205090339.GB1201@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205090339.GB1201@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 05, 2014 at 10:03:39AM +0100, Jiri Olsa escreveu:
> On Wed, Feb 05, 2014 at 06:55:52AM +0100, Ingo Molnar wrote:
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > We removed event types from data file in following commits:
> > >   6065210 perf tools: Remove event types framework completely
> > >   44b3c57 perf tools: Remove event types from perf data file
> > > 
> > > We no longer need this information, because we can get it
> > > directly from tracepoints.
> > > 
> > > But we still need to handle PERF_RECORD_HEADER_EVENT_TYPE
> > > event for the sake of old perf data files created in pipe
> > > mode like:
> > > 
> > >   $ perf.3.4 record -o - foo >perf.data
> > >   $ perf.312 report -i - < perf.data
> > > 
> > > Reported-by: Stephane Eranian <eranian@google.com>
> > > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Namhyung Kim <namhyung@kernel.org>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Cc: David Ahern <dsahern@gmail.com>
> > > ---
> > >  tools/perf/util/session.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> > > index 0b39a48..5da6ce7 100644
> > > --- a/tools/perf/util/session.c
> > > +++ b/tools/perf/util/session.c
> > > @@ -1008,6 +1008,12 @@ static int perf_session__process_user_event(struct perf_session *session, union
> > >  		if (err == 0)
> > >  			perf_session__set_id_hdr_size(session);
> > >  		return err;
> > > +	case PERF_RECORD_HEADER_EVENT_TYPE:
> > > +		/*
> > > +		 * Depreceated, but we need to handle it for sake
> > > +		 * of old data files create in pipe mode.
> > > +		 */
> > 
> > Two small speling nits:
> > 
> >  s/Depreceated
> >   /Deprecated
> > 
> >  s/create
> >   /created
> > 
> > Ack otherwise.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> ugh, my spell checker sux.. ;-\ acme, beer for each correction? ;-)

two for each, deal.

- Arnaldo
