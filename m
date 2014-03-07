Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaCGOjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:39:31 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54122 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaCGOj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:39:29 -0500
Date: Fri, 7 Mar 2014 11:39:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: PVT Re: [PATCH 07/13] perf hists: Add support for showing relative
 percentage
Message-ID: <20140307143924.GD3153@ghostprotocols.net>
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
 <1393809254-4480-8-git-send-email-namhyung@kernel.org>
 <20140307143707.GC3153@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307143707.GC3153@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 07, 2014 at 11:37:07AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Mar 03, 2014 at 10:14:08AM +0900, Namhyung Kim escreveu:
> > When filtering by thread, dso or symbol on TUI it also update total
> > period so that the output shows different result than no filter - the
> > percentage changed to relative to filtered entries only.  Sometimes
> > this is not desired since users might expect same results with filter.
> > 
> > So new filtered_* fields to hists->stats to count them separately.
> > They'll be controlled/used by user later.
> > 
> > Acked-by: Jiri Olsa <jolsa@redhat.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/builtin-report.c |  6 ++++++
> >  tools/perf/util/hist.c      | 19 +++++++++++++++----
> >  tools/perf/util/hist.h      |  2 ++
> >  3 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index 5f7f1a332186..3f8478603d51 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -121,6 +121,8 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
> >  
> >  	evsel->hists.stats.total_period += cost;
> >  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> > +	if (!he->filtered)
> > +		evsel->hists.stats.nr_filtered_samples++;
> 
> 
> Huh? I read the above as "if not filtered, increment the number of
> filtered samples", isn't this reversed?
> 
> I.e. I understand "filtered" as entries that the filter applied to, so
> will not be considered, and you use this meaning for he->filtered, but
> not for stats_nr_filtered_samples, right?

Since I had to stop here, could you try reworking that other patch to
avoid aligning the \ at the end of the line and renaming the above to
some other name that makes he->filtered match in meaning what
stats_nr_filtered_samples means?

Perhaps stats_nr_non_filtered_samples?
 
> - Arnaldo
