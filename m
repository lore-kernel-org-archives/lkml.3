Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3HUJzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:55:09 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:60097 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3HUJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130815102620.GN24092@twins.programming.kicks-ass.net>
References: <1376394957-31691-1-git-send-email-eranian@google.com>
	<1376394957-31691-2-git-send-email-eranian@google.com>
	<20130815102620.GN24092@twins.programming.kicks-ass.net>
Date: Wed, 21 Aug 2013 11:55:05 +0200
Message-ID: <CABPqkBSXgen_yW+3snqyiP9WWPeBc0WQCSqcipVqgSO0AJp8sg@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] perf: add attr->mmap2 attribute to an event
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 12:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Aug 13, 2013 at 01:55:56PM +0200, Stephane Eranian wrote:
>
> > @@ -638,6 +639,25 @@ enum perf_event_type {
> >        */
> >       PERF_RECORD_SAMPLE                      = 9,
> >
> > +     /*
> > +      * The MMAP2 records are an augmented version of MMAP, they add
> > +      * maj, min, ino numbers to be used to uniquely identify each mapping
> > +      *
> > +      * struct {
> > +      *      struct perf_event_header        header;
> > +      *
> > +      *      u32                             pid, tid;
> > +      *      u64                             addr;
> > +      *      u64                             len;
> > +      *      u64                             pgoff;
> > +      *      u32                             maj;
> > +      *      u32                             min;
> > +      *      u64                             ino;
> > +      *      char                            filename[];
>
> Did you forget the sample_id stuff?
>
>                 struct sample_id                sample_id;
>
This is added automatically by the kernel if attr->sample_id_all is
set. I checked the perf tool. It enables this when you're sampling
on more than one event. So everything works as expected.
I assume you comment was about adding the sample_id in the
description of the struct. I will add that.


>
> > +      * };
> > +      */
> > +     PERF_RECORD_MMAP2                       = 10,
> > +
> >       PERF_RECORD_MAX,                        /* non-ABI */
> >  };
