Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaGIIYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:24:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36955 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaGIIX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:23:59 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] perf timechart io mode
References: <1404835423-23098-1-git-send-email-stfomichev@yandex-team.ru>
Date: Wed, 09 Jul 2014 17:23:50 +0900
In-Reply-To: <1404835423-23098-1-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Tue, 8 Jul 2014 20:03:39 +0400")
Message-ID: <87r41v2b55.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Tue,  8 Jul 2014 20:03:39 +0400, Stanislav Fomichev wrote:
> This patchset adds IO mode: instead of process time we record io syscalls
> and then draw timechart of writes/reads/tx/rx/polls.
>
> v6:
>   - v5 didn't actually contained 'converted consistency checks' fix, so
>     respinning the series once again with the fix folded;
>     Namhyung, can I still keep your Acked-By?

Sure thing!  For the series,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>     Jiri, can you please pull it?
>
> v5:
>   - converted consistency check errors to warnings so we can tolerate
>     some perf.data errors
>   - added more info to 'implement IO mode' changelog
>
> v4:
>   - another attempt for fix segfault when skipping invalid tracepoints
>   - added new patch to fix rendering in Firefox
>
> v3:
>   - fixed segfault when skipping invalid tracepoints
>   - added ms/us units support for --io-xyz time options
>   - fixed missing boxes on Firefox
>
> v2:
>   - separated start_time fix into distinct commit
>   - separated --io-xyz options into distinct commit
>   - fixed 'error' shadowing
>   - initialized variables in declaration when possible
>   - removed assert usage
>   - fprintf -> pr_err
>   - removed wrongly placed __maybe_unused
>
> Stanislav Fomichev (4):
>   perf timechart: fix rendering in Firefox
>   perf timechart: implement IO mode
>   perf timechart: conditionally update start_time on fork
>   perf timechart: add more options to IO mode
>
>  tools/perf/Documentation/perf-timechart.txt |  38 +-
>  tools/perf/builtin-timechart.c              | 693 +++++++++++++++++++++++++++-
>  tools/perf/util/svghelper.c                 | 168 +++++--
>  tools/perf/util/svghelper.h                 |   6 +-
>  4 files changed, 845 insertions(+), 60 deletions(-)
