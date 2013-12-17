Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3LQLXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:23:10 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:55825 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3LQLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:23:08 -0500
Date: Tue, 17 Dec 2013 12:23:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, namhyung@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com
Subject: Re: [PATCH 5/5] perf timechart: add emphasize option
Message-ID: <20131217112303.GB27791@gmail.com>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
 <20131216193800.GA19283@ghostprotocols.net>
 <20131217093855.GA3345@stfomichev-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217093855.GA3345@stfomichev-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:

> This option highlights tasks (using different color) that run more than given
> duration or tasks with given name.

Please give a sample usage command line and a sample output. (the 
highlighting can be done using ASCII escape sequences in the changelog 
as well.)

> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/Documentation/perf-timechart.txt |  4 ++++
>  tools/perf/builtin-timechart.c              | 21 ++++++++++++++++++++-
>  tools/perf/util/svghelper.c                 | 23 ++++++++++++++++++++---
>  tools/perf/util/svghelper.h                 |  4 +++-
>  4 files changed, 47 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
> index 367c1be0551c..aac589b0d377 100644
> --- a/tools/perf/Documentation/perf-timechart.txt
> +++ b/tools/perf/Documentation/perf-timechart.txt
> @@ -62,6 +62,10 @@ $ perf timechart
>  -t::
>  --topology::
>          Sort CPUs according to topology.
> +-e::
> +--emphasize::

So -e comes with an option - the syntax to describe those in manpages 
is:

  -e::
  --emphasize=<duration_nsecs|task_name>::

or so.

> +        Emphasize tasks which were running at least given number of
> +        nanoseconds or tasks with given name.

So the information in the changelog, that 'emphasize' means 'highlight 
via coloring' is lost in the documentation of the option, making it 
rather hard for users to discover and appreciate this feature...

It's also not made clear that the option can take a numeric input, and 
if the input is numeric, it is interpreted as a task name.

So please make features more approachable!

Thanks,

	Ingo
