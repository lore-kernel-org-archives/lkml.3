Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3LBJfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:35:10 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49525 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab3LBJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:35:07 -0500
X-Sasl-enc: AasgxjSrHc5vEjdx8Om92XhoainrE9S7CUI8gITRKJ1U 1385976906
Message-ID: <529C5448.7090902@iki.fi>
Date: Mon, 02 Dec 2013 11:35:04 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 0/3] perf tools: Show time info (v1)
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 08:53 AM, Namhyung Kim wrote:
> Sometimes users might want to see time information along with the
> performance result but the perf cannot provide it currently.
>
> In this patchset, I added such feature using sample->time.  When the
> perf processes sample events, it calculate time info and update last
> timestamp.  It keeps the last timestamp for each evsel (and for each
> cpu if it's a per-cpu session).
>
> It guesses whether a session is per-cpu if it found PERF_SAMPLE_CPU in
> a evsel->attr.sample_type since I couldn't find a better way.  However
> it'll have a trouble if used with tracepoint events since they require
> the cpu info in the sample_type even for the per-thread sessions.
>
> The sample time will usually be proportional to the overhead but
> sometimes it show a different result especially in idle state.
>
> With this patch, perf report can show time information in the header
> (on --stdio output only for now) and a new column which can be enabled
> by --show-time-info option.
>
>    $ perf record -- perf bench sched messaging
>    $ perf report --stdio --show-time-info
>
>    # Samples: 10K of event 'cycles'
>    # Event count (approx.): 5168954556
>    # Total sampling time  : 0.179102 (sec)       <--- here
>    #
>    # Overhead        Time          Command       Shared Object                        Symbol
>    # ........  ..........  ...............  ..................  ............................
>    #
>         6.59%    0.006093  sched-messaging  [unknown]           [.] 0x0000003153ebc7ed
>         4.81%    0.005354  sched-messaging  [kernel.kallsyms]   [k] copy_user_generic_string
>         3.89%    0.004098  sched-messaging  [kernel.kallsyms]   [k] avc_has_perm_flags
>         3.77%    0.003630  sched-messaging  [kernel.kallsyms]   [k] unix_stream_recvmsg
>         3.37%    0.003733  sched-messaging  [kernel.kallsyms]   [k] _raw_spin_lock
>         2.97%    0.003489  sched-messaging  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
>         2.73%    0.002615  sched-messaging  [kernel.kallsyms]   [k] __slab_free
>         2.56%    0.002392  sched-messaging  [kernel.kallsyms]   [k] page_fault
>         2.45%    0.002572  sched-messaging  [kernel.kallsyms]   [k] sock_alloc_send_pskb
>
> I put the series on 'perf/time-sample-v1' branch in my tree:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
> Any comments are welcome, thanks

Reviewed-by: Pekka Enberg <penberg@kernel.org>

for the whole series.
