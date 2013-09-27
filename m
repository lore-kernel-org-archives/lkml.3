Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3I0JOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:14:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:52098 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab3I0JOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:14:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,991,1371106800"; 
   d="scan'208";a="384323294"
Date: Fri, 27 Sep 2013 17:14:27 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: peterz@infradead.org
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [tip:sched/core] sched: Add NEED_RESCHED to the preempt_count
Message-ID: <20130927091427.GE24743@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 09:38:38AM -0700, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  f27dde8deef33c9e58027df11ceab2198601d6a6
> Gitweb:     http://git.kernel.org/tip/f27dde8deef33c9e58027df11ceab2198601d6a6
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Wed, 14 Aug 2013 14:55:31 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 25 Sep 2013 14:07:49 +0200
> 
> sched: Add NEED_RESCHED to the preempt_count

Hi Peter,

FYI, here we found a pigz regression by this commit.

Here is a list all of changed stats by this commit and it's parent 4a2b4b222743bb07fedf985b884550f2ca067ea9:

                                                                           f27dde8deef33c9e58027df11ce     4a2b4b222743bb07fedf985b884

pigz.throughput                                                            [ 1.3953     - 2.4574     ]     [ 391.49     - 392.43     ]
vmstat.cpu.id                                                              [ 99         - 99         ]     [ 11         - 12         ]
vmstat.system.cs                                                           [ 968        - 1159       ]     [ 63025      - 63666      ]
iostat.cpu.user                                                            [ 0.28527    - 0.51661    ]     [ 86.299     - 86.544     ]
time.user_time                                                             [ 196.66     - 280.86     ]     [ 16712      - 16759      ]
time.percent_of_cpu_this_job_got                                           [ 124        - 143        ]     [ 5642       - 5658       ]
time.elapsed_time                                                          [ 338.69     - 398.91     ]     [ 300.2      - 300.23     ]
time.involuntary_context_switches                                          [ 3184       - 4753       ]     [ 5.536e+05  - 5.9042e+05 ]
time.voluntary_context_switches                                            [ 84559      - 1.2223e+05 ]     [ 1.1008e+07 - 1.1092e+07 ]

lock_stat.clockevents_lock.contentions                                     [ 1.4125e+05 - 1.6922e+05 ]     [ 1.6487e+06 - 1.679e+06  ]
lock_stat.clockevents_lock.contentions.clockevents_notify                  [ 2.8253e+05 - 3.3844e+05 ]     [ 3.2975e+06 - 3.358e+06  ]
lock_stat.&pipe->mutex/1.contentions.pipe_write                            [ 2533       - 3198       ]     [ 27814      - 28802      ]
lock_stat.jiffies_lock.contentions.tick_do_update_jiffies64                [ 1008       - 1822       ]     [ 31272      - 33448      ]
lock_stat.jiffies_lock.contentions                                         [ 504        - 911        ]     [ 15636      - 16724      ]
iostat.cpu.idle                                                            [ 99.217     - 99.446     ]     [ 12.081     - 12.271     ]
lock_stat.&rq->lock.contentions                                            [ 7878       - 9593       ]     [ 1.7954e+05 - 1.8646e+05 ]
lock_stat.rcu_node_1.contentions.force_qs_rnp                              [ 2200       - 2564       ]     [ 33544      - 35368      ]
lock_stat.&(&futex_queues[i].lock)->rlock.contentions.futex_wake           [ 9993       - 16537      ]     [ 1.3794e+06 - 1.4482e+06 ]
lock_stat.rcu_node_1.contentions                                           [ 7854       - 9260       ]     [ 2.4984e+05 - 2.6247e+05 ]
lock_stat.&(&futex_queues[i].lock)->rlock.contentions                      [ 8779       - 14582      ]     [ 1.2373e+06 - 1.301e+06  ]
lock_stat.&pipe->mutex/1.contentions                                       [ 3572       - 4125       ]     [ 1.4362e+05 - 1.507e+05  ]
lock_stat.rcu_node_1.contentions.rcu_process_callbacks                     [ 9511       - 11254      ]     [ 4.5502e+05 - 4.7776e+05 ]
lock_stat.&pipe->mutex/1.contentions.pipe_read                             [ 2163       - 2683       ]     [ 1.3208e+05 - 1.3934e+05 ]
vmstat.system.in                                                           [ 713        - 799        ]     [ 27310      - 27526      ]
lock_stat.&pipe->mutex/1.contentions.pipe_lock_nested                      [ 1802       - 2219       ]     [ 1.2618e+05 - 1.334e+05  ]
lock_stat.&(&futex_queues[i].lock)->rlock.contentions.futex_wait_setup     [ 6447       - 10781      ]     [ 9.3156e+05 - 9.9482e+05 ]
iostat.cpu.system                                                          [ 0.25493    - 0.29317    ]     [ 1.3752     - 1.4608     ]
vmstat.cpu.us                                                              [ 0          - 0          ]     [ 86         - 86         ]
lock_stat.&rq->lock.contentions.try_to_wake_up                             [ 4928       - 6018       ]     [ 1.1351e+05 - 1.5691e+05 ]
lock_stat.&rq->lock.contentions.__schedule                                 [ 3036       - 3658       ]     [ 81508      - 1.3994e+05 ]
lock_stat.&(&futex_queues[i].lock)->rlock/1.contentions.futex_requeue      [ 57         - 114        ]     [ 9139       - 16865      ]
lock_stat.&(&futex_queues[i].lock)->rlock/1.contentions                    [ 57         - 114        ]     [ 9135       - 16860      ]
lock_stat.&(&futex_queues[i].lock)->rlock/1.contentions.futex_wait_setup   [ 55         - 100        ]     [ 8253       - 15331      ]
lock_stat.&(&futex_queues[i].lock)->rlock.contentions.futex_requeue        [ 753        - 1810       ]     [ 83288      - 1.6982e+05 ]
time.minor_page_faults                                                     [ 66817      - 67950      ]     [ 69059      - 69092      ]


And here are text plots for above stats:

O for 4a2b4b222743bb07fedf985b884550f2ca067ea9
* for f27dde8deef33c9e58027df11ceab2198601d6a6


                                  pigz.throughput

   400 O+------O------O-------O-------O------O-------O-------O------O-------O
       |                                                                    |
   350 ++                                                                   |
   300 ++                                                                   |
       |                                                                    |
   250 ++                                                                   |
       |                                                                    |
   200 ++                                                                   |
       |                                                                    |
   150 ++                                                                   |
   100 ++                                                                   |
       |                                                                    |
    50 ++                                                                   |
       |                                                                    |
     0 *+------*------*-------*-------*------*-------*-------*------*-------*


                                   time.user_time

   18000 ++-----------------------------------------------------------------+
         O      O       O      O       O      O       O      O       O      O
   16000 ++                                                                 |
   14000 ++                                                                 |
         |                                                                  |
   12000 ++                                                                 |
   10000 ++                                                                 |
         |                                                                  |
    8000 ++                                                                 |
    6000 ++                                                                 |
         |                                                                  |
    4000 ++                                                                 |
    2000 ++                                                                 |
         |                                                                  |
       0 *+-----*-------*------*-------*------*-------*------*-------*------*


                          time.percent_of_cpu_this_job_got

   6000 ++------------------------------------------------------------------+
        O       O      O       O      O       O      O       O      O       O
   5000 ++                                                                  |
        |                                                                   |
        |                                                                   |
   4000 ++                                                                  |
        |                                                                   |
   3000 ++                                                                  |
        |                                                                   |
   2000 ++                                                                  |
        |                                                                   |
        |                                                                   |
   1000 ++                                                                  |
        |                                                                   |
      0 *+------*------*-------*------*-------*------*-------*------*-------*


                                 time.elapsed_time

   400 ++------*--------------*---------------------------------------------+
   390 ++  ...    .         ..  ..                                          |
       | ..        .      ..      .                                         |
   380 *+           ..   .         .                                        |
   370 ++              ..           ..                                      |
       |              *                                    ..*..            |
   360 ++                             *.....           ....     ..          |
   350 ++                                   .    ....*.           ..        |
   340 ++                                    *...                           |
       |                                                            *.......*
   330 ++                                                                   |
   320 ++                                                                   |
       |                                                                    |
   310 ++                                                                   |
   300 O+------O------O-------O-------O------O-------O-------O------O-------O


                               time.minor_page_faults

   69500 ++-----------------------------------------------------------------+
         |      O              O       O      O       O      O       O      O
   69000 O+             O                                                   |
   68500 ++                                                                 |
         |                                                                  |
   68000 ++         ....*......*.....                                    ...*
         *......*...                 ..              .*.             *...   |
   67500 ++                            *.....     ...   .          ..       |
         |                                   .  ..       ..       .         |
   67000 ++                                   *.           .     .          |
   66500 ++                                                 .  ..           |
         |                                                    .             |
   66000 ++                                                  *              |
         |                                                                  |
   65500 ++-----------------------------------------------------------------+


                            time.voluntary_context_switches

   1.2e+07 ++---------------------------------------------------------------+
           O      O      O       O      O      O      O       O      O      O
     1e+07 ++                                                               |
           |                                                                |
           |                                                                |
     8e+06 ++                                                               |
           |                                                                |
     6e+06 ++                                                               |
           |                                                                |
     4e+06 ++                                                               |
           |                                                                |
           |                                                                |
     2e+06 ++                                                               |
           |                                                                |
         0 *+-----*------*-------*------*------*------*-------*------*------*


                           time.involuntary_context_switches

   700000 ++----------------------------------------------------------------+
          |                                                                 |
   600000 O+                           O       O                            |
          |      O       O      O                     O      O       O      O
   500000 ++                                                                |
          |                                                                 |
   400000 ++                                                                |
          |                                                                 |
   300000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                                  vmstat.system.in

   30000 ++-----------------------------------------------------------------+
         O      O       O      O       O      O       O      O       O      O
   25000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
         |                                                                  |
    5000 ++                                                                 |
         |                                                                  |
       0 *+-----*-------*------*-------*------*-------*------*-------*------*


                                  vmstat.system.cs

   70000 ++-----------------------------------------------------------------+
         O      O       O      O       O      O       O      O       O      O
   60000 ++                                                                 |
         |                                                                  |
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
       0 *+-----*-------*------*-------*------*-------*------*-------*------*


                                   vmstat.cpu.us

   90 ++--------------------------------------------------------------------+
      O       O       O      O       O       O       O      O       O       O
   80 ++                                                                    |
   70 ++                                                                    |
      |                                                                     |
   60 ++                                                                    |
   50 ++                                                                    |
      |                                                                     |
   40 ++                                                                    |
   30 ++                                                                    |
      |                                                                     |
   20 ++                                                                    |
   10 ++                                                                    |
      |                                                                     |
    0 *+------*-------*------*-------*-------*-------*------*-------*-------*


                                   vmstat.cpu.id

   100 *+------*------*-------*-------*------*-------*-------*------*-------*
       |                                                                    |
    90 ++                                                                   |
    80 ++                                                                   |
       |                                                                    |
    70 ++                                                                   |
    60 ++                                                                   |
       |                                                                    |
    50 ++                                                                   |
    40 ++                                                                   |
       |                                                                    |
    30 ++                                                                   |
    20 ++                                                                   |
       |                                                                    |
    10 O+------O------O-------O-------O------O-------O-------O------O-------O


                        lock_stat.clockevents_lock.contentions

   1.8e+06 ++---------------------------------------------------------------+
           O      O      O       O      O      O      O       O      O      O
   1.6e+06 ++                                                               |
   1.4e+06 ++                                                               |
           |                                                                |
   1.2e+06 ++                                                               |
     1e+06 ++                                                               |
           |                                                                |
    800000 ++                                                               |
    600000 ++                                                               |
           |                                                                |
    400000 ++                                                               |
    200000 ++                                                               |
           *......*......*.......*......*......*......*.......*......*......*
         0 ++---------------------------------------------------------------+


               lock_stat.clockevents_lock.contentions.clockevents_notify

   3.5e+06 ++---------------------------------------------------------------+
           O      O      O       O      O      O      O       O      O      O
     3e+06 ++                                                               |
           |                                                                |
   2.5e+06 ++                                                               |
           |                                                                |
     2e+06 ++                                                               |
           |                                                                |
   1.5e+06 ++                                                               |
           |                                                                |
     1e+06 ++                                                               |
           |                                                                |
    500000 ++                                                               |
           *......*......*.......*......*......*......*.......*......*......*
         0 ++---------------------------------------------------------------+


                            lock_stat.&rq->lock.contentions

   200000 ++----------------------------------------------------------------+
   180000 O+     O       O      O      O       O      O      O       O      |
          |                                                                 O
   160000 ++                                                                |
   140000 ++                                                                |
          |                                                                 |
   120000 ++                                                                |
   100000 ++                                                                |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    20000 *+.....*.......*......*......*.......*......*......*.......*......*
        0 ++----------------------------------------------------------------+


                    lock_stat.&rq->lock.contentions.try_to_wake_up

   160000 ++-------------O---------------------O----------------------------+
          |                                                                 |
   140000 ++                                                                |
   120000 ++     O              O                     O              O      |
          O                                                  O              O
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                           O                                    |
    40000 ++                                                                |
          |                                                                 |
    20000 ++                                                                |
          |   ...*.......*......                          ...*.......    ...*
        0 *+--------------------*------*-------*------*--------------*------+


                      lock_stat.&rq->lock.contentions.__schedule

   160000 O+----------------------------------------------------------------+
          |                                                                 |
   140000 ++     O                                                          |
   120000 ++                                                         O      |
          |                                                                 |
   100000 ++             O                     O             O              O
          |                                                                 |
    80000 ++                    O      O              O                     |
          |                                                                 |
    60000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    20000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                 lock_stat.&(&futex_queues[i].lock)->rlock.contentions

   1.4e+06 ++---------------------------------------------------------------+
           O      O      O       O      O             O              O      O
   1.2e+06 ++                                  O              O             |
           |                                                                |
     1e+06 ++                                                               |
           |                                                                |
    800000 ++                                                               |
           |                                                                |
    600000 ++                                                               |
           |                                                                |
    400000 ++                                                               |
           |                                                                |
    200000 ++                                                               |
           |                                                                |
         0 *+-----*------*-------*------*------*------*-------*------*------*


           lock_stat.&(&futex_queues[i].lock)->rlock.contentions.futex_wake

   1.6e+06 ++---------------------------------------------------------------+
           O      O      O       O                                          O
   1.4e+06 ++                           O      O      O       O      O      |
           |                                                                |
   1.2e+06 ++                                                               |
     1e+06 ++                                                               |
           |                                                                |
    800000 ++                                                               |
           |                                                                |
    600000 ++                                                               |
    400000 ++                                                               |
           |                                                                |
    200000 ++                                                               |
           |                                                                |
         0 *+-----*------*-------*------*------*------*-------*------*------*


        lock_stat.&(&futex_queues[i].lock)->rlock.contentions.futex_wait_setup

   1.2e+06 ++---------------------------------------------------------------+
           |                                                                |
     1e+06 ++     O              O                                          |
           O             O              O      O      O       O      O      O
           |                                                                |
    800000 ++                                                               |
           |                                                                |
    600000 ++                                                               |
           |                                                                |
    400000 ++                                                               |
           |                                                                |
           |                                                                |
    200000 ++                                                               |
           |                                                                |
         0 *+-----*------*-------*------*------*------*-------*------*------*


          lock_stat.&(&futex_queues[i].lock)->rlock.contentions.futex_requeue

   180000 ++----------------------------------------------------------------+
          O      O              O              O                            O
   160000 ++                                                 O              |
   140000 ++                                                                |
          |              O                                                  |
   120000 ++                                                                |
   100000 ++                           O                                    |
          |                                                                 |
    80000 ++                                          O              O      |
    60000 ++                                                                |
          |                                                                 |
    40000 ++                                                                |
    20000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                           lock_stat.rcu_node_1.contentions

   300000 ++----------------------------------------------------------------+
          |                                                                 |
   250000 O+     O       O      O              O      O      O       O      O
          |                            O                                    |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
          |                                                                 |
    50000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                lock_stat.rcu_node_1.contentions.rcu_process_callbacks

   500000 ++----------------------------------------------------------------+
   450000 O+     O       O      O      O       O      O      O       O      O
          |                                                                 |
   400000 ++                                                                |
   350000 ++                                                                |
          |                                                                 |
   300000 ++                                                                |
   250000 ++                                                                |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
   100000 ++                                                                |
          |                                                                 |
    50000 ++                                                                |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                    lock_stat.rcu_node_1.contentions.force_qs_rnp

   40000 ++-----------------------------------------------------------------+
         |                                                                  |
   35000 O+     O       O      O              O       O      O       O      O
   30000 ++                            O                                    |
         |                                                                  |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
   10000 ++                                                                 |
         |                                                                  |
    5000 ++                                                                 |
         *......*.......*......*.......*......*.......*......*.......*......*
       0 ++-----------------------------------------------------------------+


                         lock_stat.&pipe->mutex/1.contentions

   160000 ++-----------------------------------O----------------------------+
          |      O       O      O      O              O      O       O      O
   140000 O+                                                                |
   120000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    20000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                 lock_stat.&pipe->mutex/1.contentions.pipe_lock_nested

   140000 ++-----------------------------------O----------------------------+
          O      O       O      O      O              O      O       O      O
   120000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
          |                                                                 |
    40000 ++                                                                |
          |                                                                 |
    20000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                    lock_stat.&pipe->mutex/1.contentions.pipe_read

   160000 ++----------------------------------------------------------------+
          |                                    O                            |
   140000 ++     O       O      O      O              O      O       O      O
   120000 O+                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    20000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*-------*------*------*-------*------*


                   lock_stat.&pipe->mutex/1.contentions.pipe_write

   30000 ++-----------------------------------------------------------------+
         O      O       O      O       O      O       O      O       O      O
   25000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
         |                                                                  |
    5000 ++                                               ...*.......       |
         *......*.......*......*.......*......*.......*...           *......*
       0 ++-----------------------------------------------------------------+


                         lock_stat.jiffies_lock.contentions

   18000 ++-----------------------------------------------------------------+
         O      O              O       O      O              O              |
   16000 ++             O                             O              O      O
   14000 ++                                                                 |
         |                                                                  |
   12000 ++                                                                 |
   10000 ++                                                                 |
         |                                                                  |
    8000 ++                                                                 |
    6000 ++                                                                 |
         |                                                                  |
    4000 ++                                                                 |
    2000 ++                                                                 |
         *......*.......    ...*.......    ...*.......    ...*.......*......*
       0 ++-------------*--------------*--------------*---------------------+


             lock_stat.jiffies_lock.contentions.tick_do_update_jiffies64

   35000 ++-----------------------------------------------------------------+
         O      O              O       O      O       O      O       O      O
   30000 ++             O                                                   |
         |                                                                  |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
    5000 ++                                                                 |
         *......*.......*......*.......    ...*.......    ...*.......*......*
       0 ++----------------------------*--------------*---------------------+


               lock_stat.&(&futex_queues[i].lock)->rlock/1.contentions

   18000 ++-----------------------------------------------------------------+
         |              O                                    O              |
   16000 ++                                                                 |
   14000 O+                            O                                    |
         |                                                           O      |
   12000 ++                    O                      O                     |
   10000 ++                                                                 O
         |                                    O                             |
    8000 ++     O                                                           |
    6000 ++                                                                 |
         |                                                                  |
    4000 ++                                                                 |
    2000 ++                                                                 |
         |                                                                  |
       0 *+-----*-------*------*-------*------*-------*------*-------*------*


        lock_stat.&(&futex_queues[i].lock)->rlock/1.contentions.futex_requeue

   18000 ++-----------------------------------------------------------------+
         |              O                                    O              |
   16000 ++                                                                 |
   14000 O+                            O                             O      |
         |                                                                  |
   12000 ++                    O                      O                     |
   10000 ++                                                                 O
         |                                    O                             |
    8000 ++     O                                                           |
    6000 ++                                                                 |
         |                                                                  |
    4000 ++                                                                 |
    2000 ++                                                                 |
         |                                                                  |
       0 *+-----*-------*------*-------*------*-------*------*-------*------*


      lock_stat.&(&futex_queues[i].lock)->rlock/1.contentions.futex_wait_setup

   16000 ++-------------O---------------------------------------------------+
         |                                                   O              |
   14000 O+                                                                 |
   12000 ++                            O                                    |
         |                                                                  |
   10000 ++                    O                      O                     O
         |                                                           O      |
    8000 ++     O                             O                             |
         |                                                                  |
    6000 ++                                                                 |
    4000 ++                                                                 |
         |                                                                  |
    2000 ++                                                                 |
         |                                                                  |
       0 *+-----*-------*------*-------*------*-------*------*-------*------*


                                  iostat.cpu.user

   90 ++--------------------------------------------------------------------+
      O       O       O      O       O       O       O      O       O       O
   80 ++                                                                    |
   70 ++                                                                    |
      |                                                                     |
   60 ++                                                                    |
   50 ++                                                                    |
      |                                                                     |
   40 ++                                                                    |
   30 ++                                                                    |
      |                                                                     |
   20 ++                                                                    |
   10 ++                                                                    |
      |                                                                     |
    0 *+------*-------*------*-------*-------*-------*------*-------*-------*


                                 iostat.cpu.system

   1.6 ++-------------------------------------------------------------------+
       |              O               O              O                      |
   1.4 O+      O              O              O               O      O       O
       |                                                                    |
   1.2 ++                                                                   |
       |                                                                    |
     1 ++                                                                   |
       |                                                                    |
   0.8 ++                                                                   |
       |                                                                    |
   0.6 ++                                                                   |
       |                                                                    |
   0.4 ++                                                                   |
       *.......*......*.......*.......*......*.......*.......*......    ....*
   0.2 ++-----------------------------------------------------------*-------+


                                  iostat.cpu.idle

   100 *+------*------*-------*-------*------*-------*-------*------*-------*
       |                                                                    |
    90 ++                                                                   |
    80 ++                                                                   |
       |                                                                    |
    70 ++                                                                   |
    60 ++                                                                   |
       |                                                                    |
    50 ++                                                                   |
    40 ++                                                                   |
       |                                                                    |
    30 ++                                                                   |
    20 ++                                                                   |
       |                                                                    |
    10 O+------O------O-------O-------O------O-------O-------O------O-------O


And here is the bisect log:
---
:040000 040000 138132af1aff14d343d8355837e7f98b6e92cfe1 333aa1c56d624a9991ba13cef1dc08b9976d666a M      include                                                                                                                                                
:040000 040000 b47be033e17c9dc558db7bdd3fab1a67b5a8596d 3ba4f3b71ee73a57f09204cba4247133479c12b6 M      kernel                                                                                                                                                 
bisect run success                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                               
# bad: [62a27650cea1a65e4b951d0b58d089c9d206b2d7] Merge remote-tracking branch 'radeon-alex/drm-fixes-3.12' into kbuild_tmp                                                                                                                                    
# good: [272b98c6455f00884f0350f775c5342358ebb73f] Linux 3.12-rc1                                                                                                                                                                                              
git bisect start '62a27650cea1a65e4b951d0b58d089c9d206b2d7' '272b98c6455f00884f0350f775c5342358ebb73f' '--'                                                                                                                                                    
# good: [d0060a777b3d1fd37bdeeabbc6af4a177fa1ad6d] drm/i915: clean up and simplify i9xx_crtc_mode_set wrt PLL handling                                                                                                                                         
git bisect good d0060a777b3d1fd37bdeeabbc6af4a177fa1ad6d                                                                                                                                                                                                       
# good: [57a42192e61e7d0074fa6027e2565461bfd60147] staging: dgap: driver.c: removes smatch warning "redundant null check"                                                                                                                                      
git bisect good 57a42192e61e7d0074fa6027e2565461bfd60147                                                                                                                                                                                                       
# bad: [d2d55f430eac6bd20dcb3b8b11bfb3018d3fadef] Merge remote-tracking branch 'arm-perf/aarch64' into kbuild_tmp                                                                                                                                              
git bisect bad d2d55f430eac6bd20dcb3b8b11bfb3018d3fadef                                                                                                                                                                                                        
# bad: [324f7d868098d2fc547f9b76a77a610d53ca61b5] Merge remote-tracking branch 'smack/next' into kbuild_tmp                                                                                                                                                    
git bisect bad 324f7d868098d2fc547f9b76a77a610d53ca61b5                                                                                                                                                                                                        
# bad: [1a338ac32ca630f67df25b4a16436cccc314e997] sched, x86: Optimize the preempt_schedule() call                                                                                                                                                             
git bisect bad 1a338ac32ca630f67df25b4a16436cccc314e997                                                                                                                                                                                                        
# good: [f48627e686a69f5215cb0761e731edb3d9859dd9] sched/balancing: Periodically decay max cost of idle balance                                                                                                                                                
git bisect good f48627e686a69f5215cb0761e731edb3d9859dd9                                                                                                                                                                                                       
# good: [4a2b4b222743bb07fedf985b884550f2ca067ea9] sched: Introduce preempt_count accessor functions                                                                                                                                                           
git bisect good 4a2b4b222743bb07fedf985b884550f2ca067ea9                                                                                                                                                                                                       
# bad: [01028747559ac6c6f642a7bbd2875cc4f66b2feb] sched: Create more preempt_count accessors                                                                                                                                                                   
git bisect bad 01028747559ac6c6f642a7bbd2875cc4f66b2feb                                                                                                                                                                                                        
# bad: [a787870924dbd6f321661e06d4ec1c7a408c9ccf] sched, arch: Create asm/preempt.h                                                                                                                                                                            
git bisect bad a787870924dbd6f321661e06d4ec1c7a408c9ccf                                                                                                                                                                                                        
# bad: [f27dde8deef33c9e58027df11ceab2198601d6a6] sched: Add NEED_RESCHED to the preempt_count                                                                                                                                                                 
git bisect bad f27dde8deef33c9e58027df11ceab2198601d6a6                                                                                                                                                                                                        
# first bad commit: [f27dde8deef33c9e58027df11ceab2198601d6a6] sched: Add NEED_RESCHED to the preempt_count 


Please feel free to ask more data if necessary.

Thanks.

	--yliu

> 
> In order to combine the preemption and need_resched test we need to
> fold the need_resched information into the preempt_count value.
> 
> Since the NEED_RESCHED flag is set across CPUs this needs to be an
> atomic operation, however we very much want to avoid making
> preempt_count atomic, therefore we keep the existing TIF_NEED_RESCHED
> infrastructure in place but at 3 sites test it and fold its value into
> preempt_count; namely:
> 
>  - resched_task() when setting TIF_NEED_RESCHED on the current task
>  - scheduler_ipi() when resched_task() sets TIF_NEED_RESCHED on a
>                    remote task it follows it up with a reschedule IPI
>                    and we can modify the cpu local preempt_count from
>                    there.
>  - cpu_idle_loop() for when resched_task() found tsk_is_polling().
> 
> We use an inverted bitmask to indicate need_resched so that a 0 means
> both need_resched and !atomic.
> 
> Also remove the barrier() in preempt_enable() between
> preempt_enable_no_resched() and preempt_check_resched() to avoid
> having to reload the preemption value and allow the compiler to use
> the flags of the previuos decrement. I couldn't come up with any sane
> reason for this barrier() to be there as preempt_enable_no_resched()
> already has a barrier() before doing the decrement.
> 
> Suggested-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/linux/preempt.h | 47 ++++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/sched.h   |  7 +++++--
>  kernel/cpu/idle.c       |  7 +++++++
>  kernel/sched/core.c     | 20 +++++++++++++++-----
>  4 files changed, 69 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index eaac52a..92e3418 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -10,9 +10,19 @@
>  #include <linux/linkage.h>
>  #include <linux/list.h>
>  
> +/*
> + * We use the MSB mostly because its available; see <linux/preempt_mask.h> for
> + * the other bits -- can't include that header due to inclusion hell.
> + */
> +#define PREEMPT_NEED_RESCHED	0x80000000
> +
> +/*
> + * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
> + * that think a non-zero value indicates we cannot preempt.
> + */
>  static __always_inline int preempt_count(void)
>  {
> -	return current_thread_info()->preempt_count;
> +	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
>  }
>  
>  static __always_inline int *preempt_count_ptr(void)
> @@ -20,11 +30,40 @@ static __always_inline int *preempt_count_ptr(void)
>  	return &current_thread_info()->preempt_count;
>  }
>  
> +/*
> + * We now loose PREEMPT_NEED_RESCHED and cause an extra reschedule; however the
> + * alternative is loosing a reschedule. Better schedule too often -- also this
> + * should be a very rare operation.
> + */
>  static __always_inline void preempt_count_set(int pc)
>  {
>  	*preempt_count_ptr() = pc;
>  }
>  
> +/*
> + * We fold the NEED_RESCHED bit into the preempt count such that
> + * preempt_enable() can decrement and test for needing to reschedule with a
> + * single instruction.
> + *
> + * We invert the actual bit, so that when the decrement hits 0 we know we both
> + * need to resched (the bit is cleared) and can resched (no preempt count).
> + */
> +
> +static __always_inline void set_preempt_need_resched(void)
> +{
> +	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
> +}
> +
> +static __always_inline void clear_preempt_need_resched(void)
> +{
> +	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
> +}
> +
> +static __always_inline bool test_preempt_need_resched(void)
> +{
> +	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
> +}
> +
>  #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
>    extern void add_preempt_count(int val);
>    extern void sub_preempt_count(int val);
> @@ -42,7 +81,7 @@ asmlinkage void preempt_schedule(void);
>  
>  #define preempt_check_resched() \
>  do { \
> -	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
> +	if (unlikely(!*preempt_count_ptr())) \
>  		preempt_schedule(); \
>  } while (0)
>  
> @@ -52,7 +91,7 @@ void preempt_schedule_context(void);
>  
>  #define preempt_check_resched_context() \
>  do { \
> -	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
> +	if (unlikely(!*preempt_count_ptr())) \
>  		preempt_schedule_context(); \
>  } while (0)
>  #else
> @@ -88,7 +127,6 @@ do { \
>  #define preempt_enable() \
>  do { \
>  	preempt_enable_no_resched(); \
> -	barrier(); \
>  	preempt_check_resched(); \
>  } while (0)
>  
> @@ -116,7 +154,6 @@ do { \
>  #define preempt_enable_notrace() \
>  do { \
>  	preempt_enable_no_resched_notrace(); \
> -	barrier(); \
>  	preempt_check_resched_context(); \
>  } while (0)
>  
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index e783ec5..9fa151f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -22,6 +22,7 @@ struct sched_param {
>  #include <linux/errno.h>
>  #include <linux/nodemask.h>
>  #include <linux/mm_types.h>
> +#include <linux/preempt.h>
>  
>  #include <asm/page.h>
>  #include <asm/ptrace.h>
> @@ -434,7 +435,9 @@ struct task_cputime {
>   * We include PREEMPT_ACTIVE to avoid cond_resched() from working
>   * before the scheduler is active -- see should_resched().
>   */
> -#define INIT_PREEMPT_COUNT	(1 + PREEMPT_ACTIVE)
> +#define INIT_PREEMPT_COUNT	(1 + PREEMPT_ACTIVE + PREEMPT_NEED_RESCHED)
> +#define PREEMPT_ENABLED		(PREEMPT_NEED_RESCHED)
> +#define PREEMPT_DISABLED	(1 + PREEMPT_NEED_RESCHED)
>  
>  /**
>   * struct thread_group_cputimer - thread group interval timer counts
> @@ -2408,7 +2411,7 @@ static inline int signal_pending_state(long state, struct task_struct *p)
>  
>  static inline int need_resched(void)
>  {
> -	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
> +	return unlikely(test_preempt_need_resched());
>  }
>  
>  /*
> diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
> index c261409..988573a 100644
> --- a/kernel/cpu/idle.c
> +++ b/kernel/cpu/idle.c
> @@ -105,6 +105,13 @@ static void cpu_idle_loop(void)
>  				__current_set_polling();
>  			}
>  			arch_cpu_idle_exit();
> +			/*
> +			 * We need to test and propagate the TIF_NEED_RESCHED
> +			 * bit here because we might not have send the
> +			 * reschedule IPI to idle tasks.
> +			 */
> +			if (tif_need_resched())
> +				set_preempt_need_resched();
>  		}
>  		tick_nohz_idle_exit();
>  		schedule_preempt_disabled();
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fe89afa..ee61f5a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -525,8 +525,10 @@ void resched_task(struct task_struct *p)
>  	set_tsk_need_resched(p);
>  
>  	cpu = task_cpu(p);
> -	if (cpu == smp_processor_id())
> +	if (cpu == smp_processor_id()) {
> +		set_preempt_need_resched();
>  		return;
> +	}
>  
>  	/* NEED_RESCHED must be visible before we test polling */
>  	smp_mb();
> @@ -1391,6 +1393,14 @@ static void sched_ttwu_pending(void)
>  
>  void scheduler_ipi(void)
>  {
> +	/*
> +	 * Fold TIF_NEED_RESCHED into the preempt_count; anybody setting
> +	 * TIF_NEED_RESCHED remotely (for the first time) will also send
> +	 * this IPI.
> +	 */
> +	if (tif_need_resched())
> +		set_preempt_need_resched();
> +
>  	if (llist_empty(&this_rq()->wake_list)
>  			&& !tick_nohz_full_cpu(smp_processor_id())
>  			&& !got_nohz_idle_kick())
> @@ -1714,7 +1724,7 @@ void sched_fork(struct task_struct *p)
>  #endif
>  #ifdef CONFIG_PREEMPT_COUNT
>  	/* Want to start with kernel preemption disabled. */
> -	task_thread_info(p)->preempt_count = 1;
> +	task_thread_info(p)->preempt_count = PREEMPT_DISABLED;
>  #endif
>  #ifdef CONFIG_SMP
>  	plist_node_init(&p->pushable_tasks, MAX_PRIO);
> @@ -2425,6 +2435,7 @@ need_resched:
>  	put_prev_task(rq, prev);
>  	next = pick_next_task(rq);
>  	clear_tsk_need_resched(prev);
> +	clear_preempt_need_resched();
>  	rq->skip_clock_update = 0;
>  
>  	if (likely(prev != next)) {
> @@ -2536,11 +2547,10 @@ EXPORT_SYMBOL(preempt_schedule);
>   */
>  asmlinkage void __sched preempt_schedule_irq(void)
>  {
> -	struct thread_info *ti = current_thread_info();
>  	enum ctx_state prev_state;
>  
>  	/* Catch callers which need to be fixed */
> -	BUG_ON(ti->preempt_count || !irqs_disabled());
> +	BUG_ON(preempt_count() || !irqs_disabled());
>  
>  	prev_state = exception_enter();
>  
> @@ -4207,7 +4217,7 @@ void init_idle(struct task_struct *idle, int cpu)
>  	raw_spin_unlock_irqrestore(&rq->lock, flags);
>  
>  	/* Set the preempt count _outside_ the spinlocks! */
> -	task_thread_info(idle)->preempt_count = 0;
> +	task_thread_info(idle)->preempt_count = PREEMPT_ENABLED;
>  
>  	/*
>  	 * The idle tasks have their own, simple scheduling class:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
