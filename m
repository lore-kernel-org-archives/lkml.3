Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3K2B6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 20:58:54 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49649 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3K2B6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 20:58:48 -0500
Message-ID: <5297F4D6.3070408@gmail.com>
Date: Thu, 28 Nov 2013 18:58:46 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/8] perf sched: Introduce timehist command
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>	<1384806771-2945-7-git-send-email-dsahern@gmail.com>	<CAM9d7cg4t_HD-225GawXnUHXG1D-f91ZDS_xsfy19baHSM624w@mail.gmail.com>	<529768D3.1000507@gmail.com> <87k3fsowwe.fsf@sejong.aot.lge.com>
In-Reply-To: <87k3fsowwe.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 5:48 PM, Namhyung Kim wrote:
> Do we really need to look up the callchain to find out an idle thread?
>
>    $ perf sched script | grep swapper | head
>           swapper     0 [001] 4294177.326996: sched:sched_switch: prev_comm=swapper/1 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=Xorg next_pid=1094 next_prio=120
>           swapper     0 [010] 4294177.327019: sched:sched_switch: prev_comm=swapper/10 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=perf next_pid=13902 next_prio=120
>              perf 13901 [002] 4294177.327074: sched:sched_switch: prev_comm=perf prev_pid=13901 prev_prio=120 prev_state=S ==> next_comm=swapper/2 next_pid=0 next_prio=120
>           swapper     0 [004] 4294177.327096: sched:sched_switch: prev_comm=swapper/4 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=synergys next_pid=1521 next_prio=120
>           swapper     0 [000] 4294177.327102: sched:sched_switch: prev_comm=swapper/0 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=gnome-terminal next_pid=2392 next_prio=120
>              Xorg  1094 [001] 4294177.327112: sched:sched_switch: prev_comm=Xorg prev_pid=1094 prev_prio=120 prev_state=S ==> next_comm=swapper/1 next_pid=0 next_prio=120
>           swapper     0 [007] 4294177.327122: sched:sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=perf next_pid=13902 next_prio=120
>      migration/10    58 [010] 4294177.327124: sched:sched_switch: prev_comm=migration/10 prev_pid=58 prev_prio=0 prev_state=S ==> next_comm=swapper/10 next_pid=0 next_prio=120
>          synergys  1521 [004] 4294177.327144: sched:sched_switch: prev_comm=synergys prev_pid=1521 prev_prio=120 prev_state=S ==> next_comm=swapper/4 next_pid=0 next_prio=120
>    gnome-terminal  2392 [000] 4294177.327286: sched:sched_switch: prev_comm=gnome-terminal prev_pid=2392 prev_prio=120 prev_state=S ==> next_comm=swapper/0 next_pid=0 next_prio=120
>
> It seems every idle/swapper thread for each cpu has a pid of 0.

The command was developed using context-switch events. Try the next 
patch and use:

perf record -e cs -c 1 -ag
perf sched timehist

David
