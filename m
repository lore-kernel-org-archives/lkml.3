Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaKTN67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:58:59 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24994 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaKTN65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:58:57 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-6d-546df39e4309
Message-id: <546DF39C.80800@samsung.com>
Date: Thu, 20 Nov 2014 16:58:52 +0300
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.2.0
MIME-version: 1.0
To: Tejun Heo <tj@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] random: wait for system_wq before pushing entropy into
 output pools
References: <20141120135421.3819.24114.stgit@buzz>
In-reply-to: <20141120135421.3819.24114.stgit@buzz>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xK7rzPueGGBzeKGGx7dcjNosJD9vY
	LS7vmsNm8Wv5UUaL1p6f7A6sHgs2lXpsWtXJ5tF05iizR9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGW8mLaUqeCOb8W8Nx+ZGxg/2HUxcnJICJhIrJtwgxXCFpO4cG89WxcjF4eQwFJGiXnv
	3jNDOJ8YJVbsn8oCUsUroCFx5eVWsA4WAVWJ9t49YDabgJnEtn23GUFsUYEQiTlPbzNB1AtK
	/Jh8D6xXRCBG4sPcpewgNrNAgMTta+/ZQGxhgSiJdW/ngM0REjCSuLX8KTOIzSlgLNG2bjML
	RL2ZxJeXh1khbHmJzWveMk9gFJiFZMUsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66X
	nJ+7iRES0F93MC49ZnWIUYCDUYmH98Ks3BAh1sSy4srcQ4wSHMxKIrwL3wOFeFMSK6tSi/Lj
	i0pzUosPMTJxcEo1MMb1Hn5sHnxJdfqH4hrf92efPFq2Lau0wtBAJjote2OFJFP7v41pmebh
	cy7dDP/G73vUevtdxSPb7zT9eFn7c9VareBZtu9epEcftVm55qDOyvQ9m+Y4nb5sdeqZ8DlV
	pqfutw5e/Jt8M2mz5pU8/u/ZK2xPP574y+fcF/EunmXWWtW3Fn48KH5DiaU4I9FQi7moOBEA
	bFu1q0YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kasan splash and kernel oops, just for the record.

[  105.538000] ==================================================================
[  105.538000] BUG: AddressSanitizer: user-memory-access on address 100
[  105.538000] Read of size 4 by thread T1:
[  105.538000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-mm1+ #146
[  105.538000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  105.538000]  0000000000000013 000000003193e813 0000000000000000 0000000000000013
[  105.538000]  ffff880003a03b50 ffffffff81cffcb6 0000000000000000 ffff880003a03b80
[  105.538000]  ffff880003a03b70 ffffffff81219794 0000000000000100 ffffffff82282a20
[  105.538000] Call Trace:
[  105.538000] <IRQ> dump_stack (lib/dump_stack.c:52)
[  105.538000] kasan_report_user_access (mm/kasan/report.c:198)
[  105.538000] __asan_load4 (mm/kasan/kasan.c:248 mm/kasan/kasan.c:403)
[  105.538000] ? __queue_work (kernel/workqueue.c:1301 (discriminator 8))
[  105.538000] __queue_work (kernel/workqueue.c:1301 (discriminator 8))
[  105.538000] ? add_interrupt_randomness (drivers/char/random.c:926)
[  105.538000] queue_work_on (kernel/workqueue.c:1403)
[  105.538000] credit_entropy_bits (drivers/char/random.c:699)
[  105.538000] add_interrupt_randomness (drivers/char/random.c:926)
[  105.538000] handle_irq_event_percpu (kernel/irq/handle.c:178)
[  105.538000] handle_irq_event (kernel/irq/handle.c:194)
[  105.538000] handle_level_irq (kernel/irq/chip.c:454)
[  105.538000] handle_irq (arch/x86/kernel/irq_64.c:89)
[  105.538000] do_IRQ (arch/x86/kernel/irq.c:200)
[  105.538000] common_interrupt (arch/x86/kernel/entry_64.S:798)
[  105.538000] ? rcu_gp_kthread (kernel/rcu/tree.c:2557)
[  105.538000] ? __do_softirq (arch/x86/include/asm/atomic.h:27 include/linux/jump_label.h:88 include/linux/jump_label.h:153 include/trace/events/irq.h:126 kernel/softirq.c:270)
[  105.538000] irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[  105.538000] do_IRQ (arch/x86/kernel/irq.c:216)
[  105.538000] common_interrupt (arch/x86/kernel/entry_64.S:798)
[  105.538000] <EOI> ? delay_tsc (arch/x86/include/asm/paravirt.h:179 arch/x86/lib/delay.c:61)
[  105.538000] __const_udelay (arch/x86/lib/delay.c:126)
[  105.538000] __asan_load8 (mm/kasan/kasan.c:243 mm/kasan/kasan.c:409)
[  105.538000] setup_local_APIC (arch/x86/include/asm/apic.h:400 arch/x86/kernel/apic/apic.c:1372)
[  105.538000] native_smp_prepare_cpus (arch/x86/kernel/smpboot.c:1129)
[  105.538000] kernel_init_freeable (init/main.c:884 init/main.c:991)
[  105.538000] ? rest_init (init/main.c:924)
[  105.538000] kernel_init (init/main.c:929)
[  105.538000] ? rest_init (init/main.c:924)
[  105.538000] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[  105.538000] ? rest_init (init/main.c:924)
[  105.538000] ==================================================================

[  105.538000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
[  105.538000] IP: __queue_work (kernel/workqueue.c:1301 (discriminator 8))
[  105.538000] PGD 0
[  105.538000] Oops: 0000 [#1] SMP KASAN
[  105.538000] Modules linked in:
[  105.538000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-mm1+ #146
[  105.538000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  105.538000] task: ffff88001f880000 ti: ffff8800035f8000 task.ti: ffff8800035f8000
[  105.538000] RIP: __queue_work (kernel/workqueue.c:1301 (discriminator 8))
[  105.538000] RSP: 0000:ffff880003a03bd0  EFLAGS: 00010086
[  105.538000] RAX: 0000000000000000 RBX: 0000000000000082 RCX: 0000000000000042
[  105.538000] RDX: 0000000000000000 RSI: 0000000000000013 RDI: 0000000000000013
[  105.538000] RBP: ffff880003a03c30 R08: 000000000000000a R09: 0000000000000006
[  105.538000] R10: dfffe90000000001 R11: 1ffffffff04a4530 R12: ffffffff82282a20
[  105.538000] R13: 0000000000000040 R14: 0000000000000000 R15: ffffffff815c844e
[  105.538000] FS:  0000000000000000(0000) GS:ffff880003a00000(0000) knlGS:0000000000000000
[  105.538000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  105.538000] CR2: 0000000000000100 CR3: 0000000002211000 CR4: 00000000001406f0
[  105.538000] Stack:
[  105.538000]  0000000000000000 0000000000000100 0000000000000001 000000003193e813
[  105.538000]  0000000000000082 000000408257fc40 ffff880003a03c50 0000000000000082
[  105.538000]  ffffffff82282a00 0000000000000000 ffffffff82282c28 ffffffff815c844e
[  105.538000] Call Trace:
[  105.538000]  <IRQ>
[  105.538000] ? add_interrupt_randomness (drivers/char/random.c:926)
[  105.538000] queue_work_on (kernel/workqueue.c:1403)
[  105.538000] credit_entropy_bits (drivers/char/random.c:699)
[  105.538000] add_interrupt_randomness (drivers/char/random.c:926)
[  105.538000] handle_irq_event_percpu (kernel/irq/handle.c:178)
[  105.538000] handle_irq_event (kernel/irq/handle.c:194)
[  105.538000] handle_level_irq (kernel/irq/chip.c:454)
[  105.538000] handle_irq (arch/x86/kernel/irq_64.c:89)
[  105.538000] do_IRQ (arch/x86/kernel/irq.c:200)
[  105.538000] common_interrupt (arch/x86/kernel/entry_64.S:798)
[  105.538000] ? rcu_gp_kthread (kernel/rcu/tree.c:2557)
[  105.538000] ? __do_softirq (arch/x86/include/asm/atomic.h:27 include/linux/jump_label.h:88 include/linux/jump_label.h:153 include/trace/events/irq.h:126 kernel/softirq.c:270)
[  105.538000] irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[  105.538000] do_IRQ (arch/x86/kernel/irq.c:216)
[  105.538000] common_interrupt (arch/x86/kernel/entry_64.S:798)
[  105.538000]  <EOI>
[  105.538000] ? delay_tsc (arch/x86/include/asm/paravirt.h:179 arch/x86/lib/delay.c:61)
[  105.538000] __const_udelay (arch/x86/lib/delay.c:126)
[  105.538000] __asan_load8 (mm/kasan/kasan.c:243 mm/kasan/kasan.c:409)
[  105.538000] setup_local_APIC (arch/x86/include/asm/apic.h:400 arch/x86/kernel/apic/apic.c:1372)
[  105.538000] native_smp_prepare_cpus (arch/x86/kernel/smpboot.c:1129)
[  105.538000] kernel_init_freeable (init/main.c:884 init/main.c:991)
[  105.538000] ? rest_init (init/main.c:924)
[  105.538000] kernel_init (init/main.c:929)
[  105.538000] ? rest_init (init/main.c:924)
[  105.538000] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[  105.538000] ? rest_init (init/main.c:924)
[ 105.538000] Code: 53 48 83 ec 38 89 7d cc 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 73 03 00 00 49 8d 86 00 01 00 00 48 89 c7 48 89 45 a8 e8 00 2e 18 00 <41> 8b 86 00 01 00 00 a9 00 00 01 00 0f 85 7e 03
00 00 49 8d 96
All code
========
    0:   53                      push   %rbx
    1:   48 83 ec 38             sub    $0x38,%rsp
    5:   89 7d cc                mov    %edi,-0x34(%rbp)
    8:   9c                      pushfq
    9:   58                      pop    %rax
    a:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
    f:   f6 c4 02                test   $0x2,%ah
   12:   0f 85 73 03 00 00       jne    0x38b
   18:   49 8d 86 00 01 00 00    lea    0x100(%r14),%rax
   1f:   48 89 c7                mov    %rax,%rdi
   22:   48 89 45 a8             mov    %rax,-0x58(%rbp)
   26:   e8 00 2e 18 00          callq  0x182e2b
   2b:*  41 8b 86 00 01 00 00    mov    0x100(%r14),%eax         <-- trapping instruction
   32:   a9 00 00 01 00          test   $0x10000,%eax
   37:   0f 85 7e 03 00 00       jne    0x3bb
   3d:   49                      rex.WB
   3e:   8d                      .byte 0x8d
   3f:   96                      xchg   %eax,%esi

Code starting with the faulting instruction
===========================================
    0:   41 8b 86 00 01 00 00    mov    0x100(%r14),%eax
    7:   a9 00 00 01 00          test   $0x10000,%eax
    c:   0f 85 7e 03 00 00       jne    0x390
   12:   49                      rex.WB
   13:   8d                      .byte 0x8d
   14:   96                      xchg   %eax,%esi
[  105.538000] RIP __queue_work (kernel/workqueue.c:1301 (discriminator 8))



On 2014-11-20 15:54, Konstantin Khlebnikov wrote:
> First prototype of tool which injects random delays in random places
> (implemented on top of kernel address sanitizer by Andrey Ryabinin)
> have caught race right at the first try.
>
> credit_entropy_bits() schedules work for pushing entropy from one pool
> into another too early, when system_wq isn't yet created. It's called from
> add_interrupt_randomness, so this path starts working right after enabling
> interrupts in start_kernel, but system workqueues are initialized much
> later in early_initcall(init_workqueues). It's impossible to create them
> earlier because threads have to be forked from kthreadd.
>
> This patch skips pushing if system_wq isn't here yet. Delaying this till
> SYSTEM_RUNNING state might lead to significant lost of precious entropy.
>
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Reported-and-tested-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>   drivers/char/random.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 04645c0..d4a684f 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -683,7 +683,7 @@ retry:
>   		 * full.
>   		 */
>   		if (entropy_bits > random_write_wakeup_bits &&
> -		    r->initialized &&
> +		    system_wq && r->initialized &&
>   		    r->entropy_total >= 2*random_read_wakeup_bits) {
>   			static struct entropy_store *last = &blocking_pool;
>   			struct entropy_store *other = &blocking_pool;
> @@ -695,7 +695,7 @@ retry:
>   				last = other;
>   			if (last->entropy_count <=
>   			    3 * last->poolinfo->poolfracbits / 4) {
> -				schedule_work(&last->push_work);
> +				queue_work(system_wq, &last->push_work);
>   				r->entropy_total = 0;
>   			}
>   		}
>
>

