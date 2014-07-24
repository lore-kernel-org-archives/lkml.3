Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbaGXP6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759709AbaGXP6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:58:54 -0400
Date: Thu, 24 Jul 2014 17:58:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf report: Honor column width setting
Message-ID: <20140724155843.GE25165@krava.brq.redhat.com>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <1404883694-5342-5-git-send-email-namhyung@kernel.org>
 <20140724125751.GC7652@krava.brq.redhat.com>
 <20140724135747.GS20303@kernel.org>
 <20140724144906.GA25165@krava.brq.redhat.com>
 <CAM9d7cjnxBEsEmm2-QdXBNzxy402R-rbSHJ7bmi0njeTe0LW7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cjnxBEsEmm2-QdXBNzxy402R-rbSHJ7bmi0njeTe0LW7g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 12:41:15AM +0900, Namhyung Kim wrote:
> Hi guys,
> 
> On Thu, Jul 24, 2014 at 11:49 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Jul 24, 2014 at 10:57:47AM -0300, Arnaldo Carvalho de Melo wrote:
> >> Em Thu, Jul 24, 2014 at 02:57:51PM +0200, Jiri Olsa escreveu:
> >> > On Wed, Jul 09, 2014 at 02:28:12PM +0900, Namhyung Kim wrote:
> >> > > Set column width and do not change it if user gives -w/--column-widths
> >> > > option.  It'll truncate longer symbols than the width if exists.
> >> >
> >> > SNIP
> >> >
> >> > > --- a/tools/perf/util/sort.c
> >> > > +++ b/tools/perf/util/sort.c
> >> > > @@ -70,7 +70,9 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
> >> > >                                  size_t size, unsigned int width)
> >> > >  {
> >> > >   const char *comm = thread__comm_str(he->thread);
> >> > > - return repsep_snprintf(bf, size, "%-*s:%5d", width - 6,
> >> > > +
> >> > > + width = max(7U, width) - 6;
> >> > > + return repsep_snprintf(bf, size, "%-*.*s:%5d", width, width,
> >> > >                          comm ?: "", he->thread->tid);
> >> > >  }
> >> >
> >> > also we now print out all sort headers left alligned, which is wrong for
> >> > sort_thread header: "Command:  Pid' that mirrors value strings with ':'
> >> > being aligned
> >> >
> >> > maybe something like in attached patch..?
> >> >
> >> > thanks,
> >> > jirka
> >> >
> >> >
> >> > ---
> >> > diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> >> > index f89714329c0f..fbbe86b7f63c 100644
> >> > --- a/tools/perf/util/sort.c
> >> > +++ b/tools/perf/util/sort.c
> >> > @@ -78,6 +78,7 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
> >> >
> >> >  struct sort_entry sort_thread = {
> >> >     .se_header      = "Command:  Pid",
> >> > +   .se_header_right= true,
> >>
> >> Is this just for the header? Perhaps its more clearly named .se_right_justify?
> >
> > yep, it's just for header.. let's see Namhyung might have better
> > idea how to handle this problem
> 
> I think it still needs to be left-aligned.  So I'd rather change the
> order - i.e. "Pid: Command".  Is it okay for you?

yes, jirka
