Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3LBJdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:33:15 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37553 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab3LBJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:33:09 -0500
X-Sasl-enc: q7xk1RrTGMM4zBet1UBksJG6+Zgv5ABk3oivf6mw/AB7 1385976788
Message-ID: <529C53D2.8020203@iki.fi>
Date: Mon, 02 Dec 2013 11:33:06 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
CC: namhyung@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/2] perf sched: Introduce timehist command - v2
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com> <1385943795-11761-2-git-send-email-dsahern@gmail.com>
In-Reply-To: <1385943795-11761-2-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 02:23 AM, David Ahern wrote:
> 'perf sched timehist' provides an analysis of scheduling events.
>
> Example usage:
>      perf sched record -- sleep 1
>      perf sched timehist
>
> By default it shows the individual schedule events, including the time between
> sched-in events for the task, the task scheduling delay (time between wakeup
> and actually running) and run time for the task:
>
>             time cpu  task name[tid/pid]    b/n time sch delay  run time
>    ------------- ---- -------------------- --------- --------- ---------
>     79371.874569 [11] gcc[31949]               0.014     0.000     1.148
>     79371.874591 [10] gcc[31951]               0.000     0.000     0.024
>     79371.874603 [10] migration/10[59]         3.350     0.004     0.011
>     79371.874604 [11] <idle>                   1.148     0.000     0.035
>     79371.874723 [05] <idle>                   0.016     0.000     1.383
>     79371.874746 [05] gcc[31949]               0.153     0.078     0.022

What does "b/n time" mean?

I'm seeing rather large "sch delay" numbers on Fedora 19's default 
kernel that seem like a data error of some sort:

     4500.663117 [02] fix_client[7216]         0.007 
18446744073708.033     1.786

Scheduling delays don't seem to be part of "-s" summary output. Why?

                             Pekka
