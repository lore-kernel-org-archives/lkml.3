Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3JVJHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:07:38 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:56328 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3JVJHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:07:34 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH v3 0/3] perf: add option to limit callchain stack scan to increase speed
References: <1382367819-19643-1-git-send-email-Waiman.Long@hp.com>
Date: Tue, 22 Oct 2013 18:07:05 +0000
In-Reply-To: <1382367819-19643-1-git-send-email-Waiman.Long@hp.com> (Waiman
	Long's message of "Mon, 21 Oct 2013 11:03:36 -0400")
Message-ID: <871u3dkwmu.fsf@danjae.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Waiman,

On Mon, 21 Oct 2013 11:03:36 -0400, Waiman Long wrote:
> v2->v3:
>  - Fix the commit log in the second patch which causes "git am" to fail.
>  - Remove the 1st patch in v2 as the problem will be fixed by another
>    patch from Arnaldo.
>
> v1->v2:
>  - Include a compilation fix patch and a code streamlining patch
>    into the patch set.
>  - Use the __stringify() macro in stringify.h instead of adding a
>    duplicate macro.
>  - Add the --max-stack option to perf-top as well.
>
> This perf patch set contains the following changes:
>
> Patch 1 - Streamline the append_chain() function to make it run a bit
>           faster.
> Patch 2 - Add a --max-stack option to perf-report to speed up its
>           processing at the expense of less backtrace information
>           available.
> Patch 3 - Add a similar --max-stack option to perf-top.

At first, thank you for tackling this.  It was really a problem using
callchain on non trivial perf session.  But there's another effort to
address this problem in other direction.  You might want to see below
link [1].  Patch 1/8 does the thing and it seems Arnaldo already merged
it into his tree.

Arnaldo, is there any issue prevents others from being merged?

[1] https://lkml.org/lkml/2013/10/11/16

Thanks,
Namhyung
