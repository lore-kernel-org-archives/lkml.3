Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab3LKTap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:30:45 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56678 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3LKTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:30:44 -0500
Message-ID: <52A8BD60.80300@gmail.com>
Date: Wed, 11 Dec 2013 12:30:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 14/71] perf tools: Add cpu to struct thread
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-15-git-send-email-alexander.shishkin@linux.intel.com>
In-Reply-To: <1386765443-26966-15-git-send-email-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 5:36 AM, Alexander Shishkin wrote:

> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 55f3608..52fbfb6 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1412,3 +1412,29 @@ pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
>
>   	return thread->pid_;
>   }
> +
> +int machine__get_thread_cpu(struct machine *machine, pid_t tid, pid_t *pid)
> +{
> +	struct thread *thread = machine__find_thread(machine, tid);
> +
> +	if (!thread)
> +		return -1;
> +
> +	if (pid)
> +		*pid = thread->pid_;

Why is a 'get' function modifying the thread data?

David
