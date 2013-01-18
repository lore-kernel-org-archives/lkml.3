Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3AROJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:09:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab3AROJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:09:15 -0500
Date: Fri, 18 Jan 2013 15:09:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2 2/2] perf stat: add interval printing
Message-ID: <20130118140902.GD1579@krava>
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

SNIP

> >> -     if (status != -1)
> >> +     if (status != -1 && !interval)
> >>               print_stat(argc, argv);
> >
> > The way this is done prevents final stats to be printed,
> > which seems unfortunate.
> >
> This is on purpose. All we care about here is the spaced deltas.
> Note that I also removed the shadow stats. Tried to make them
> work for a while but it did not make sense especially for -a -A.
> I don't think it even works right now.
> 
> > Actually I don't mind that much, because I haven't even thought about
> > this feature, but looks like it could be done separately with no affect
> > to final counts.
> >
> Initially I had it as raw_counts, prev_raw_counts. But then it would
> cause problems with the stats. So I simplified everything, it uses
> less memory and gives me the output I care about.
> 
> If you want total count, then don't use this new option. The results
> are to be fed to a plotter, so the final counts are useless and complicate
> the post-processing.

ok, agreed

jirka

> 
> > But since you probably use it mostly for feeding some graph ploting
> > program, it's probably fine.. just feels wrong ;-)
