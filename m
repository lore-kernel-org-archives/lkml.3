Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaLDK0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:26:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:4465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbaLDK0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:26:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,514,1413270000"; 
   d="scan'208";a="618489831"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Hillf Danton <hillf.zj@alibaba-inc.com>
CC: "Zhang, Jun" <jun.zhang@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: RE: [PATCH] sched/fair: fix select_task_rq_fair return -1
Thread-Topic: [PATCH] sched/fair: fix select_task_rq_fair return -1
Thread-Index: AQHQD6pNy/9L77nfwUOUH5ydL3Ozx5x/OQSw
Date: Thu, 4 Dec 2014 10:23:54 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01EEA337@SHSMSX101.ccr.corp.intel.com>
References: <007f01d00fa1$68bf6770$3a3e3650$@alibaba-inc.com>
 <CAKfTPtAOTJ1i5HPad4j91SWNiK5m_JRmg6Z4COiC8pADhi3dng@mail.gmail.com>
In-Reply-To: <CAKfTPtAOTJ1i5HPad4j91SWNiK5m_JRmg6Z4COiC8pADhi3dng@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vincent Guittot [mailto:vincent.guittot@linaro.org]
> Sent: Thursday, December 04, 2014 6:08 PM
> To: Hillf Danton
> Cc: Zhang, Jun; Ingo Molnar; Peter Zijlstra; linux-kernel; Liu, Chuansheng; Liu,
> Changcheng
> Subject: Re: [PATCH] sched/fair: fix select_task_rq_fair return -1
> 
> On 4 December 2014 at 10:05, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
> >>
> >> From: zhang jun <jun.zhang@intel.com>
> >>
> >> when cpu == -1 and sd->child == NULL, select_task_rq_fair return -1, system
> panic.
> >>
> >> [ 0.738326] BUG: unable to handle kernel paging request at
> ffff8800997ea928
> >> [ 0.746138] IP: [<ffffffff810b15d3>] wake_up_new_task+0x43/0x1b0
> >> [ 0.752886] PGD 25df067 PUD 0
> >> [ 0.756321] Oops: 0000 1 PREEMPT SMP
> >> [ 0.760743] Modules linked in:
> >> [ 0.764179] CPU: 0 PID: 6 Comm: kworker/u8:0 Not tainted
> 3.14.19-quilt-b27ac761 #2
> >> [ 0.772651] Hardware name: Intel Corporation CHERRYVIEW B1
> PLATFORM/Cherry Trail CR, BIOS CHTTRVP1.X64.0003.R08.1411110453
> >> 11/11/2014
> >> [ 0.786084] Workqueue: khelper __call_usermodehelper
> >> [ 0.791649] task: ffff88007955a150 ti: ffff88007955c000 task.ti:
> ffff88007955c000
> >> [ 0.800021] RIP: 0010:[<ffffffff810b15d3>] [<ffffffff810b15d3>]
> wake_up_new_task+0x43/0x1b0
> >> [ 0.809478] RSP: 0000:ffff88007955dd58 EFLAGS: 00010092
> >> [ 0.815422] RAX: 00000000ffffffff RBX: 0000000000000001 RCX:
> 0000000000000020
> >> [ 0.823404] RDX: 00000000ffffffff RSI: 0000000000000020 RDI:
> 0000000000000020
> >> [ 0.831386] RBP: ffff88007955dd80 R08: ffff880079604b58 R09:
> 00000000ffffffff
> >> [ 0.839368] R10: 0000000000000004 R11: eae0000000000000 R12:
> ffff8800797ea650
> >> [ 0.847350] R13: 0000000000004000 R14: ffff8800797ead52 R15:
> 0000000000000206
> >> [ 0.855335] FS: 0000000000000000(0000) GS:ffff88007aa00000(0000)
> knlGS:0000000000000000
> >> [ 0.864387] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> [ 0.870817] CR2: ffff8800997ea928 CR3: 000000000220b000 CR4:
> 00000000001007f0
> >> [ 0.878796] Stack:
> >> [ 0.881046] 0000000000000001 ffff8800797ea650 0000000000004000
> 0000000000000000
> >> [ 0.889363] 000000000000003c ffff88007955ddf0 ffffffff8107ddfd
> ffffffff810b6a95
> >> [ 0.897680] 0000000000000000 ffff8800796beb00 ffff880000000000
> ffffffff81000000
> >> [ 0.905998] Call Trace:
> >> [ 0.908752] [<ffffffff8107ddfd>] do_fork+0x12d/0x3b0
> >> [ 0.914416] [<ffffffff810b6a95>] ? set_next_entity+0x95/0xb0
> >> [ 0.920856] [<ffffffff8107e0a6>] kernel_thread+0x26/0x30
> >> [ 0.926903] [<ffffffff8109703e>] __call_usermodehelper+0x2e/0x90
> >> [ 0.933730] [<ffffffff8109ad31>] process_one_work+0x171/0x490
> >> [ 0.940264] [<ffffffff8109ba4b>] worker_thread+0x11b/0x3a0
> >> [ 0.946508] [<ffffffff8109b930>] ? manage_workers.isra.27+0x2b0/0x2b0
> >> [ 0.953821] [<ffffffff810a1802>] kthread+0xd2/0xf0
> >> [ 0.959289] [<ffffffff810a1730>] ? kthread_create_on_node+0x170/0x170
> >> [ 0.966602] [<ffffffff81af81ac>] ret_from_fork+0x7c/0xb0
> >> [ 0.972652] [<ffffffff810a1730>] ? kthread_create_on_node+0x170/0x170
> >> [ 0.979956] Code: 49 89 fc 4c 89 f7 53 e8 bc 5c a4 00 49 8b 54 24 08 31 c9 49
> 89 c7 49 8b 44 24 60 4c 89 e7 8b 72 18 ba 08 00 00 00 ff 50 40 89
> >> c2 <49> 0f a3 94 24 e0 02 00 00 19 c9 85 c9 0f 84 34 01 00 00 48 8b
> >> [ 1.001809] RIP [<ffffffff810b15d3>] wake_up_new_task+0x43/0x1b0
> >> [ 1.008641] RSP <ffff88007955dd58>
> >> [ 1.012544] CR2: ffff8800997ea928
> >> [ 1.016279] --[ end trace 9737aaa337a5ca10 ]--
> >>
> >> Signed-off-by: zhang jun <jun.zhang@intel.com>
> >> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> >> Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>
> >> ---
> >>  kernel/sched/fair.c |    2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> index 34baa60..123153f 100644
> >> --- a/kernel/sched/fair.c
> >> +++ b/kernel/sched/fair.c
> >> @@ -4587,6 +4587,8 @@ select_task_rq_fair(struct task_struct *p, int
> prev_cpu, int sd_flag, int wake_f
> >>               if (new_cpu == -1 || new_cpu == cpu) {
> >>                       /* Now try balancing at a lower domain level of
> cpu */
> >>                       sd = sd->child;
> >> +                     if ((!sd) && (new_cpu == -1))
> >> +                             new_cpu = smp_processor_id();
> >>                       continue;
> >>               }
> >>
> > In 3.18-rc7 is -1 still selected?
> 
> find_idlest_cpu doesn't return -1 anymore but always a valid cpu. The
> local cpu will be used if no better cpu has been found

So I guess we can make one similar patch based on 3.14.x branch?
Latest:
find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
return shallowest_idle_cpu != -1 ? shallowest_idle_cpu : least_loaded_cpu;

3.14.X:
find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
return idlest;

