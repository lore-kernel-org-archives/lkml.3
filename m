Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3JHM2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:28:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3JHM2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:28:30 -0400
Date: Tue, 8 Oct 2013 09:28:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <bitbucket@online.de>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] perf tools: fix missing default initialization for
 tool->mmap2
Message-ID: <20131008122805.GB3955@infradead.org>
References: <20131008105016.GA2446@quad>
 <20131008115929.GA2303@gmail.com>
 <CABPqkBSiWcAZ4CxjJ8fvQ6Jm7Y242-ehHd-X4y0T70wY_dy+Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSiWcAZ4CxjJ8fvQ6Jm7Y242-ehHd-X4y0T70wY_dy+Zw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 08, 2013 at 02:02:06PM +0200, Stephane Eranian escreveu:
> On Tue, Oct 8, 2013 at 1:59 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >> --- a/tools/perf/util/session.c
> >> +++ b/tools/perf/util/session.c
> >> @@ -256,6 +256,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
> >>               tool->sample = process_event_sample_stub;
> >>       if (tool->mmap == NULL)
> >>               tool->mmap = process_event_stub;
> >> +     if (tool->mmap2 == NULL)
> >> +             tool->mmap2 = process_event_stub;
> >>       if (tool->comm == NULL)
> >>               tool->comm = process_event_stub;
> >>       if (tool->fork == NULL)

> > I think it's already fixed in tip:perf/urgent:

> >   6adb0b0ae26f perf tools: Add default handler for mmap2 events

> Ok, it's good then.
> Thanks for checking.

Yeah, since 'perf sched' doesn't use mmap records, just relying on the
stub default handler is enough.

- Arnaldo
