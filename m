Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935023AbaEFLIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:08:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934798AbaEFLIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:08:44 -0400
Date: Tue, 6 May 2014 13:08:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: sched,numa: invalid memory access in account_entity_dequeue
Message-ID: <20140506110838.GE11096@twins.programming.kicks-ass.net>
References: <5364EC10.9090900@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OQhbRXNHSL5w/5po"
Content-Disposition: inline
In-Reply-To: <5364EC10.9090900@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OQhbRXNHSL5w/5po
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 03, 2014 at 09:16:00AM -0400, Sasha Levin wrote:
> Hi all,
>=20
> While fuzzing with trinity inside a KVM tools guest running latest -next
> kernel I've stumbled on the following:
>=20

Cute.. not making sense.. :-)

> [ 1796.591361] BUG: unable to handle kernel paging request at fffffffedf9=
7f040
> [ 1796.592665] IP: __cpu_to_node (arch/x86/mm/numa.c:777)

I suppose you've scripted this addr2line -ie vmlinux for all addresses
in this splat?

> [ 1796.593710] PGD 21e30067 PUD 0
> [ 1796.594174] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 1796.594937] Dumping ftrace buffer:
> [ 1796.595678]    (ftrace buffer empty)
> [ 1796.596329] Modules linked in:
> [ 1796.596733] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W     3.15=
=2E0-rc3-next-20140502-sasha-00019-g5cb1c98 #431
> [ 1796.598143] task: ffff8803345b8000 ti: ffff880035fc0000 task.ti: ffff8=
80035fc0000
> [ 1796.598975] RIP: __cpu_to_node (arch/x86/mm/numa.c:777)
> [ 1796.600093] RSP: 0018:ffff8800a6c03b88  EFLAGS: 00010046
> [ 1796.600197] RAX: ffff8806e791a000 RBX: ffffffffe791a028 RCX: 000000000=
0000000
> [ 1796.600197] RDX: 0000000000000001 RSI: ffff8806cdc68068 RDI: 00000000e=
791a028
> [ 1796.600197] RBP: ffff8800a6c03b98 R08: ffff880496183078 R09: 000000000=
00151c6
> [ 1796.600197] R10: 000000000000b731 R11: 0000000000000001 R12: ffff8801b=
4dd7840
> [ 1796.600197] R13: 0000000000000000 R14: 000000000000001e R15: ffff8801b=
34ac1a0
> [ 1796.600197] FS:  0000000000000000(0000) GS:ffff8800a6c00000(0000) knlG=
S:0000000000000000
> [ 1796.600197] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1796.600197] CR2: fffffffedf97f040 CR3: 0000000021e2d000 CR4: 000000000=
00006a0
> [ 1796.610323] Stack:
> [ 1796.610323]  0000000000000000 ffff8801b34ac1a0 ffff8800a6c03bd8 ffffff=
ff9d1a9646
> [ 1796.610323]  ffff8800a6c03bd8 ffff8806cdc68068 ffff8806cdc68068 ffff88=
01b34ac1a0
> [ 1796.610323]  0000000000000000 000000000000b7db ffff8800a6c03c38 ffffff=
ff9d1ae987
> [ 1796.610323] Call Trace:
> [ 1796.610323]  <IRQ>
> [ 1796.610323] account_entity_dequeue (kernel/sched/fair.c:859 kernel/sch=
ed/fair.c:2009)
> [ 1796.610323] dequeue_entity (kernel/sched/fair.c:2827)
> [ 1796.610323] dequeue_task_fair (kernel/sched/fair.c:3907 include/linux/=
jump_label.h:105 kernel/sched/fair.c:3041 kernel/sched/fair.c:3217 kernel/s=
ched/fair.c:3915)
> [ 1796.610323] dequeue_task (kernel/sched/core.c:793)
> [ 1796.610323] deactivate_task (kernel/sched/core.c:809)
> [ 1796.610323] move_task (kernel/sched/fair.c:5032)
> [ 1796.610323] load_balance (kernel/sched/fair.c:5305 kernel/sched/fair.c=
:6485)
> [ 1796.610323] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
> [ 1796.610323] rebalance_domains (kernel/sched/fair.c:7032)
> [ 1796.610323] ? rebalance_domains (kernel/sched/fair.c:6975)
> [ 1796.610323] run_rebalance_domains (kernel/sched/fair.c:7105 kernel/sch=
ed/fair.c:7198)
> [ 1796.610323] __do_softirq (kernel/softirq.c:269 include/linux/jump_labe=
l.h:105 include/trace/events/irq.h:126 kernel/softirq.c:270)
> [ 1796.610323] ? irq_exit (include/linux/vtime.h:82 include/linux/vtime.h=
:121 kernel/softirq.c:384)
> [ 1796.610323] irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
> [ 1796.610323] scheduler_ipi (kernel/sched/core.c:1545)
> [ 1796.610323] smp_reschedule_interrupt (arch/x86/kernel/smp.c:266)
> [ 1796.610323] reschedule_interrupt (arch/x86/kernel/entry_64.S:1178)
> [ 1796.610323]  <EOI>
> [ 1796.610323] ? native_safe_halt (arch/x86/include/asm/irqflags.h:50)
> [ 1796.610323] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
> [ 1796.637135] default_idle (arch/x86/include/asm/paravirt.h:111 arch/x86=
/kernel/process.c:310)
> [ 1796.637135] arch_cpu_idle (arch/x86/kernel/process.c:302)
> [ 1796.637135] cpu_idle_loop (kernel/sched/idle.c:179 kernel/sched/idle.c=
:226)
> [ 1796.637135] cpu_startup_entry (??:?)
> [ 1796.637135] start_secondary (arch/x86/kernel/smpboot.c:267)
> [ 1796.637135] Code: 3a ea 05 00 74 25 89 de 48 c7 c7 08 b4 6c a1 31 c0 e=
8 99 6c 45 03 e8 7c 39 46 03 48 8b 05 71 3a ea 05 8b 04 98 eb 16 0f 1f 40 0=
0 <48> 8b 14 dd 00 ef 0a a3 48 c7 c0 d8 f4 00 00 8b 04 10 48 83 c4


Could you maybe also do the same with the Code? -- that is, script an
auto-decode for it?

Obviously scripts/decodecode doesn't actually work right anymore:

# echo [ 1796.637135] Code: 3a ea 05 00 74 25 89 de 48 c7 c7 08 b4 6c a1 31=
 c0 e8 99 6c 45 03 e8 7c 39 46 03 48 8b 05 71 3a ea 05 8b 04 98 eb 16 0f 1f=
 40 00 <48> 8b 14 dd 00 ef 0a a3 48 c7 c0 d8 00 00 8b 04 10 48 83 c4 | ./sc=
ripts/decodecode=20
-bash: syntax error near unexpected token `48'

But if I remove the <> by hand I get:

# echo [ 1796.637135] Code: 3a ea 05 00 74 25 89 de 48 c7 c7 08 b4 6c a1 31=
 c0 e8 99 6c 45 03 e8 7c 39 46 03 48 8b 05 71 3a ea 05 8b 04 98 eb 16 0f 1f=
 40 00 48 8b 14 dd 00 ef 0a a3 48 c7 c0 d8 00 00 8b 04 10 48 83 c4 | ./scri=
pts/decodecode=20
[ 1796.637135] Code: 3a ea 05 00 74 25 89 de 48 c7 c7 08 b4 6c a1 31 c0 e8 =
99 6c 45 03 e8 7c 39 46 03 48 8b 05 71 3a ea 05 8b 04 98 eb 16 0f 1f 40 00 =
48 8b 14 dd 00 ef 0a a3 48 c7 c0 d8 00 00 8b 04 10 48 83 c4
sed: -e expression #1, char 1: unknown command: `-'

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:   3a ea                   cmp    %dl,%ch
   2:   05 00 74 25 89          add    $0x89257400,%eax
   7:   de 48 c7                fimul  -0x39(%rax)
   a:   c7                      (bad) =20
   b:   08 b4 6c a1 31 c0 e8    or     %dh,-0x173fce5f(%rsp,%rbp,2)
  12:   99                      cltd  =20
  13:   6c                      insb   (%dx),%es:(%rdi)
  14:   45 03 e8                add    %r8d,%r13d
  17:   7c 39                   jl     0x52
  19:   46 03 48 8b             rex.RX add -0x75(%rax),%r9d
  1d:   05 71 3a ea 05          add    $0x5ea3a71,%eax
  22:   8b 04 98                mov    (%rax,%rbx,4),%eax
  25:   eb 16                   jmp    0x3d
  27:   0f 1f 40 00             nopl   0x0(%rax)
  2b:   48 8b 14 dd 00 ef 0a    mov    -0x5cf51100(,%rbx,8),%rdx
  32:   a3=20
  33:   48 c7 c0 d8 00 00 8b    mov    $0xffffffff8b0000d8,%rax
  3a:   04 10                   add    $0x10,%al
  3c:   48                      rex.W
  3d:   83                      .byte 0x83
  3e:   c4                      .byte 0xc4

And 2b is the offset where the <> was.

Anyway, the reason I did this was that I was hoping to find
the cpu argument in one of the registers, but looking at your RBX value
doesn't really help.


If I compile this function with a defconfig based .config, I get
something like:

00000000000000a0 <__cpu_to_node>:
  a0:   48 83 3d 00 00 00 00    cmpq   $0x0,0x0(%rip)        # a8 <__cpu_to=
_node+0x8>
  a7:   00=20
  a8:   55                      push   %rbp
  a9:   48 89 e5                mov    %rsp,%rbp
  ac:   53                      push   %rbx
  ad:   48 63 df                movslq %edi,%rbx
  b0:   75 15                   jne    c7 <__cpu_to_node+0x27>
  b2:   48 8b 14 dd 00 00 00    mov    0x0(,%rbx,8),%rdx
  b9:   00=20
  ba:   48 c7 c0 00 00 00 00    mov    $0x0,%rax
  c1:   8b 04 10                mov    (%rax,%rdx,1),%eax
  c4:   5b                      pop    %rbx
  c5:   5d                      pop    %rbp
  c6:   c3                      retq  =20
  c7:   89 de                   mov    %ebx,%esi
  c9:   48 c7 c7 00 00 00 00    mov    $0x0,%rdi
  d0:   31 c0                   xor    %eax,%eax
  d2:   e8 00 00 00 00          callq  d7 <__cpu_to_node+0x37>
  d7:   e8 00 00 00 00          callq  dc <__cpu_to_node+0x3c>
  dc:   48 8b 05 00 00 00 00    mov    0x0(%rip),%rax        # e3 <__cpu_to=
_node+0x43>
  e3:   8b 04 98                mov    (%rax,%rbx,4),%eax
  e6:   eb dc                   jmp    c4 <__cpu_to_node+0x24>
  e8:   0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
  ef:   00


And the b2 offset matches up fairly nicely, although the rest of the
decode appears to be crap. Still no hints though.

However, calling convention puts the first argument in EAX, and at b2
EAX should still contain the original value, however your RAX value is
complete nonsense again :/

Of course, the cpu argument being complete crap is a good reason for
this to happen. Which would make thread_info::cpu of the task in
question be complete crap.. and I'm not sure I can explain that either.

la-la-la..=20

--OQhbRXNHSL5w/5po
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaMK2AAoJEHZH4aRLwOS63BcQAIteCAfpQUUGTJFU3IUFjWwQ
qwdFqaSaUREOg4lI1SKl/vSnVTGXwkhrocBXF8KkUDVwHfQRhO5GoIgj5V7XxIRY
fch56i7P24KPwShuz45/uzHxz73Ntlr8KHDch+dRLpJzAP1DNtanPwE/Y9uLaZ33
mrIYyKD1GjIp8qH12g0WavrqtBq7g/m0M92ykYUG737LXj8SczZWgfFE8Etyhg8F
QbFMVHo3rIPKYaeVbdbUtL9lh0gtRqwLhAIcPjSINRJ2FaU8wy/rsADxPzlX+CtL
6FWELHnTxsnN+jCqc8i/byx7wRGfPs3d5yzBYtGpDu0O6sOw6GHTfh/qc+tbOTnX
9kIJtbr31gUpmiAMybBfWapor15GbfPPzQBMj2E9VPQtHzAzyRRIjVBdB9poRfn3
Gwdx8uJWnaejx+s0/HrGn8CUOYlVMmqDpKYkHsoXHkFVfnhkCTQL8phGcJaQIINj
M99SRCtJD9+fcizv52p3boGQOpggWqC+38mYUaFdOucjHBlxq+9JuPF6i3qjyTvt
KEiJp5BS0cyzpE2pneM2J9I5ODRkHtiNvEw+INMvHwrMTIWDPjeVtRrb4JywOwOn
IKS0aLV+2zwgqEbMt0EMbaITr5de+1tJPgVHt5CtBCr80EfUpo7CjiFsL76iqCTO
Llq9dG8aowLbXeh3/gHf
=Y8jD
-----END PGP SIGNATURE-----

--OQhbRXNHSL5w/5po--
