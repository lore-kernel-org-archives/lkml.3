Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3JZQ5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 12:57:39 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39829 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3JZQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 12:57:38 -0400
MIME-Version: 1.0
In-Reply-To: <20131025145625.GB1196@krava.brq.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
	<1382533085-7166-2-git-send-email-eranian@google.com>
	<20131025145625.GB1196@krava.brq.redhat.com>
Date: Sat, 26 Oct 2013 18:57:37 +0200
Message-ID: <CABPqkBTHnRXwKVJucKRuPA1cLzKur2dbkKu_PS5sQKK2XjovnQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] perf: add active_entry list head to struct perf_event
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 4:56 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Oct 23, 2013 at 02:58:02PM +0200, Stephane Eranian wrote:
> > This patch adds a new fields to the struct perf_event.
> > It is intended to be used to chain events which are
> > active (enabled). It helps in the hardware layer
> > for PMU which do not have actual counter restrictions, i.e.,
> > free running read-only counters. Active events are chained
> > as opposed to being tracked via the counter they use.
> >
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> > ---
> >  include/linux/perf_event.h |    1 +
> >  kernel/events/core.c       |    1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 2e069d1..a376384 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -435,6 +435,7 @@ struct perf_event {
> >       struct perf_cgroup              *cgrp; /* cgroup event is attach to */
> >       int                             cgrp_defer_enabled;
> >  #endif
> > +     struct list_head                active_entry;
>
> Could this be in union with 'hlist_entry' ? It looks
> as 'same purpose' and 'mutualy exclusive stuff.
>
You're saying that I could use the hlist_entry field because
it is currently only used by the sw events in the generic layer.
But it seems to be a complicated rcu list for the purpose here.
