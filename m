Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3JHKvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:51:17 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:55934 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab3JHKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <1381229421.15686.17.camel@marge.simpson.net>
References: <1381221715.15686.3.camel@marge.simpson.net>
	<CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
	<1381227252.15686.9.camel@marge.simpson.net>
	<1381227659.15686.11.camel@marge.simpson.net>
	<CABPqkBQD9TE7RbP-auXO060aU1QNU=RUw2QZvoF39CCqpzdC4w@mail.gmail.com>
	<CABPqkBSpTPttig8uKdR2KJba8rwOe3P1sKPjkVizVGH=H+w-9Q@mail.gmail.com>
	<1381229421.15686.17.camel@marge.simpson.net>
Date: Tue, 8 Oct 2013 12:51:13 +0200
Message-ID: <CABPqkBQzgfxYLbpJFy3bWZZWby4X92+q6za5S7o6QXjk6qkmFg@mail.gmail.com>
Subject: Re: perf: perf sched lat segfault - bisected
From: Stephane Eranian <eranian@google.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

I posted the fix now. It was somewhere else. But you got the idea.
thanks for reporting the problem.

On Tue, Oct 8, 2013 at 12:50 PM, Mike Galbraith <bitbucket@online.de> wrote:
> On Tue, 2013-10-08 at 12:36 +0200, Stephane Eranian wrote:
>> Mike,
>>
>> I found the problem in perf. The tool->mmap2 pointer is NULL for sched tool.
>> Let me send you a patch to fix this.
>
> Ah, no need.  It's probably something like so, which fixed it.
>
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index d8c51b2f263f..a60d14dd18e7 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -1658,6 +1658,7 @@ static struct perf_sched sched = {
>                 .comm            = perf_event__process_comm,
>                 .lost            = perf_event__process_lost,
>                 .fork            = perf_sched__process_fork_event,
> +               .mmap2           = perf_event__process_mmap2,
>                 .ordered_samples = true,
>         },
>         .cmp_pid              = LIST_HEAD_INIT(sched.cmp_pid),
>
>
