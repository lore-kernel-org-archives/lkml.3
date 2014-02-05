Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaBEBuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:50:39 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49908 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaBEBuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:50:37 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-a5-52f198eca328
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 04/22] perf tools: Add --list report option
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
	<1391377150-23920-5-git-send-email-jolsa@redhat.com>
Date: Wed, 05 Feb 2014 10:50:36 +0900
In-Reply-To: <1391377150-23920-5-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sun, 2 Feb 2014 22:38:52 +0100")
Message-ID: <87iosu1g5v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Feb 2014 22:38:52 +0100, Jiri Olsa wrote:
> Adding --list report option to display entries sequentialy:
>
>   $ perf report --list --stdio
>   ...
>        0.00%       13151.543527 +000000.000000       ls  [kernel.kallsyms]  [k] native_write_msr_safe
>        0.00%       13151.543530 +000000.000003       ls  [kernel.kallsyms]  [k] native_write_msr_safe
>        0.00%       13151.543532 +000000.000005       ls  [kernel.kallsyms]  [k] native_write_msr_safe
>        0.00%       13151.543534 +000000.000007       ls  [kernel.kallsyms]  [k] native_write_msr_safe
>        0.05%       13151.543536 +000000.000009       ls  [kernel.kallsyms]  [k] native_write_msr_safe
>        0.92%       13151.543538 +000000.000011       ls  [kernel.kallsyms]  [k] perf_event_comm
>       14.52%       13151.543560 +000000.000033       ls  [kernel.kallsyms]  [k] uprobe_mmap
>       30.10%       13151.543878 +000000.000351       ls  ld-2.17.so         [.] _dl_setup_hash
>       29.30%       13151.544531 +000000.001004       ls  ls                 [.] gobble_file.constprop.49
>       25.09%       13151.545613 +000000.002086       ls  [kernel.kallsyms]  [k] _cond_resched

Hmm.. it seems what this --list option does is very similar to
what "perf script -f time,comm,dso,sym,ip" tries to do, no?

Thanks,
Namhyung
