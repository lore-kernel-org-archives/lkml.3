Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbaGXOtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:49:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbaGXOtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:49:19 -0400
Date: Thu, 24 Jul 2014 16:49:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf report: Honor column width setting
Message-ID: <20140724144906.GA25165@krava.brq.redhat.com>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <1404883694-5342-5-git-send-email-namhyung@kernel.org>
 <20140724125751.GC7652@krava.brq.redhat.com>
 <20140724135747.GS20303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724135747.GS20303@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 10:57:47AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 24, 2014 at 02:57:51PM +0200, Jiri Olsa escreveu:
> > On Wed, Jul 09, 2014 at 02:28:12PM +0900, Namhyung Kim wrote:
> > > Set column width and do not change it if user gives -w/--column-widths
> > > option.  It'll truncate longer symbols than the width if exists.
> > 
> > SNIP
> > 
> > > --- a/tools/perf/util/sort.c
> > > +++ b/tools/perf/util/sort.c
> > > @@ -70,7 +70,9 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
> > >  				       size_t size, unsigned int width)
> > >  {
> > >  	const char *comm = thread__comm_str(he->thread);
> > > -	return repsep_snprintf(bf, size, "%-*s:%5d", width - 6,
> > > +
> > > +	width = max(7U, width) - 6;
> > > +	return repsep_snprintf(bf, size, "%-*.*s:%5d", width, width,
> > >  			       comm ?: "", he->thread->tid);
> > >  }
> > 
> > also we now print out all sort headers left alligned, which is wrong for
> > sort_thread header: "Command:  Pid' that mirrors value strings with ':'
> > being aligned
> > 
> > maybe something like in attached patch..?
> > 
> > thanks,
> > jirka
> > 
> > 
> > ---
> > diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> > index f89714329c0f..fbbe86b7f63c 100644
> > --- a/tools/perf/util/sort.c
> > +++ b/tools/perf/util/sort.c
> > @@ -78,6 +78,7 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
> >  
> >  struct sort_entry sort_thread = {
> >  	.se_header	= "Command:  Pid",
> > +	.se_header_right= true,
> 
> Is this just for the header? Perhaps its more clearly named .se_right_justify?

yep, it's just for header.. let's see Namhyung might have better
idea how to handle this problem

jirka
