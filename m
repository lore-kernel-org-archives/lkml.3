Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3GIFWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:22:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47563 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIFWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:22:38 -0400
X-AuditID: 9c93016f-b7bdeae000000e34-93-51db9e1cd18d
From: Namhyung Kim <namhyung@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Minor perf build fixes
References: <1373019377-12741-1-git-send-email-artagnon@gmail.com>
Date: Tue, 09 Jul 2013 14:22:36 +0900
In-Reply-To: <1373019377-12741-1-git-send-email-artagnon@gmail.com> (Ramkumar
	Ramachandra's message of "Fri, 5 Jul 2013 15:46:13 +0530")
Message-ID: <87zjtwxq77.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ramkumar,

On Fri,  5 Jul 2013 15:46:13 +0530, Ramkumar Ramachandra wrote:
> Hi,
>
> After Namhyung's review of the first iteration, I realized that I'd
> made a few mistakes.  This iteration should be much better.
>
> [1/4] is the same as before.
>
> [2/4] is new, and is used in [4/4].
>
> [3/4] introduces a util/perf-perl.h to include <perl.h> with #pragma
> statements, hence eliminating duplication.  It then updates Context.xs
> and trace-event-perl.c to use this new header.

I prefer the name being "perl.h" and use #include_next as we include the
'util' directory in the compiler search path.

Other than that, the change looks good to me.

>
> Also, notice that feature-tests.mak has not been touched in this
> iteration: the Perl check passes without needing the #pragma
> statements (although I'm not sure why exactly).

I guess it's because FLAGS_PERL_EMBED doesn't contain the usual perf
CFLAGS which has -Werror.

Thanks,
Namhyung

>
> Thanks.
>
> Ramkumar Ramachandra (4):
>   perf/Makefile: do not open-code shell-sq
>   perf/Perf-Trace-Util: fix broken include in Context.xs
>   perf: squelch warnings from perl.h to compile-pass
>   perf/Perf-Trace-Util: regenerate Context.c
>
>  tools/perf/Makefile                                |   2 +-
>  tools/perf/config/Makefile                         |  23 ++-
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.c  | 215 +++++++++++++++++----
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   6 +-
>  tools/perf/util/perf-perl.h                        |  10 +
>  .../perf/util/scripting-engines/trace-event-perl.c |   2 +-
>  6 files changed, 199 insertions(+), 59 deletions(-)
>  create mode 100644 tools/perf/util/perf-perl.h
