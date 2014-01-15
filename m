Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaAON1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:27:34 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:41484 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaAON1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:27:31 -0500
Message-ID: <52D68CB7.7080608@linaro.org>
Date: Wed, 15 Jan 2014 14:27:19 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>, raistlin@linux.it,
        juri.lelli@gmail.com
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <52D65423.2070706@linux.vnet.ibm.com>
In-Reply-To: <52D65423.2070706@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 10:25 AM, Michael wang wrote:
> Hi, Daniel
>
> On 01/15/2014 04:27 PM, Daniel Lezcano wrote:
> [snip]
>> commit d50dde5a10f305253cbc3855307f608f8a3c5f73
>> Author: Dario Faggioli <raistlin@linux.it>
>> Date:   Thu Nov 7 14:43:36 2013 +0100
>>
>>      sched: Add new scheduler syscalls to support an extended scheduling
>> parameters ABI
>>
>>      Add the syscalls needed for supporting scheduling algorithms
>>      with extended scheduling parameters (e.g., SCHED_DEADLINE).
>
> Will this do any helps?

Thanks for the patch but unfortunately it leads to a NULL pointer 
dereference.

BUG: unable to handle kernel NULL pointer dereference at 00000216
IP: [<c129ede0>] cfq_prio_tree_add+0x50/0xc0
*pde = 00000000


modem-managOops: 0000 [#1] PREEMPT SMP
CPU: 3 PID: 2348 Comm: rs:main Q:Reg Tainted: G        W 
3.13.0-rc7-00171-g130816c-dirty #436
Hardware name:                  /S2696, BIOS 6.00 11/07/2007
task: f525bf00 ti: f2294000 task.ti: f2294000
er[2344]: <info>EIP: 0060:[<c129ede0>] EFLAGS: 00010002 CPU: 3
   Loaded plugin EIP is at cfq_prio_tree_add+0x50/0xc0
EAX: 00000202 EBX: f59eda18 ECX: 00000000 EDX: f515bfec
ESI: 00000000 EDI: 002ce530 EBP: f2295b38 ESP: f2295b2c
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: 00000216 CR3: 3218c000 CR4: 00000790
Stack:
  f59eda18Option High-Spee f4cdf3b0 f511c000 f2295b78 c12a0b8b 00000010 
00000001 f2295b6c
d

modem-ma c12a7477 00000000 f2304600 00000000 00000001 
f4c08000nager[2344]: <info>  Loaded plugin Wavecom
  00000000 00000000
  f4cdf3b0
          modem-manager[2 f59eda18 00000000 f2295bd0 c12a14fb344]: 
<info>  Lo f2295b94 00000001aded plugin Huaw 00000000
Call Trace:
  [<c12a0b8b>] cfq_add_rq_rb+0x8b/0x190
  [<c12a7477>] ? radix_tree_insert+0x77/0x210
ei

modem-m [<c12a14fb>] cfq_insert_request+0x8b/0x6c0
anager[2344]: <i [<c12864f5>] __elv_add_request+0x175/0x320
nfo>  Loaded plu [<c128d026>] blk_queue_bio+0x226/0x310
gin AnyData
  [<c128b303>] generic_make_request+0xa3/0xd0

  [<c128b381>] submit_bio+0x51/0x100
  [<c118797e>] ? ext4_da_get_block_prep+0x8e/0x640
  [<c1127ae0>] ? end_buffer_read_nobh+0x10/0x10
  [<c112bc6b>] ? bio_alloc_bioset+0x7b/0x170
  [<c1128ed7>] _submit_bh+0x1a7/0x200
  [<c1128f3f>] submit_bh+0xf/0x20
  [<c1128fab>] ll_rw_block+0x5b/0xa0
  [<c112a265>] __block_write_begin+0x1a5/0x320
  [<c118bc59>] ext4_da_write_begin+0x109/0x300
  [<c11878f0>] ? ext4_readpage+0xc0/0xc0
  [<c11b364f>] ? __ext4_journal_stop+0x5f/0x90
  [<c105e595>] ? preempt_count_sub+0x45/0x50
  [<c10ccc4c>] generic_file_buffered_write+0xdc/0x220
  [<c10ccfaa>] __generic_file_aio_write+0x21a/0x470
  [<c1769e55>] ? _raw_spin_unlock+0x15/0x30
  [<c10cd25d>] generic_file_aio_write+0x5d/0xa0
  [<c1182f8d>] ext4_file_write+0xbd/0x450
  [<c110562d>] ? final_putname+0x1d/0x40
  [<c110815f>] ? user_path_at_empty+0x4f/0x80
  [<c12ae229>] ? _copy_to_user+0x39/0x50
  [<c105e595>] ? preempt_count_sub+0x45/0x50
  [<c10fd560>] do_sync_write+0x60/0xa0
  [<c10fd759>] vfs_write+0x99/0x190
  [<c10fd500>] ? vfs_read+0x150/0x150
  [<c1115fd6>] ? fget_light+0x76/0xe0
  [<c10fd947>] SyS_write+0x57/0xa0
  [<c176a690>] syscall_call+0x7/0xb
Code: 66 83 7b 70 03 74 46 8b 43 30 85 c0 74 3f 0f b7 53 6e 31 c9 8d 54 
96 3c 89 53 28 8b 78 3c 8b 70 40 8b 02 85 c0 74 3f 8d 74 26 00 <8b> 50 
14 8b 4a 3c 8b 52 40 39 d6 72 53 77 21 39 cf 77 1d 39 d6
EIP: [<c129ede0>] cfq_prio_tree_add+0x50/0xc0 SS:ESP 0068:f2295b2c
CR2: 0000000000000216
---[ end trace c743276118479205 ]---


>
> Regards,
> Michael Wang
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0326c06..bf4a6ed 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3464,6 +3464,10 @@ int sched_setscheduler(struct task_struct *p, int
> policy,
>                  .sched_policy   = policy,
>                  .sched_priority = param->sched_priority
>          };
> +
> +       if (fair_policy(policy))
> +               attr.sched_nice = PRIO_TO_NICE(attr.sched_priority);
> +
>          return __sched_setscheduler(p, &attr, true);
>   }
>   EXPORT_SYMBOL_GPL(sched_setscheduler);
> @@ -3494,6 +3498,10 @@ int sched_setscheduler_nocheck(struct task_struct
> *p, int policy,
>                  .sched_policy   = policy,
>                  .sched_priority = param->sched_priority
>          };
> +
> +       if (fair_policy(policy))
> +               attr.sched_nice = PRIO_TO_NICE(attr.sched_priority);
> +
>          return __sched_setscheduler(p, &attr, false);
>   }
>
>
>
>>
>>
>> [ ... ]
>>
>>
>>      Signed-off-by: Dario Faggioli <raistlin@linux.it>
>>      [ Rewrote to use sched_attr. ]
>>      Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
>>      [ Removed sched_setscheduler2() for now. ]
>>      Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>>      Link:
>> http://lkml.kernel.org/r/1383831828-15501-3-git-send-email-juri.lelli@gmail.com
>>
>>      Signed-off-by: Ingo Molnar <mingo@kernel.org>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

