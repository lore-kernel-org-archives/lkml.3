Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3AROGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:06:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab3AROGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:06:11 -0500
Date: Fri, 18 Jan 2013 15:05:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2 2/2] perf stat: add interval printing
Message-ID: <20130118140557.GC1579@krava>
References: <1358514388-4344-1-git-send-email-eranian@google.com>
 <1358514388-4344-3-git-send-email-eranian@google.com>
 <20130118135018.GB1579@krava>
 <CABPqkBS5uOSqM323XjRFwLXen29R=9Lejmp3EuSt3JhJa6fjHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS5uOSqM323XjRFwLXen29R=9Lejmp3EuSt3JhJa6fjHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:59:58PM +0100, Stephane Eranian wrote:
> On Fri, Jan 18, 2013 at 2:50 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Fri, Jan 18, 2013 at 02:06:28PM +0100, Stephane Eranian wrote:
> >> This patch adds a new printing mode for perf stat.
> >> It allows internval printing. That means perf stat
> >
> > SNIP
> >
> >>       const char * const stat_usage[] = {
> >> @@ -1245,12 +1356,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
> >>               usage_with_options(stat_usage, options);
> >>               return -1;
> >>       }
> >> +     if (interval < 0 || (interval > 0 && interval < 100)) {
> >> +             pr_err("print interval must be >= 100ms\n");
> >> +             usage_with_options(stat_usage, options);
> >> +             return -1;
> >> +     }
> >>
> >>       list_for_each_entry(pos, &evsel_list->entries, node) {
> >>               if (perf_evsel__alloc_stat_priv(pos) < 0 ||
> >>                   perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
> >>                       goto out_free_fd;
> >>       }
> >> +     if (interval) {
> >> +             list_for_each_entry(pos, &evsel_list->entries, node) {
> >> +                     if (perf_evsel__alloc_prev_raw_counts(pos) < 0)
> >> +                             goto out_free_fd;
> >> +             }
> >> +     }
> >
> > this could be squeezed up into the previous loop,
> >
> The raw_counts are lazily allocated. So you'd have to have
> 
> if (interval)
>      perf_evsel__alloc_prev_raw_counts(pos);
> 
> in the body of the loop.

right,
jirka
