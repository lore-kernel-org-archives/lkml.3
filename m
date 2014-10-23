Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaJWXxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:53:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:56996 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbaJWXxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:53:07 -0400
Date: Thu, 23 Oct 2014 20:53:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, jolsa@redhat.com, adrian.hunter@intel.com,
        Waiman.Long@hp.com, linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH v2 RESEND] perf tools: makes CPUINFO_PROC to array for
 different kernel version
Message-ID: <20141023235302.GU14687@kernel.org>
References: <1413963614-7251-1-git-send-email-wangnan0@huawei.com>
 <87k33qe5be.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k33qe5be.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 24, 2014 at 08:26:13AM +0900, Namhyung Kim escreveu:
> On Wed, 22 Oct 2014 15:40:14 +0800, Wang Nan wrote:
> > After kernel 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
> > /proc/cpuinfo replaces 'Processor' to 'model name'. This patch makes
> > CPUINFO_PROC to an array and provides two choices for ARM, makes it
> > compatible for different kernel version.

> > v1 -> v2: minor changes as suggested by Namhyung Kim:

> >  - Doesn't pass @h and @evlist to __write_cpudesc;
> >  - Coding style fix.

> > Signed-off-by: Wang Nan <wangnan0@huawei.com>
 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

So now this will work with older kernels and new ones? Cool, thanks for
working on it, but:

[acme@ssdandy linux]$ patch -p1 < /wb/1.patch 
patching file tools/perf/perf.h
Hunk #1 FAILED at 6.
Hunk #2 FAILED at 15.
Hunk #3 FAILED at 25.
Hunk #4 FAILED at 40.
Hunk #5 FAILED at 74.
Hunk #6 FAILED at 91.
6 out of 6 hunks FAILED -- saving rejects to file tools/perf/perf.h.rej
patching file tools/perf/util/header.c
Hunk #1 succeeded at 579 (offset 29 lines).
Hunk #2 succeeded at 636 (offset 29 lines).
[acme@ssdandy linux]$

[acme@ssdandy linux]$ git log --oneline tools/perf/perf.h | head -10
87c43ee perf tools: Export usage string and option table of perf record
72a128a perf tools: Move callchain config from record_opts to callchain_param
73a31b7 perf tools: Move ACCESS_ONCE from perf.h header
82baa0e perf tools: Move sys_perf_event_open function from perf.h
43599d1 perf tools: Move syscall and arch specific defines from perf.h
2c83bc0 perf tools: Move perf_call_graph_mode enum from perf.h
0776eb5 perf tools: Move sample data structures from perf.h
36446f4 perf tools: Remove PR_TASK_PERF_EVENTS_* from perf.h
273a0a7 perf tools: Remove asmlinkage define from perf.h
1b7ae1c perf tools: Remove min define from perf.h
[acme@ssdandy linux]$

This is:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core

If you don't have time to fix this up, I'll try to find time tomorrow
and do it.

- Arnaldo
