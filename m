Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaLIKRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:17:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbaLIKRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:17:12 -0500
Date: Tue, 9 Dec 2014 11:16:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/8] perf data: Add perf data to CTF conversion support
Message-ID: <20141209101629.GC2516@krava.brq.redhat.com>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
 <1417623842-14331-4-git-send-email-jolsa@kernel.org>
 <CAM9d7cgzo95YOm9Y8WaLNhZ8aY97Te33_KihWG0yfXDVBjMLeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cgzo95YOm9Y8WaLNhZ8aY97Te33_KihWG0yfXDVBjMLeg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 05:13:23PM +0900, Namhyung Kim wrote:
> On Thu, Dec 4, 2014 at 1:23 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > index 33864dd316e5..2d3229ec0a23 100644
> > --- a/tools/perf/Makefile.perf
> > +++ b/tools/perf/Makefile.perf
> > @@ -402,6 +402,10 @@ LIB_OBJS += $(OUTPUT)util/tsc.o
> >  LIB_OBJS += $(OUTPUT)util/cloexec.o
> >  LIB_OBJS += $(OUTPUT)util/thread-stack.o
> >
> > +ifneq ($(NO_LIBBABELTRACE),1)
> 
> I think we usually do it with just "ifndef".

ok

SNIP

> > +       }
> > +
> > +       if (type & PERF_SAMPLE_TID) {
> > +               ret = value_set_s32(cw, event, "tid", sample->tid);
> > +               if (ret)
> > +                       return -1;
> > +
> > +               ret = value_set_s32(cw, event, "pid", sample->tid);
> 
> sample->pid ?

yes

> 
> 
> > +               if (ret)
> > +                       return -1;
> > +       }
> > +
> > +       if ((type & PERF_SAMPLE_ID) ||
> > +           (type & PERF_SAMPLE_IDENTIFIER)) {
> > +               ret = value_set_u64(cw, event, "id", sample->id);
> > +               if (ret)
> > +                       return -1;
> > +       }
> > +
> > +       if (type & PERF_SAMPLE_STREAM_ID) {
> > +               ret = value_set_u64(cw, event, "stream_id", sample->id);
> 
> sample->stream_id ?

yes

thanks,
jirka
