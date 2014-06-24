Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaFXGnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:43:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50405 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaFXGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:43:49 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] perf timechart io mode
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 24 Jun 2014 15:43:44 +0900
In-Reply-To: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Fri, 20 Jun 2014 14:29:47 +0400")
Message-ID: <8761jq7qov.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Fri, 20 Jun 2014 14:29:47 +0400, Stanislav Fomichev wrote:
> This patchset adds IO mode: instead of process time we record io syscalls
> and then draw timechart of writes/reads/tx/rx/polls.

Nice work!  For the series,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


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
>  tools/perf/builtin-timechart.c              | 686 +++++++++++++++++++++++++++-
>  tools/perf/util/svghelper.c                 | 168 +++++--
>  tools/perf/util/svghelper.h                 |   6 +-
>  4 files changed, 838 insertions(+), 60 deletions(-)
