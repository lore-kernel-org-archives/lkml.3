Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaFXIld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:41:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaFXIlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:41:31 -0400
Date: Tue, 24 Jun 2014 10:41:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140624084113.GC31390@krava.redhat.com>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:29:47PM +0400, Stanislav Fomichev wrote:
> This patchset adds IO mode: instead of process time we record io syscalls
> and then draw timechart of writes/reads/tx/rx/polls.
> 
> v4:
>   - another attempt for fix segfault when skipping invalid tracepoints
>   - added new patch to fix rendering in Firefox

hum, got this when trying:

[jolsa@krava perf]$ sudo ./perf timechart record -I
^C[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 1.071 MB perf.data (~46806 samples) ]
[jolsa@krava perf]$ ./perf timechart
Invalid previous event (non-zero)!
0x113f80 [0x8]: failed to process type: 68

jirka

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
> 
> -- 
> 1.8.3.2
> 
