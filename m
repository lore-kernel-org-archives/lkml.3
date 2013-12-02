Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3LBOeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:34:07 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47353 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3LBOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:34:03 -0500
Message-ID: <529C9A56.4050306@gmail.com>
Date: Mon, 02 Dec 2013 07:33:58 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
CC: namhyung@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/2] perf sched: Introduce timehist command - v2
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com> <1385943795-11761-2-git-send-email-dsahern@gmail.com> <529C53D2.8020203@iki.fi>
In-Reply-To: <529C53D2.8020203@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 2:33 AM, Pekka Enberg wrote:
> On 12/02/2013 02:23 AM, David Ahern wrote:
>> 'perf sched timehist' provides an analysis of scheduling events.
>>
>> Example usage:
>>      perf sched record -- sleep 1
>>      perf sched timehist
>>
>> By default it shows the individual schedule events, including the time
>> between
>> sched-in events for the task, the task scheduling delay (time between
>> wakeup
>> and actually running) and run time for the task:
>>
>>             time cpu  task name[tid/pid]    b/n time sch delay  run time
>>    ------------- ---- -------------------- --------- --------- ---------
>>     79371.874569 [11] gcc[31949]               0.014     0.000     1.148
>>     79371.874591 [10] gcc[31951]               0.000     0.000     0.024
>>     79371.874603 [10] migration/10[59]         3.350     0.004     0.011
>>     79371.874604 [11] <idle>                   1.148     0.000     0.035
>>     79371.874723 [05] <idle>                   0.016     0.000     1.383
>>     79371.874746 [05] gcc[31949]               0.153     0.078     0.022
>
> What does "b/n time" mean?

Time between schedule-in events.

>
> I'm seeing rather large "sch delay" numbers on Fedora 19's default
> kernel that seem like a data error of some sort:
>
>      4500.663117 [02] fix_client[7216]         0.007
> 18446744073708.033     1.786

hmm.... it means tprev < t_ready-to-run and both are non-zero. ie., 
wakeup time is after the time of the schedule event prior to fix_client 
getting scheduled. Is this a multi-socket box? I can add a sanity check 
and set to 0 if it happens.

>
> Scheduling delays don't seem to be part of "-s" summary output. Why?

Recently added feature to show the scheduling delay. At this point I 
have too many features locally and need to get the basic command into 
perf before adding more -- like stats for scheduling delay.

David
