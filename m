Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3FZCxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:53:33 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52236 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3FZCxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:53:32 -0400
X-AuditID: 9c930197-b7bf9ae000003cc9-9c-51ca57ab9bec
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf tools: Introduce new -P/--parent-deep report option
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
	<1372161253-22081-5-git-send-email-jolsa@redhat.com>
Date: Wed, 26 Jun 2013 11:53:30 +0900
In-Reply-To: <1372161253-22081-5-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Tue, 25 Jun 2013 13:54:12 +0200")
Message-ID: <87sj051t1x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, 25 Jun 2013 13:54:12 +0200, Jiri Olsa wrote:
> Introducing new -P/--parent-deep report option. It does the
> same as '-p' but it force the deep search of the callchain
> and looks for the deepest possible match.
>
> The -p option searches for the first match of the parent
> pattern in the callchain.
>
>   $ perf report -i perf.data.delete -p perf_session__delete -s parent
>
>   +  99.51%  [other]
>   +   0.46%  perf_session__delete_dead_threads
>   +   0.03%  perf_session__delete
>   +   0.00%  perf_session__delete_threads
>
> so we got multiple 'different' matches instancies, while
> they all belong under perf_session__delete function:
>
>   $ perf report -i perf.data.delete -P perf_session__delete -s parent
>
>   +  99.51%  [other]
>   +   0.49%  perf_session__delete
>
> NOTE the 'p' vs 'P' difference in above commands above.

I guess using --inverted (-G) option with -p does the job.

Thanks,
Namhyung
