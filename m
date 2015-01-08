Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbbAHPAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:00:50 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:46981 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbbAHPAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:00:48 -0500
MIME-Version: 1.0
In-Reply-To: <1420694794.5279.33.camel@marge.simpson.net>
References: <CAH86sKKCbZ7CYDEgAnpiVH+7TZNOjziUYOJSWHEpQyY3eUSniA@mail.gmail.com>
	<1420694794.5279.33.camel@marge.simpson.net>
Date: Thu, 8 Jan 2015 10:00:47 -0500
Message-ID: <CAH86sKJJWACmjC0VfF4AHEvsLQ42T81JOYseykzrEB=tVfZQDA@mail.gmail.com>
Subject: Re: sched_yield() call on Linux Kernel 2.6.39 is not behaving correct
From: Yogesh Ahire <yogesh02061983@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Mike. But I can see there are tasks with same priority and
are runnable waiting for CPU, following is the output of
/proc/sched_debug where you can see that the task "symphonyapp"
continuously calls sched_yield() but there are other tasks which are
ready to run are not getting CPU and are queued back.


cpu#4, 2660.325 MHz
  .nr_running                    : 133
  .load                          : 135278
  .nr_switches                   : 3032774521
  .nr_load_updates               : 4859055152
  .nr_uninterruptible            : 0
  .next_balance                  : 9153.935253
  .curr->pid                     : 2392
  .clock                         : 1373656869.013078
  .cpu_load[0]                   : 135278
  .cpu_load[1]                   : 116170
  .cpu_load[2]                   : 104329
  .cpu_load[3]                   : 97683
  .cpu_load[4]                   : 93432
  .yld_count                     : 503461840
  .sched_switch                  : 0
  .sched_count                   : -917907006
  .sched_goidle                  : 4735
  .avg_idle                      : 672352
  .ttwu_count                    : 1516392423
  .ttwu_local                    : 1516377141
  .bkl_count                     : 0

cfs_rq[4]:
  .exec_clock                    : 1373608176.832115
  .MIN_vruntime                  : 18008522836.670893
  .min_vruntime                  : 18008522848.670893
  .max_vruntime                  : 18008522959.874760
  .spread                        : 123.203867
  .spread0                       : 17010031797.944969
  .nr_spread_over                : -676561100
  .nr_running                    : 133
  .load                          : 135278

rt_rq[4]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     kworker/4:1   224 18008522836.670893 1516377074   120
18008522836.670893   5565718.111520 18008565537.968010
     taskmonitor 10602 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 11695 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 19704 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 25757 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 31287 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor  1510 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 14921 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 15377 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 15707 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 16032 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 16629 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
     taskmonitor 16695 18008522860.665039         0   120
18008522860.665039         0.000000         0.000000
R    symphonyapp  2392 1368041892.701540 1516377057   120
1368041892.702799 1368041445.291337        31.536059
            ntpd  9806 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 11577 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 15837 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 20093 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
      ice_ai_pca 22944 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 24137 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 27732 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 31330 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond  2557 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond  6175 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond  9775 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 13374 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000
           crond 16975 18008522856.668288         0   120
18008522856.668288         0.000000         0.000000


Thanks
Yogesh

On Thu, Jan 8, 2015 at 12:26 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Wed, 2015-01-07 at 16:30 -0500, Yogesh Ahire wrote:
>> Hi All,
>>
>> I have a system with multiple CPU cores.  I have multiple threads
>> assigned to particular CPU. Among these threads the main thread calls
>> sched_yield() if it has nothing to do, I am hoping that doing so will
>> give chance to other threads to run. But the strange behavior of
>> sched_yield() is , even if there are ready-to-runs tasks on this CPU
>> waiting for their turn, the task which calls sched_yield() is always
>> running ( get scheduled) and not giving chance to any other task to
>> run. It is consuming 100% of CPU. Is sched_yield() is broken on 2.6
>> Kernel?
>
> Nope, your expectation is likely busted.  sched_yield() for a fair class
> task is merely a resched check in CFS.  IFF there's a runnable task
> that's more deserving by the CFS definition thereof, it'll initiate a
> context switch, otherwise it's a non-free noop.  For realtime class
> tasks, behavior is predictable, the scheduler WILL initiate a context
> switch IFF there is a runnable task of >= yielding tasks priority on the
> same CPU.  If you depend on a context switch happening in any other
> circumstance, you're gonna be seriously disappointed.
>
> -Mike
>
