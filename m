Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbaDBOYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:24:46 -0400
Received: from ar100.montanavision.com ([216.146.103.100]:33415 "EHLO
	xilka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758816AbaDBOYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:24:41 -0400
From: Kelly Anderson <kelly@xilka.com>
To: linux-kernel@vger.kernel.org
Subject: 3.14 tc oops
Date: Wed, 02 Apr 2014 08:24:36 -0600
Message-ID: <1592838.91HrDxMk9i@comer>
User-Agent: KMail/4.12.4 (Linux/3.14.0; KDE/4.12.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit a kernel oops when starting traffic control on my armv7 router, I don't 
think the architecture is related, the same tc code worked perfectly with 
earlier kernel versions, i.e. 3.13.x.

I also attached an object dump with line numbers to make identifying the 
problem a bit easier.

Please cc me to keep me in the loop, I can test patches.

Regards,

Kelly Anderson

Unable to handle kernel NULL pointer dereference at virtual address 00000024
pgd = 80004000
[00000024] *pgd=00000000
Internal error: Oops: 17 [#1] PREEMPT ARM
Modules linked in: xt_nat xt_tcpudp xfrm_user cls_u32 cls_tcindex xfrm4_tunnel 
sch_sfq ipcomp xfrm_ipcomp iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
sch_htb nf_nat_ipv4 nf_nat nf_conntrack sch_dsmark esp4 iptable_filter 
iptable_mangle ip_tables x_tables ah4 af_key xfrm_algo snd_soc_kirkwood zram 
snd_hrtimer sha1_arm nfnetlink asix usbnet mii aes_arm
CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted 3.14.0 #2
Workqueue: ipv6_addrconf addrconf_dad_work
task: bef74d80 ti: befbe000 task.ti: befbe000
PC is at tcf_action_exec+0x3c/0x94
LR is at tc_classify_compat+0x50/0x7c
pc : [<8040f5fc>]    lr : [<8040b008>]    psr: 800f0113
sp : befbfd08  ip : bc44c004  fp : 00000000
r10: be3c0780  r9 : be37dd00  r8 : be08c800
r7 : bc44c004  r6 : befbfd48  r5 : bda39bb4  r4 : be3c0780
r3 : 00000000  r2 : befbfd48  r1 : bda39bb4  r0 : be3c0780
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 3e390019  DAC: 00000015
Process kworker/0:1 (pid: 18, stack limit = 0xbefbe248)
Stack: (0xbefbfd08 to 0xbefc0000)
fd00:                   bda39bc4 bc503540 0000dd86 be3c0780 befbfd48 8040b008
fd20: 00000000 be3c0780 bc503540 befbfd48 be317c00 8040c24c bdad2000 be3c0780
fd40: 00000007 7f088c28 00000000 00000000 be317c00 be3c0780 be37db00 bdad2000
fd60: be317c00 7f062778 00000000 be37d400 be37db00 00000000 befbe000 803f28b4
fd80: 00000000 803fb680 00000000 be37d400 be3c0780 adcc08ff befbe030 00000000
fda0: be37dd00 be08caff 00000005 80477fe0 806c0cb0 00000080 befbfe08 be37d478
fdc0: be3c0780 be08caff 00000000 000001b0 00000000 80698008 806c0cb0 be351c00
fde0: be37d400 be3c0780 befbe000 8048e7a4 ad82da86 00000004 00000020 bf001e00
fe00: 00000001 00000087 00000004 00000000 00000000 003a0000 00000000 000002ff
fe20: 00000000 01000000 adcc08ff 00000000 00000000 00000000 00000000 00000000
fe40: 00000087 de08de13 00000010 80525830 80698008 bd99ac50 be08c800 00000000
fe60: befbfecc be3c0780 bd811b40 8048f3a8 806c8540 80027fa0 befbe008 a00f0193
fe80: bd811b74 000080fe 00000000 ffb65002 adcc08fe de08de13 be351c00 bd811b5c
fea0: bd811b74 80698008 00000000 bd811b40 be351c00 00000000 806a0f78 80481bb8
fec0: 80525830 806980d8 806a0f78 000002ff 00000000 01000000 adcc08ff de08de13
fee0: bda4266c bef9e980 bd811b74 806a0f78 befbe000 bf7ece00 00000000 800333dc
ff00: 806c8540 80027fa0 bdad71b4 80031034 00000001 bef9e980 806a0f88 bef9e998
ff20: befbe000 befbe000 befbe038 00000001 806a0f78 800342b8 befbe018 befbe000
ff40: befbe038 806c7696 00000000 bef9c9c0 00000000 bef9e980 80034178 00000000
ff60: 00000000 00000000 00000000 80039c30 00000000 00000000 00000000 bef9e980
ff80: 00000000 befbff84 befbff84 00000000 befbff90 befbff90 befbffac bef9c9c0
ffa0: 80039b64 00000000 00000000 8000e0f8 00000000 00000000 00000000 00000000
ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<8040f5fc>] (tcf_action_exec) from [<8040b008>] 
(tc_classify_compat+0x50/0x7c)
[<8040b008>] (tc_classify_compat) from [<8040c24c>] (tc_classify+0x28/0x90)
[<8040c24c>] (tc_classify) from [<7f088c28>] (htb_enqueue+0x90/0x31c 
[sch_htb])
[<7f088c28>] (htb_enqueue [sch_htb]) from [<7f062778>] 
(dsmark_enqueue+0x118/0x250 [sch_dsmark])
[<7f062778>] (dsmark_enqueue [sch_dsmark]) from [<803f28b4>] 
(__dev_queue_xmit+0x2c0/0x530)
[<803f28b4>] (__dev_queue_xmit) from [<80477fe0>] 
(ip6_finish_output2+0x1b0/0x54c)
[<80477fe0>] (ip6_finish_output2) from [<8048e7a4>] 
(ndisc_send_skb+0x2ec/0x358)
[<8048e7a4>] (ndisc_send_skb) from [<8048f3a8>] (ndisc_send_ns+0x100/0x140)
[<8048f3a8>] (ndisc_send_ns) from [<80481bb8>] (addrconf_dad_work+0x3f4/0x428)
[<80481bb8>] (addrconf_dad_work) from [<800333dc>] 
(process_one_work+0x12c/0x378)
[<800333dc>] (process_one_work) from [<800342b8>] (worker_thread+0x140/0x45c)
[<800342b8>] (worker_thread) from [<80039c30>] (kthread+0xcc/0xe4)
[<80039c30>] (kthread) from [<8000e0f8>] (ret_from_fork+0x14/0x3c)
Code: e5953004 e1a00004 e1a01005 e1a02006 (e5933024) 
---[ end trace 9270e2ab4b936801 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 60 seconds..



/var/tmp/act_api.o:     file format elf32-littlearm


Disassembly of section .text:

00000000 <tcf_hash_insert>:
tcf_hash_insert():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:247
       0:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
       4:	e1a0300d 	mov	r3, sp
       8:	e3c3cd7f 	bic	ip, r3, #8128	; 0x1fc0
tcf_hash():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/act_api.h:47
       c:	e591e004 	ldr	lr, [r1, #4]
spin_lock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
      10:	e3ccc03f 	bic	ip, ip, #63	; 0x3f
tcf_hash():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/act_api.h:47
      14:	e5902008 	ldr	r2, [r0, #8]
spin_lock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
      18:	e59c3004 	ldr	r3, [ip, #4]
tcf_hash():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/act_api.h:47
      1c:	e002200e 	and	r2, r2, lr
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
      20:	e2833c02 	add	r3, r3, #512	; 0x200
      24:	e2833001 	add	r3, r3, #1
      28:	e58c3004 	str	r3, [ip, #4]
tcf_hash_insert():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:251
      2c:	e5913000 	ldr	r3, [r1]
      30:	e083c102 	add	ip, r3, r2, lsl #2
hlist_add_head():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:639
      34:	e7931102 	ldr	r1, [r3, r2, lsl #2]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:641
      38:	e3510000 	cmp	r1, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:640
      3c:	e5801000 	str	r1, [r0]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:642
      40:	15810004 	strne	r0, [r1, #4]
spin_unlock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/spinlock.h:348
      44:	e3001201 	movw	r1, #513	; 0x201
hlist_add_head():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:643
      48:	e7830102 	str	r0, [r3, r2, lsl #2]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:644
      4c:	e580c004 	str	ip, [r0, #4]
tcf_hash_insert():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:253
      50:	e49de004 	pop	{lr}		; (ldr lr, [sp], #4)
spin_unlock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/spinlock.h:348
      54:	e59f0000 	ldr	r0, [pc]	; 5c <tcf_hash_insert+0x5c>
      58:	eafffffe 	b	0 <__local_bh_enable_ip>
      5c:	00000000 	.word	0x00000000

00000060 <tcf_hash_destroy>:
tc_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:31
      60:	e92d4010 	push	{r4, lr}
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
      64:	e1a0300d 	mov	r3, sp
      68:	e3c32d7f 	bic	r2, r3, #8128	; 0x1fc0
tcf_hash_destroy():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:31
      6c:	e1a04000 	mov	r4, r0
preempt_count_ptr():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
      70:	e3c2203f 	bic	r2, r2, #63	; 0x3f
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
      74:	e5923004 	ldr	r3, [r2, #4]
      78:	e2833c02 	add	r3, r3, #512	; 0x200
      7c:	e2833001 	add	r3, r3, #1
      80:	e5823004 	str	r3, [r2, #4]
__hlist_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:615
      84:	e5903000 	ldr	r3, [r0]
spin_unlock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/spinlock.h:348
      88:	e3001201 	movw	r1, #513	; 0x201
__hlist_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:616
      8c:	e5902004 	ldr	r2, [r0, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:618
      90:	e3530000 	cmp	r3, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:617
      94:	e5823000 	str	r3, [r2]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:619
      98:	15832004 	strne	r2, [r3, #4]
hlist_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:625
      9c:	e3a02c01 	mov	r2, #256	; 0x100
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:626
      a0:	e3a03c02 	mov	r3, #512	; 0x200
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:625
      a4:	e3402010 	movt	r2, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:626
      a8:	e3403020 	movt	r3, #32
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:625
      ac:	e5802000 	str	r2, [r0]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:626
      b0:	e5803004 	str	r3, [r0, #4]
spin_unlock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/spinlock.h:348
      b4:	e59f001c 	ldr	r0, [pc, #28]	; d8 <tcf_hash_destroy+0x78>
      b8:	ebfffffe 	bl	0 <__local_bh_enable_ip>
tcf_hash_destroy():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:35
      bc:	e2840038 	add	r0, r4, #56	; 0x38
      c0:	e2841058 	add	r1, r4, #88	; 0x58
      c4:	ebfffffe 	bl	0 <gen_kill_estimator>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:41
      c8:	e2840068 	add	r0, r4, #104	; 0x68
      cc:	e3a01068 	mov	r1, #104	; 0x68
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:42
      d0:	e8bd4010 	pop	{r4, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:41
      d4:	eafffffe 	b	0 <kfree_call_rcu>
      d8:	00000060 	.word	0x00000060

000000dc <tcf_hash_release>:
tcf_hash_release():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:50
      dc:	e3500000 	cmp	r0, #0
      e0:	0a000011 	beq	12c <tcf_hash_release+0x50>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:47
      e4:	e92d4008 	push	{r3, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:51
      e8:	e3510000 	cmp	r1, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:52
      ec:	e5903010 	ldr	r3, [r0, #16]
      f0:	12433001 	subne	r3, r3, #1
      f4:	15803010 	strne	r3, [r0, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:55
      f8:	e3530000 	cmp	r3, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:54
      fc:	e590300c 	ldr	r3, [r0, #12]
     100:	e2433001 	sub	r3, r3, #1
     104:	e580300c 	str	r3, [r0, #12]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:55
     108:	da000001 	ble	114 <tcf_hash_release+0x38>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:48
     10c:	e3a00000 	mov	r0, #0
     110:	e8bd8008 	pop	{r3, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:55 
(discriminator 1)
     114:	e3530000 	cmp	r3, #0
     118:	cafffffb 	bgt	10c <tcf_hash_release+0x30>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:56
     11c:	e1a01002 	mov	r1, r2
     120:	ebfffffe 	bl	60 <tcf_hash_destroy>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:57
     124:	e3a00001 	mov	r0, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:61
     128:	e8bd8008 	pop	{r3, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:48
     12c:	e3a00000 	mov	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:61
     130:	e12fff1e 	bx	lr

00000134 <cleanup_a>:
cleanup_a():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:689
     134:	e92d40f8 	push	{r3, r4, r5, r6, r7, lr}
     138:	e1a05000 	mov	r5, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:692
     13c:	e5902000 	ldr	r2, [r0]
     140:	e1500002 	cmp	r0, r2
     144:	e2423010 	sub	r3, r2, #16
     148:	e5924000 	ldr	r4, [r2]
     14c:	e2444010 	sub	r4, r4, #16
     150:	08bd80f8 	popeq	{r3, r4, r5, r6, r7, pc}
     154:	e5922000 	ldr	r2, [r2]
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107
     158:	e3a07c01 	mov	r7, #256	; 0x100
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     15c:	e3a06c02 	mov	r6, #512	; 0x200
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107
     160:	e3407010 	movt	r7, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     164:	e3406020 	movt	r6, #32
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:106 
(discriminator 2)
     168:	e5931014 	ldr	r1, [r3, #20]
cleanup_a():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:694 
(discriminator 2)
     16c:	e1a00003 	mov	r0, r3
__list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:88 
(discriminator 2)
     170:	e5821004 	str	r1, [r2, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:89 
(discriminator 2)
     174:	e5812000 	str	r2, [r1]
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107 
(discriminator 2)
     178:	e5837010 	str	r7, [r3, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108 
(discriminator 2)
     17c:	e5836014 	str	r6, [r3, #20]
cleanup_a():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:694 
(discriminator 2)
     180:	ebfffffe 	bl	0 <kfree>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:692 
(discriminator 2)
     184:	e1a02004 	mov	r2, r4
     188:	e5b21010 	ldr	r1, [r2, #16]!
     18c:	e1a03004 	mov	r3, r4
     190:	e1550002 	cmp	r5, r2
     194:	e2414010 	sub	r4, r1, #16
     198:	e1a02001 	mov	r2, r1
     19c:	1afffff1 	bne	168 <cleanup_a+0x34>
     1a0:	e8bd80f8 	pop	{r3, r4, r5, r6, r7, pc}

000001a4 <tcf_register_action>:
tcf_register_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:260
     1a4:	e92d43f8 	push	{r3, r4, r5, r6, r7, r8, r9, lr}
     1a8:	e1a08000 	mov	r8, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:264
     1ac:	e5903024 	ldr	r3, [r0, #36]	; 0x24
     1b0:	e3530000 	cmp	r3, #0
     1b4:	0a00004f 	beq	2f8 <tcf_register_action+0x154>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:264 
(discriminator 1)
     1b8:	e5903028 	ldr	r3, [r0, #40]	; 0x28
     1bc:	e3530000 	cmp	r3, #0
     1c0:	0a00004c 	beq	2f8 <tcf_register_action+0x154>
     1c4:	e590302c 	ldr	r3, [r0, #44]	; 0x2c
     1c8:	e3530000 	cmp	r3, #0
     1cc:	0a000049 	beq	2f8 <tcf_register_action+0x154>
     1d0:	e5903034 	ldr	r3, [r0, #52]	; 0x34
     1d4:	e3530000 	cmp	r3, #0
     1d8:	0a000046 	beq	2f8 <tcf_register_action+0x154>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:268
     1dc:	e5903030 	ldr	r3, [r0, #48]	; 0x30
     1e0:	e3530000 	cmp	r3, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:269
     1e4:	03003000 	movweq	r3, #0
     1e8:	03403000 	movteq	r3, #0
     1ec:	05803030 	streq	r3, [r0, #48]	; 0x30
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:270
     1f0:	e5903038 	ldr	r3, [r0, #56]	; 0x38
     1f4:	e3530000 	cmp	r3, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:271
     1f8:	03003000 	movweq	r3, #0
     1fc:	03403000 	movteq	r3, #0
     200:	05803038 	streq	r3, [r0, #56]	; 0x38
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     204:	e1a0300d 	mov	r3, sp
     208:	e3c39d7f 	bic	r9, r3, #8128	; 0x1fc0
     20c:	e3c9303f 	bic	r3, r9, #63	; 0x3f
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
     210:	e5932004 	ldr	r2, [r3, #4]
     214:	e2822001 	add	r2, r2, #1
     218:	e5832004 	str	r2, [r3, #4]
tcf_register_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:274
     21c:	e3005000 	movw	r5, #0
     220:	e3405000 	movt	r5, #0
     224:	e5954000 	ldr	r4, [r5]
     228:	e1540005 	cmp	r4, r5
     22c:	0a00001c 	beq	2a4 <tcf_register_action+0x100>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:275
     230:	e590601c 	ldr	r6, [r0, #28]
     234:	e594301c 	ldr	r3, [r4, #28]
     238:	e1560003 	cmp	r6, r3
     23c:	0a00000c 	beq	274 <tcf_register_action+0xd0>
     240:	e280700c 	add	r7, r0, #12
     244:	ea000005 	b	260 <tcf_register_action+0xbc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:274
     248:	e5944000 	ldr	r4, [r4]
     24c:	e1540005 	cmp	r4, r5
     250:	0a000013 	beq	2a4 <tcf_register_action+0x100>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:275
     254:	e594301c 	ldr	r3, [r4, #28]
     258:	e1530006 	cmp	r3, r6
     25c:	0a000004 	beq	274 <tcf_register_action+0xd0>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:275 
(discriminator 1)
     260:	e1a00007 	mov	r0, r7
     264:	e284100c 	add	r1, r4, #12
     268:	ebfffffe 	bl	0 <strcmp>
     26c:	e3500000 	cmp	r0, #0
     270:	1afffff4 	bne	248 <tcf_register_action+0xa4>
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     274:	e3c9903f 	bic	r9, r9, #63	; 0x3f
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     278:	e5993004 	ldr	r3, [r9, #4]
     27c:	e2433001 	sub	r3, r3, #1
     280:	e5893004 	str	r3, [r9, #4]
     284:	e3530000 	cmp	r3, #0
     288:	1a000003 	bne	29c <tcf_register_action+0xf8>
test_bit():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/bitops/non-atomic.h:105
     28c:	e5993000 	ldr	r3, [r9]
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     290:	e3130002 	tst	r3, #2
     294:	0a000000 	beq	29c <tcf_register_action+0xf8>
tcf_register_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:276
     298:	ebfffffe 	bl	0 <preempt_schedule>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:277
     29c:	e3e00010 	mvn	r0, #16
     2a0:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}
list_add_tail():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:76
     2a4:	e5953004 	ldr	r3, [r5, #4]
__list_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:41
     2a8:	e5858004 	str	r8, [r5, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:42
     2ac:	e5885000 	str	r5, [r8]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:43
     2b0:	e5883004 	str	r3, [r8, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:44
     2b4:	e5838000 	str	r8, [r3]
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     2b8:	e3c9903f 	bic	r9, r9, #63	; 0x3f
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     2bc:	e5994004 	ldr	r4, [r9, #4]
     2c0:	e2444001 	sub	r4, r4, #1
     2c4:	e5894004 	str	r4, [r9, #4]
     2c8:	e3540000 	cmp	r4, #0
     2cc:	1a000004 	bne	2e4 <tcf_register_action+0x140>
test_bit():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/bitops/non-atomic.h:105
     2d0:	e5990000 	ldr	r0, [r9]
     2d4:	e7e000d0 	ubfx	r0, r0, #1, #1
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     2d8:	e3500000 	cmp	r0, #0
     2dc:	1a000002 	bne	2ec <tcf_register_action+0x148>
     2e0:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}
tcf_register_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:282
     2e4:	e3a00000 	mov	r0, #0
     2e8:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:281
     2ec:	ebfffffe 	bl	0 <preempt_schedule>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:282
     2f0:	e1a00004 	mov	r0, r4
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:283
     2f4:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:265
     2f8:	e3e00015 	mvn	r0, #21
     2fc:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}

00000300 <tcf_unregister_action>:
tcf_unregister_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:287
     300:	e92d4010 	push	{r4, lr}
     304:	e24dd008 	sub	sp, sp, #8
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     308:	e1a0300d 	mov	r3, sp
     30c:	e3c3cd7f 	bic	ip, r3, #8128	; 0x1fc0
     310:	e3cc303f 	bic	r3, ip, #63	; 0x3f
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
     314:	e5932004 	ldr	r2, [r3, #4]
     318:	e2822001 	add	r2, r2, #1
     31c:	e5832004 	str	r2, [r3, #4]
tcf_unregister_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:292
     320:	e3002000 	movw	r2, #0
     324:	e3402000 	movt	r2, #0
     328:	e5923000 	ldr	r3, [r2]
     32c:	e1530002 	cmp	r3, r2
     330:	0a000008 	beq	358 <tcf_unregister_action+0x58>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:293
     334:	e1530000 	cmp	r3, r0
     338:	e1a01000 	mov	r1, r0
     33c:	1a000002 	bne	34c <tcf_unregister_action+0x4c>
     340:	ea000013 	b	394 <tcf_unregister_action+0x94>
     344:	e1510003 	cmp	r1, r3
     348:	0a000011 	beq	394 <tcf_unregister_action+0x94>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:292
     34c:	e5933000 	ldr	r3, [r3]
     350:	e1530002 	cmp	r3, r2
     354:	1afffffa 	bne	344 <tcf_unregister_action+0x44>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:289
     358:	e3e00001 	mvn	r0, #1
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     35c:	e3cc303f 	bic	r3, ip, #63	; 0x3f
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     360:	e5932004 	ldr	r2, [r3, #4]
     364:	e2422001 	sub	r2, r2, #1
     368:	e5832004 	str	r2, [r3, #4]
     36c:	e3520000 	cmp	r2, #0
     370:	1a000005 	bne	38c <tcf_unregister_action+0x8c>
test_bit():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/bitops/non-atomic.h:105
     374:	e5933000 	ldr	r3, [r3]
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     378:	e3130002 	tst	r3, #2
     37c:	0a000002 	beq	38c <tcf_unregister_action+0x8c>
tcf_unregister_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:299
     380:	e58d0004 	str	r0, [sp, #4]
     384:	ebfffffe 	bl	0 <preempt_schedule>
     388:	e59d0004 	ldr	r0, [sp, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:301
     38c:	e28dd008 	add	sp, sp, #8
     390:	e8bd8010 	pop	{r4, pc}
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:106
     394:	e591e004 	ldr	lr, [r1, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107
     398:	e3a02c01 	mov	r2, #256	; 0x100
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:106
     39c:	e5914000 	ldr	r4, [r1]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107
     3a0:	e3402010 	movt	r2, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     3a4:	e3a03c02 	mov	r3, #512	; 0x200
tcf_unregister_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:295
     3a8:	e3a00000 	mov	r0, #0
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     3ac:	e3403020 	movt	r3, #32
__list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:88
     3b0:	e584e004 	str	lr, [r4, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:89
     3b4:	e58e4000 	str	r4, [lr]
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     3b8:	e881000c 	stm	r1, {r2, r3}
tcf_unregister_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:296
     3bc:	eaffffe6 	b	35c <tcf_unregister_action+0x5c>

000003c0 <find_dump_kind>:
nlmsg_parse():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:369
     3c0:	e5903000 	ldr	r3, [r0]
     3c4:	e3530013 	cmp	r3, #19
     3c8:	8a000001 	bhi	3d4 <find_dump_kind+0x14>
find_dump_kind():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:963
     3cc:	e3a00000 	mov	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:980
     3d0:	e12fff1e 	bx	lr
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:956
     3d4:	e92d4010 	push	{r4, lr}
     3d8:	e24dd0b0 	sub	sp, sp, #176	; 0xb0
nlmsg_parse():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:372
     3dc:	e2802014 	add	r2, r0, #20
     3e0:	e3a04000 	mov	r4, #0
     3e4:	e2433014 	sub	r3, r3, #20
     3e8:	e28d000c 	add	r0, sp, #12
     3ec:	e58d4000 	str	r4, [sp]
     3f0:	e3a01001 	mov	r1, #1
     3f4:	ebfffffe 	bl	0 <nla_parse>
find_dump_kind():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:962
     3f8:	e1500004 	cmp	r0, r4
     3fc:	ba00001b 	blt	470 <find_dump_kind+0xb0>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:964
     400:	e59d2010 	ldr	r2, [sp, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:965
     404:	e1520004 	cmp	r2, r4
     408:	0a000018 	beq	470 <find_dump_kind+0xb0>
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
     40c:	e1d230b0 	ldrh	r3, [r2]
find_dump_kind():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:968
     410:	e28d002c 	add	r0, sp, #44	; 0x2c
     414:	e2822004 	add	r2, r2, #4
     418:	e58d4000 	str	r4, [sp]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:969
     41c:	e2433001 	sub	r3, r3, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:968
     420:	e3a01020 	mov	r1, #32
     424:	e3c33003 	bic	r3, r3, #3
     428:	ebfffffe 	bl	0 <nla_parse>
     42c:	e1500004 	cmp	r0, r4
     430:	ba00000e 	blt	470 <find_dump_kind+0xb0>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:972
     434:	e59d2030 	ldr	r2, [sp, #48]	; 0x30
     438:	e1520004 	cmp	r2, r4
     43c:	0a00000b 	beq	470 <find_dump_kind+0xb0>
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
     440:	e1d230b0 	ldrh	r3, [r2]
find_dump_kind():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:974
     444:	e28d0014 	add	r0, sp, #20
     448:	e2822004 	add	r2, r2, #4
     44c:	e58d4000 	str	r4, [sp]
     450:	e2433004 	sub	r3, r3, #4
     454:	e3a01005 	mov	r1, #5
     458:	ebfffffe 	bl	0 <nla_parse>
     45c:	e1500004 	cmp	r0, r4
     460:	ba000002 	blt	470 <find_dump_kind+0xb0>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:977
     464:	e59d0018 	ldr	r0, [sp, #24]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:980
     468:	e28dd0b0 	add	sp, sp, #176	; 0xb0
     46c:	e8bd8010 	pop	{r4, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:963
     470:	e3a00000 	mov	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:980
     474:	e28dd0b0 	add	sp, sp, #176	; 0xb0
     478:	e8bd8010 	pop	{r4, pc}

0000047c <tc_lookup_action_n>:
tc_lookup_action_n():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:306
     47c:	e92d40f8 	push	{r3, r4, r5, r6, r7, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:309
     480:	e2506000 	subs	r6, r0, #0
     484:	0a000024 	beq	51c <tc_lookup_action_n+0xa0>
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     488:	e1a0300d 	mov	r3, sp
     48c:	e3c37d7f 	bic	r7, r3, #8128	; 0x1fc0
     490:	e3c7303f 	bic	r3, r7, #63	; 0x3f
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
     494:	e5932004 	ldr	r2, [r3, #4]
     498:	e2822001 	add	r2, r2, #1
     49c:	e5832004 	str	r2, [r3, #4]
tc_lookup_action_n():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:311
     4a0:	e3005000 	movw	r5, #0
     4a4:	e3405000 	movt	r5, #0
     4a8:	e5954000 	ldr	r4, [r5]
     4ac:	e1540005 	cmp	r4, r5
     4b0:	1a000003 	bne	4c4 <tc_lookup_action_n+0x48>
     4b4:	ea00000b 	b	4e8 <tc_lookup_action_n+0x6c>
     4b8:	e5944000 	ldr	r4, [r4]
     4bc:	e1540005 	cmp	r4, r5
     4c0:	0a000008 	beq	4e8 <tc_lookup_action_n+0x6c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:312
     4c4:	e1a00006 	mov	r0, r6
     4c8:	e284100c 	add	r1, r4, #12
     4cc:	ebfffffe 	bl	0 <strcmp>
     4d0:	e3500000 	cmp	r0, #0
     4d4:	1afffff7 	bne	4b8 <tc_lookup_action_n+0x3c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:313
     4d8:	e5940020 	ldr	r0, [r4, #32]
     4dc:	ebfffffe 	bl	0 <try_module_get>
     4e0:	e3500000 	cmp	r0, #0
     4e4:	1a000000 	bne	4ec <tc_lookup_action_n+0x70>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:307
     4e8:	e3a04000 	mov	r4, #0
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     4ec:	e3c7303f 	bic	r3, r7, #63	; 0x3f
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     4f0:	e5932004 	ldr	r2, [r3, #4]
     4f4:	e2422001 	sub	r2, r2, #1
     4f8:	e5832004 	str	r2, [r3, #4]
     4fc:	e3520000 	cmp	r2, #0
     500:	1a000003 	bne	514 <tc_lookup_action_n+0x98>
test_bit():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/bitops/non-atomic.h:105
     504:	e5933000 	ldr	r3, [r3]
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     508:	e3130002 	tst	r3, #2
     50c:	0a000000 	beq	514 <tc_lookup_action_n+0x98>
tc_lookup_action_n():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:318
     510:	ebfffffe 	bl	0 <preempt_schedule>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:321
     514:	e1a00004 	mov	r0, r4
     518:	e8bd80f8 	pop	{r3, r4, r5, r6, r7, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:307
     51c:	e1a04006 	mov	r4, r6
     520:	eafffffb 	b	514 <tc_lookup_action_n+0x98>

00000524 <tc_lookup_action>:
tc_lookup_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:325
     524:	e92d40f8 	push	{r3, r4, r5, r6, r7, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:328
     528:	e2506000 	subs	r6, r0, #0
     52c:	0a000024 	beq	5c4 <tc_lookup_action+0xa0>
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     530:	e1a0300d 	mov	r3, sp
     534:	e3c37d7f 	bic	r7, r3, #8128	; 0x1fc0
     538:	e3c7303f 	bic	r3, r7, #63	; 0x3f
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
     53c:	e5932004 	ldr	r2, [r3, #4]
     540:	e2822001 	add	r2, r2, #1
     544:	e5832004 	str	r2, [r3, #4]
tc_lookup_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:330
     548:	e3005000 	movw	r5, #0
     54c:	e3405000 	movt	r5, #0
     550:	e5954000 	ldr	r4, [r5]
     554:	e1540005 	cmp	r4, r5
     558:	1a000003 	bne	56c <tc_lookup_action+0x48>
     55c:	ea00000b 	b	590 <tc_lookup_action+0x6c>
     560:	e5944000 	ldr	r4, [r4]
     564:	e1540005 	cmp	r4, r5
     568:	0a000008 	beq	590 <tc_lookup_action+0x6c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:331
     56c:	e1a00006 	mov	r0, r6
     570:	e284100c 	add	r1, r4, #12
     574:	ebfffffe 	bl	0 <nla_strcmp>
     578:	e3500000 	cmp	r0, #0
     57c:	1afffff7 	bne	560 <tc_lookup_action+0x3c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:332
     580:	e5940020 	ldr	r0, [r4, #32]
     584:	ebfffffe 	bl	0 <try_module_get>
     588:	e3500000 	cmp	r0, #0
     58c:	1a000000 	bne	594 <tc_lookup_action+0x70>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:326
     590:	e3a04000 	mov	r4, #0
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     594:	e3c7303f 	bic	r3, r7, #63	; 0x3f
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     598:	e5932004 	ldr	r2, [r3, #4]
     59c:	e2422001 	sub	r2, r2, #1
     5a0:	e5832004 	str	r2, [r3, #4]
     5a4:	e3520000 	cmp	r2, #0
     5a8:	1a000003 	bne	5bc <tc_lookup_action+0x98>
test_bit():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/bitops/non-atomic.h:105
     5ac:	e5933000 	ldr	r3, [r3]
__preempt_count_dec_and_test():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:71
     5b0:	e3130002 	tst	r3, #2
     5b4:	0a000000 	beq	5bc <tc_lookup_action+0x98>
tc_lookup_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:337
     5b8:	ebfffffe 	bl	0 <preempt_schedule>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:340
     5bc:	e1a00004 	mov	r0, r4
     5c0:	e8bd80f8 	pop	{r3, r4, r5, r6, r7, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:326
     5c4:	e1a04006 	mov	r4, r6
     5c8:	eafffffb 	b	5bc <tc_lookup_action+0x98>

000005cc <tc_dump_action>:
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:984
     5cc:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
     5d0:	e1a04000 	mov	r4, r0
     5d4:	e24dd024 	sub	sp, sp, #36	; 0x24
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:992
     5d8:	e5910004 	ldr	r0, [r1, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:984
     5dc:	e1a06001 	mov	r6, r1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:983
     5e0:	e594909c 	ldr	r9, [r4, #156]	; 0x9c
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:992
     5e4:	ebffff75 	bl	3c0 <find_dump_kind>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:994
     5e8:	e2505000 	subs	r5, r0, #0
     5ec:	0a000057 	beq	750 <tc_dump_action+0x184>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:999
     5f0:	ebffffcb 	bl	524 <tc_lookup_action>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1000
     5f4:	e2507000 	subs	r7, r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1001
     5f8:	01a00007 	moveq	r0, r7
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1000
     5fc:	0a00003e 	beq	6fc <tc_dump_action+0x130>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1003
     600:	e3a01018 	mov	r1, #24
     604:	e28d0008 	add	r0, sp, #8
     608:	ebfffffe 	bl	0 <__memzero>
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
     60c:	e5945054 	ldr	r5, [r4, #84]	; 0x54
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1006
     610:	e896000a 	ldm	r6, {r1, r3}
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
     614:	e3550000 	cmp	r5, #0
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1004
     618:	e58d700c 	str	r7, [sp, #12]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1006
     61c:	e5932008 	ldr	r2, [r3, #8]
     620:	e5911024 	ldr	r1, [r1, #36]	; 0x24
     624:	e1d330b4 	ldrh	r3, [r3, #4]
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
     628:	1a000035 	bne	704 <tc_dump_action+0x138>
     62c:	e594c0a0 	ldr	ip, [r4, #160]	; 0xa0
     630:	e594009c 	ldr	r0, [r4, #156]	; 0x9c
     634:	e060000c 	rsb	r0, r0, ip
nlmsg_put():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:446
     638:	e3500013 	cmp	r0, #19
     63c:	da000030 	ble	704 <tc_dump_action+0x138>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:449
     640:	e3a0c004 	mov	ip, #4
     644:	e58d5004 	str	r5, [sp, #4]
     648:	e1a00004 	mov	r0, r4
     64c:	e58dc000 	str	ip, [sp]
     650:	ebfffffe 	bl	0 <__nlmsg_put>
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1008
     654:	e2508000 	subs	r8, r0, #0
     658:	0a000029 	beq	704 <tc_dump_action+0x138>
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     65c:	e1a02005 	mov	r2, r5
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1011
     660:	e5c85010 	strb	r5, [r8, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1012
     664:	e5c85011 	strb	r5, [r8, #17]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     668:	e1a03005 	mov	r3, r5
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1013
     66c:	e1c851b2 	strh	r5, [r8, #18]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     670:	e1a00004 	mov	r0, r4
     674:	e3a01001 	mov	r1, #1
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1110
     678:	e594509c 	ldr	r5, [r4, #156]	; 0x9c
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     67c:	ebfffffe 	bl	0 <nla_put>
     680:	e3500000 	cmp	r0, #0
     684:	ba00001e 	blt	704 <tc_dump_action+0x138>
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1016
     688:	e3550000 	cmp	r5, #0
     68c:	0a00001c 	beq	704 <tc_dump_action+0x138>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1019
     690:	e28d3008 	add	r3, sp, #8
     694:	e597c038 	ldr	ip, [r7, #56]	; 0x38
     698:	e1a00004 	mov	r0, r4
     69c:	e1a01006 	mov	r1, r6
     6a0:	e3a02032 	mov	r2, #50	; 0x32
     6a4:	e12fff3c 	blx	ip
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1020
     6a8:	e3500000 	cmp	r0, #0
     6ac:	ba000014 	blt	704 <tc_dump_action+0x138>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1023
     6b0:	0a00001e 	beq	730 <tc_dump_action+0x164>
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
     6b4:	e594309c 	ldr	r3, [r4, #156]	; 0x9c
     6b8:	e0653003 	rsb	r3, r5, r3
     6bc:	e1c530b0 	strh	r3, [r5]
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1029
     6c0:	e594309c 	ldr	r3, [r4, #156]	; 0x9c
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1025
     6c4:	e5942050 	ldr	r2, [r4, #80]	; 0x50
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1029
     6c8:	e0699003 	rsb	r9, r9, r3
     6cc:	e5889000 	str	r9, [r8]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1030
     6d0:	e5963000 	ldr	r3, [r6]
     6d4:	e5933024 	ldr	r3, [r3, #36]	; 0x24
     6d8:	e3530000 	cmp	r3, #0
     6dc:	0a000003 	beq	6f0 <tc_dump_action+0x124>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1030 
(discriminator 1)
     6e0:	e3520000 	cmp	r2, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1031 
(discriminator 1)
     6e4:	11d830b6 	ldrhne	r3, [r8, #6]
     6e8:	13833002 	orrne	r3, r3, #2
     6ec:	11c830b6 	strhne	r3, [r8, #6]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1032
     6f0:	e5970020 	ldr	r0, [r7, #32]
     6f4:	ebfffffe 	bl	0 <module_put>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1033
     6f8:	e5940050 	ldr	r0, [r4, #80]	; 0x50
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1039
     6fc:	e28dd024 	add	sp, sp, #36	; 0x24
     700:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1036
     704:	e5970020 	ldr	r0, [r7, #32]
     708:	ebfffffe 	bl	0 <module_put>
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:523
     70c:	e3590000 	cmp	r9, #0
     710:	0a000003 	beq	724 <tc_dump_action+0x158>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:524
     714:	e59410a8 	ldr	r1, [r4, #168]	; 0xa8
     718:	e1a00004 	mov	r0, r4
     71c:	e0611009 	rsb	r1, r1, r9
     720:	ebfffffe 	bl	0 <skb_trim>
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1038
     724:	e5940050 	ldr	r0, [r4, #80]	; 0x50
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1039
     728:	e28dd024 	add	sp, sp, #36	; 0x24
     72c:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:524
     730:	e59410a8 	ldr	r1, [r4, #168]	; 0xa8
     734:	e1a00004 	mov	r0, r4
     738:	e0611005 	rsb	r1, r1, r5
     73c:	ebfffffe 	bl	0 <skb_trim>
tc_dump_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1029
     740:	e594309c 	ldr	r3, [r4, #156]	; 0x9c
     744:	e0699003 	rsb	r9, r9, r3
     748:	e5889000 	str	r9, [r8]
     74c:	eaffffe7 	b	6f0 <tc_dump_action+0x124>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:995
     750:	e3000000 	movw	r0, #0
     754:	e3400000 	movt	r0, #0
     758:	ebfffffe 	bl	0 <printk>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:996
     75c:	e1a00005 	mov	r0, r5
     760:	eaffffe5 	b	6fc <tc_dump_action+0x130>

00000764 <tcf_hash_lookup.isra.12>:
tcf_hash_lookup():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:159
     764:	e92d4010 	push	{r4, lr}
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
     768:	e1a0300d 	mov	r3, sp
     76c:	e3c3cd7f 	bic	ip, r3, #8128	; 0x1fc0
     770:	e3ccc03f 	bic	ip, ip, #63	; 0x3f
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
     774:	e59c3004 	ldr	r3, [ip, #4]
     778:	e2833c02 	add	r3, r3, #512	; 0x200
     77c:	e2833001 	add	r3, r3, #1
     780:	e58c3004 	str	r3, [ip, #4]
tcf_hash():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/act_api.h:47
     784:	e5922000 	ldr	r2, [r2]
tcf_hash_lookup():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:165
     788:	e5913000 	ldr	r3, [r1]
tcf_hash():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/act_api.h:47
     78c:	e0022000 	and	r2, r2, r0
tcf_hash_lookup():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:166
     790:	e7934102 	ldr	r4, [r3, r2, lsl #2]
     794:	e3540000 	cmp	r4, #0
     798:	0a000005 	beq	7b4 <tcf_hash_lookup.isra.12+0x50>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:167
     79c:	e5943008 	ldr	r3, [r4, #8]
     7a0:	e1500003 	cmp	r0, r3
     7a4:	0a000002 	beq	7b4 <tcf_hash_lookup.isra.12+0x50>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:166
     7a8:	e5944000 	ldr	r4, [r4]
     7ac:	e3540000 	cmp	r4, #0
     7b0:	1afffff9 	bne	79c <tcf_hash_lookup.isra.12+0x38>
spin_unlock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/spinlock.h:348
     7b4:	e59f000c 	ldr	r0, [pc, #12]	; 7c8 
<tcf_hash_lookup.isra.12+0x64>
     7b8:	e3001201 	movw	r1, #513	; 0x201
     7bc:	ebfffffe 	bl	0 <__local_bh_enable_ip>
tcf_hash_lookup():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:172
     7c0:	e1a00004 	mov	r0, r4
     7c4:	e8bd8010 	pop	{r4, pc}
     7c8:	000007b4 	.word	0x000007b4

000007cc <tcf_hash_new_index>:
tcf_hash_new_index():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:175
     7cc:	e92d4070 	push	{r4, r5, r6, lr}
     7d0:	e2806004 	add	r6, r0, #4
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:176
     7d4:	e5904008 	ldr	r4, [r0, #8]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:175
     7d8:	e1a05000 	mov	r5, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:180
     7dc:	e2944001 	adds	r4, r4, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:181
     7e0:	e1a01005 	mov	r1, r5
     7e4:	e1a02006 	mov	r2, r6
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:180
     7e8:	03a04001 	moveq	r4, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:181
     7ec:	e1a00004 	mov	r0, r4
     7f0:	ebffffdb 	bl	764 <tcf_hash_lookup.isra.12>
     7f4:	e3500000 	cmp	r0, #0
     7f8:	1afffff7 	bne	7dc <tcf_hash_new_index+0x10>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:183
     7fc:	e5854008 	str	r4, [r5, #8]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:185
     800:	e1a00004 	mov	r0, r4
     804:	e8bd8070 	pop	{r4, r5, r6, pc}

00000808 <tcf_hash_create>:
tcf_hash_create():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:217
     808:	e92d41f0 	push	{r4, r5, r6, r7, r8, lr}
     80c:	e1a05002 	mov	r5, r2
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:218
     810:	e5922004 	ldr	r2, [r2, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:217
     814:	e1a06000 	mov	r6, r0
     818:	e1a07001 	mov	r7, r1
kmalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:458
     81c:	e1a00003 	mov	r0, r3
     820:	e30810d0 	movw	r1, #32976	; 0x80d0
tcf_hash_create():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:218
     824:	e5928008 	ldr	r8, [r2, #8]
kzalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:458
     828:	ebfffffe 	bl	0 <__kmalloc>
tcf_hash_create():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:221
     82c:	e2504000 	subs	r4, r0, #0
     830:	0a000027 	beq	8d4 <tcf_hash_create+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:224
     834:	e59d3018 	ldr	r3, [sp, #24]
INIT_HLIST_NODE():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:599
     838:	e3a0c000 	mov	ip, #0
     83c:	e584c000 	str	ip, [r4]
tcf_hash_create():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:224
     840:	e3530000 	cmp	r3, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:223
     844:	e3a03001 	mov	r3, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:225
     848:	15843010 	strne	r3, [r4, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:229
     84c:	e3560000 	cmp	r6, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:223
     850:	e584300c 	str	r3, [r4, #12]
INIT_HLIST_NODE():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:600
     854:	e584c004 	str	ip, [r4, #4]
tcf_hash_create():
     858:	11a00006 	movne	r0, r6
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:229
     85c:	0a000015 	beq	8b8 <tcf_hash_create+0xb0>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:230 
(discriminator 3)
     860:	e300c000 	movw	ip, #0
     864:	e340c000 	movt	ip, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:232 
(discriminator 3)
     868:	e3570000 	cmp	r7, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:229 
(discriminator 3)
     86c:	e5840008 	str	r0, [r4, #8]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:230 
(discriminator 3)
     870:	e59c2000 	ldr	r2, [ip]
     874:	e3a00000 	mov	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:231 
(discriminator 3)
     878:	e59c3000 	ldr	r3, [ip]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:230 
(discriminator 3)
     87c:	e5840024 	str	r0, [r4, #36]	; 0x24
     880:	e5842020 	str	r2, [r4, #32]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:231 
(discriminator 3)
     884:	e5843028 	str	r3, [r4, #40]	; 0x28
     888:	e584002c 	str	r0, [r4, #44]	; 0x2c
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:232 
(discriminator 3)
     88c:	0a000006 	beq	8ac <tcf_hash_create+0xa4>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:233
     890:	e1a03007 	mov	r3, r7
     894:	e2840038 	add	r0, r4, #56	; 0x38
     898:	e2841058 	add	r1, r4, #88	; 0x58
     89c:	e2842068 	add	r2, r4, #104	; 0x68
     8a0:	ebfffffe 	bl	0 <gen_new_estimator>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:235
     8a4:	e2506000 	subs	r6, r0, #0
     8a8:	1a000005 	bne	8c4 <tcf_hash_create+0xbc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:241
     8ac:	e5854000 	str	r4, [r5]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:242
     8b0:	e1a00004 	mov	r0, r4
     8b4:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:229 
(discriminator 1)
     8b8:	e1a00008 	mov	r0, r8
     8bc:	ebfffffe 	bl	7cc <tcf_hash_new_index>
     8c0:	eaffffe6 	b	860 <tcf_hash_create+0x58>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:236
     8c4:	e1a00004 	mov	r0, r4
     8c8:	ebfffffe 	bl	0 <kfree>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:237
     8cc:	e1a00006 	mov	r0, r6
     8d0:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:222
     8d4:	e3e0000b 	mvn	r0, #11
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:243
     8d8:	e8bd81f0 	pop	{r4, r5, r6, r7, r8, pc}

000008dc <tcf_hash_search>:
tcf_hash_search():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:189
     8dc:	e92d4010 	push	{r4, lr}
     8e0:	e1a04000 	mov	r4, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:190
     8e4:	e5943004 	ldr	r3, [r4, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:191
     8e8:	e1a00001 	mov	r0, r1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:190
     8ec:	e5931008 	ldr	r1, [r3, #8]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:191
     8f0:	e2812004 	add	r2, r1, #4
     8f4:	ebffff9a 	bl	764 <tcf_hash_lookup.isra.12>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:193
     8f8:	e3500000 	cmp	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:194
     8fc:	15840000 	strne	r0, [r4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:195
     900:	13a00001 	movne	r0, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:198
     904:	e8bd8010 	pop	{r4, pc}

00000908 <tcf_hash_check>:
tcf_hash_check():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:202
     908:	e92d4038 	push	{r3, r4, r5, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:205
     90c:	e3500000 	cmp	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:203
     910:	e5913004 	ldr	r3, [r1, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:202
     914:	e1a04001 	mov	r4, r1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:203
     918:	e5931008 	ldr	r1, [r3, #8]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:205
     91c:	0a00000d 	beq	958 <tcf_hash_check+0x50>
     920:	e1a05002 	mov	r5, r2
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:205 
(discriminator 1)
     924:	e2812004 	add	r2, r1, #4
     928:	ebffff8d 	bl	764 <tcf_hash_lookup.isra.12>
     92c:	e3500000 	cmp	r0, #0
     930:	0a000008 	beq	958 <tcf_hash_check+0x50>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:206
     934:	e3550000 	cmp	r5, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:207
     938:	15903010 	ldrne	r3, [r0, #16]
     93c:	12833001 	addne	r3, r3, #1
     940:	15803010 	strne	r3, [r0, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:208
     944:	e590300c 	ldr	r3, [r0, #12]
     948:	e2833001 	add	r3, r3, #1
     94c:	e580300c 	str	r3, [r0, #12]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:209
     950:	e5840000 	str	r0, [r4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:212
     954:	e8bd8038 	pop	{r3, r4, r5, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:204
     958:	e3a00000 	mov	r0, #0
     95c:	e8bd8038 	pop	{r3, r4, r5, pc}

00000960 <tcf_action_exec>:
tcf_action_exec():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:344
     960:	e92d40f8 	push	{r3, r4, r5, r6, r7, lr}
     964:	e1a04000 	mov	r4, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:348
     968:	e1d037be 	ldrh	r3, [r0, #126]	; 0x7e
     96c:	e3130c01 	tst	r3, #256	; 0x100
     970:	1a000019 	bne	9dc <tcf_action_exec+0x7c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:353
     974:	e5915000 	ldr	r5, [r1]
     978:	e1a07001 	mov	r7, r1
     97c:	e1a06002 	mov	r6, r2
     980:	e1510005 	cmp	r1, r5
     984:	e2455010 	sub	r5, r5, #16
     988:	0a000017 	beq	9ec <tcf_action_exec+0x8c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:355
     98c:	e5953004 	ldr	r3, [r5, #4]
     990:	e1a00004 	mov	r0, r4
     994:	e1a01005 	mov	r1, r5
     998:	e1a02006 	mov	r2, r6
     99c:	e5933024 	ldr	r3, [r3, #36]	; 0x24
     9a0:	e12fff33 	blx	r3
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:356
     9a4:	e1d437be 	ldrh	r3, [r4, #126]	; 0x7e
     9a8:	e3130001 	tst	r3, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:359
     9ac:	e3c33001 	bic	r3, r3, #1
     9b0:	e3833002 	orr	r3, r3, #2
     9b4:	11c437be 	strhne	r3, [r4, #126]	; 0x7e
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:361
     9b8:	e3500006 	cmp	r0, #6
     9bc:	0afffff2 	beq	98c <tcf_action_exec+0x2c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:363
     9c0:	e3500003 	cmp	r0, #3
     9c4:	18bd80f8 	popne	{r3, r4, r5, r6, r7, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:353
     9c8:	e5955010 	ldr	r5, [r5, #16]
     9cc:	e1570005 	cmp	r7, r5
     9d0:	e2455010 	sub	r5, r5, #16
     9d4:	1affffec 	bne	98c <tcf_action_exec+0x2c>
     9d8:	e8bd80f8 	pop	{r3, r4, r5, r6, r7, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:349
     9dc:	e3c33c01 	bic	r3, r3, #256	; 0x100
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:350
     9e0:	e3a00000 	mov	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:349
     9e4:	e1c437be 	strh	r3, [r4, #126]	; 0x7e
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:351
     9e8:	e8bd80f8 	pop	{r3, r4, r5, r6, r7, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:346
     9ec:	e3e00000 	mvn	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:368
     9f0:	e8bd80f8 	pop	{r3, r4, r5, r6, r7, pc}

000009f4 <tca_action_flush.isra.16>:
kmalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:453
     9f4:	e300c000 	movw	ip, #0
     9f8:	e340c000 	movt	ip, #0
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:712
     9fc:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
     a00:	e1a08000 	mov	r8, r0
     a04:	e24dd064 	sub	sp, sp, #100	; 0x64
     a08:	e1a0a001 	mov	sl, r1
kmem_cache_alloc_trace():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:341
     a0c:	e59c0018 	ldr	r0, [ip, #24]
     a10:	e30810d0 	movw	r1, #32976	; 0x80d0
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:712
     a14:	e1a09002 	mov	r9, r2
     a18:	e1a07003 	mov	r7, r3
kzalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:341
     a1c:	ebfffffe 	bl	0 <kmem_cache_alloc>
create_a():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:703
     a20:	e2504000 	subs	r4, r0, #0
     a24:	0a00006d 	beq	be0 <tca_action_flush.isra.16+0x1ec>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:707
     a28:	e3a06000 	mov	r6, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:708
     a2c:	e2843010 	add	r3, r4, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:707
     a30:	e584600c 	str	r6, [r4, #12]
alloc_skb():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:668
     a34:	e1a02006 	mov	r2, r6
INIT_LIST_HEAD():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:26
     a38:	e5843010 	str	r3, [r4, #16]
alloc_skb():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:668
     a3c:	e3a00d3d 	mov	r0, #3904	; 0xf40
INIT_LIST_HEAD():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:27
     a40:	e5843014 	str	r3, [r4, #20]
alloc_skb():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:668
     a44:	e3a010d0 	mov	r1, #208	; 0xd0
     a48:	e3e03000 	mvn	r3, #0
     a4c:	ebfffffe 	bl	0 <__alloc_skb>
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:732
     a50:	e2505000 	subs	r5, r0, #0
     a54:	0a000063 	beq	be8 <tca_action_flush.isra.16+0x1f4>
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
     a58:	e1da30b0 	ldrh	r3, [sl]
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
     a5c:	e28a2004 	add	r2, sl, #4
     a60:	e28d000c 	add	r0, sp, #12
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:715
     a64:	e595a09c 	ldr	sl, [r5, #156]	; 0x9c
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
     a68:	e2433004 	sub	r3, r3, #4
     a6c:	e58d6000 	str	r6, [sp]
     a70:	e3a01005 	mov	r1, #5
     a74:	ebfffffe 	bl	0 <nla_parse>
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:741
     a78:	e2506000 	subs	r6, r0, #0
     a7c:	ba00002f 	blt	b40 <tca_action_flush.isra.16+0x14c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:746
     a80:	e59d0010 	ldr	r0, [sp, #16]
     a84:	ebfffea6 	bl	524 <tc_lookup_action>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:747
     a88:	e3500000 	cmp	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:746
     a8c:	e5840004 	str	r0, [r4, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:747
     a90:	0a000050 	beq	bd8 <tca_action_flush.isra.16+0x1e4>
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
     a94:	e5956054 	ldr	r6, [r5, #84]	; 0x54
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:750
     a98:	e5972000 	ldr	r2, [r7]
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
     a9c:	e3560000 	cmp	r6, #0
     aa0:	1a00002d 	bne	b5c <tca_action_flush.isra.16+0x168>
     aa4:	e59510a0 	ldr	r1, [r5, #160]	; 0xa0
     aa8:	e595309c 	ldr	r3, [r5, #156]	; 0x9c
     aac:	e0633001 	rsb	r3, r3, r1
nlmsg_put():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:446
     ab0:	e3530013 	cmp	r3, #19
     ab4:	da000028 	ble	b5c <tca_action_flush.isra.16+0x168>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:449
     ab8:	e3a03004 	mov	r3, #4
     abc:	e58d6004 	str	r6, [sp, #4]
     ac0:	e58d3000 	str	r3, [sp]
     ac4:	e1a00005 	mov	r0, r5
     ac8:	e59d1088 	ldr	r1, [sp, #136]	; 0x88
     acc:	e3a03031 	mov	r3, #49	; 0x31
     ad0:	ebfffffe 	bl	0 <__nlmsg_put>
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:751
     ad4:	e2507000 	subs	r7, r0, #0
     ad8:	0a00003b 	beq	bcc <tca_action_flush.isra.16+0x1d8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:754
     adc:	e5c76010 	strb	r6, [r7, #16]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     ae0:	e1a02006 	mov	r2, r6
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:755
     ae4:	e5c76011 	strb	r6, [r7, #17]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     ae8:	e1a03006 	mov	r3, r6
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:756
     aec:	e1c761b2 	strh	r6, [r7, #18]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     af0:	e1a00005 	mov	r0, r5
     af4:	e3a01001 	mov	r1, #1
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1110
     af8:	e595b09c 	ldr	fp, [r5, #156]	; 0x9c
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
     afc:	ebfffffe 	bl	0 <nla_put>
     b00:	e3500000 	cmp	r0, #0
     b04:	ba000030 	blt	bcc <tca_action_flush.isra.16+0x1d8>
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:759
     b08:	e35b0000 	cmp	fp, #0
     b0c:	0a00002e 	beq	bcc <tca_action_flush.isra.16+0x1d8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:762
     b10:	e594c004 	ldr	ip, [r4, #4]
     b14:	e1a00005 	mov	r0, r5
     b18:	e28d1024 	add	r1, sp, #36	; 0x24
     b1c:	e3a02031 	mov	r2, #49	; 0x31
     b20:	e1a03004 	mov	r3, r4
     b24:	e59cc038 	ldr	ip, [ip, #56]	; 0x38
     b28:	e12fff3c 	blx	ip
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:763
     b2c:	e2506000 	subs	r6, r0, #0
     b30:	b5940004 	ldrlt	r0, [r4, #4]
     b34:	ba000009 	blt	b60 <tca_action_flush.isra.16+0x16c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:765
     b38:	e3560000 	cmp	r6, #0
     b3c:	1a00000a 	bne	b6c <tca_action_flush.isra.16+0x178>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:785
     b40:	e1a00005 	mov	r0, r5
     b44:	ebfffffe 	bl	0 <kfree_skb>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:786
     b48:	e1a00004 	mov	r0, r4
     b4c:	ebfffffe 	bl	0 <kfree>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:787
     b50:	e1a00006 	mov	r0, r6
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:788
     b54:	e28dd064 	add	sp, sp, #100	; 0x64
     b58:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:744
     b5c:	e3e06015 	mvn	r6, #21
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:782
     b60:	e5900020 	ldr	r0, [r0, #32]
     b64:	ebfffffe 	bl	0 <module_put>
     b68:	eafffff4 	b	b40 <tca_action_flush.isra.16+0x14c>
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
     b6c:	e595309c 	ldr	r3, [r5, #156]	; 0x9c
     b70:	e06b3003 	rsb	r3, fp, r3
     b74:	e1cb30b0 	strh	r3, [fp]
tca_action_flush():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:770
     b78:	e595209c 	ldr	r2, [r5, #156]	; 0x9c
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:771
     b7c:	e1d730b6 	ldrh	r3, [r7, #6]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:770
     b80:	e06aa002 	rsb	sl, sl, r2
     b84:	e587a000 	str	sl, [r7]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:771
     b88:	e3833c01 	orr	r3, r3, #256	; 0x100
     b8c:	e1c730b6 	strh	r3, [r7, #6]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:772
     b90:	e5943004 	ldr	r3, [r4, #4]
     b94:	e5930020 	ldr	r0, [r3, #32]
     b98:	ebfffffe 	bl	0 <module_put>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:773
     b9c:	e1a00004 	mov	r0, r4
     ba0:	ebfffffe 	bl	0 <kfree>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:774
     ba4:	e1d930b0 	ldrh	r3, [r9]
     ba8:	e1a00005 	mov	r0, r5
     bac:	e1a01008 	mov	r1, r8
     bb0:	e2033008 	and	r3, r3, #8
     bb4:	e59d2088 	ldr	r2, [sp, #136]	; 0x88
     bb8:	e58d3000 	str	r3, [sp]
     bbc:	e3a03004 	mov	r3, #4
     bc0:	ebfffffe 	bl	0 <rtnetlink_send>
     bc4:	e0000fc0 	and	r0, r0, r0, asr #31
     bc8:	eaffffe1 	b	b54 <tca_action_flush.isra.16+0x160>
     bcc:	e5940004 	ldr	r0, [r4, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:744
     bd0:	e3e06015 	mvn	r6, #21
     bd4:	eaffffe1 	b	b60 <tca_action_flush.isra.16+0x16c>
     bd8:	e3e06015 	mvn	r6, #21
     bdc:	eaffffd7 	b	b40 <tca_action_flush.isra.16+0x14c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:728
     be0:	e3e0000b 	mvn	r0, #11
     be4:	eaffffda 	b	b54 <tca_action_flush.isra.16+0x160>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:734
     be8:	e1a00004 	mov	r0, r4
     bec:	ebfffffe 	bl	0 <kfree>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:735
     bf0:	e3e0000b 	mvn	r0, #11
     bf4:	eaffffd6 	b	b54 <tca_action_flush.isra.16+0x160>

00000bf8 <tcf_action_destroy>:
tcf_action_destroy():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:372
     bf8:	e92d43f8 	push	{r3, r4, r5, r6, r7, r8, r9, lr}
     bfc:	e1a06000 	mov	r6, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:375
     c00:	e5903000 	ldr	r3, [r0]
     c04:	e1500003 	cmp	r0, r3
     c08:	e2434010 	sub	r4, r3, #16
     c0c:	e5935000 	ldr	r5, [r3]
     c10:	e2455010 	sub	r5, r5, #16
     c14:	08bd83f8 	popeq	{r3, r4, r5, r6, r7, r8, r9, pc}
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107
     c18:	e3a08c01 	mov	r8, #256	; 0x100
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     c1c:	e3a07c02 	mov	r7, #512	; 0x200
     c20:	e1a09001 	mov	r9, r1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107
     c24:	e3408010 	movt	r8, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     c28:	e3407020 	movt	r7, #32
     c2c:	ea00000d 	b	c68 <tcf_action_destroy+0x70>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:106
     c30:	e5943014 	ldr	r3, [r4, #20]
tcf_action_destroy():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:379
     c34:	e1a00004 	mov	r0, r4
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:106
     c38:	e5942010 	ldr	r2, [r4, #16]
__list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:88
     c3c:	e5823004 	str	r3, [r2, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:89
     c40:	e5832000 	str	r2, [r3]
list_del():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:107
     c44:	e5848010 	str	r8, [r4, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:108
     c48:	e5847014 	str	r7, [r4, #20]
     c4c:	e1a04005 	mov	r4, r5
tcf_action_destroy():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:379
     c50:	ebfffffe 	bl	0 <kfree>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:375
     c54:	e1a03005 	mov	r3, r5
     c58:	e5b35010 	ldr	r5, [r3, #16]!
     c5c:	e1560003 	cmp	r6, r3
     c60:	e2455010 	sub	r5, r5, #16
     c64:	0a00000a 	beq	c94 <tcf_action_destroy+0x9c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:376
     c68:	e5943004 	ldr	r3, [r4, #4]
     c6c:	e1a00004 	mov	r0, r4
     c70:	e1a01009 	mov	r1, r9
     c74:	e593302c 	ldr	r3, [r3, #44]	; 0x2c
     c78:	e12fff33 	blx	r3
     c7c:	e3500001 	cmp	r0, #1
     c80:	1affffea 	bne	c30 <tcf_action_destroy+0x38>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:377
     c84:	e5943004 	ldr	r3, [r4, #4]
     c88:	e5930020 	ldr	r0, [r3, #32]
     c8c:	ebfffffe 	bl	0 <module_put>
     c90:	eaffffe6 	b	c30 <tcf_action_destroy+0x38>
     c94:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}

00000c98 <tcf_action_dump_old>:
tcf_action_dump_old():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:386
     c98:	e591c004 	ldr	ip, [r1, #4]
     c9c:	e59cc028 	ldr	ip, [ip, #40]	; 0x28
     ca0:	e12fff1c 	bx	ip

00000ca4 <tcf_action_init_1>:
tcf_action_init_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:444
     ca4:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
     ca8:	e3004000 	movw	r4, #0
     cac:	e3404000 	movt	r4, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:452
     cb0:	e2536000 	subs	r6, r3, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:444
     cb4:	e24dd038 	sub	sp, sp, #56	; 0x38
     cb8:	e1a09000 	mov	r9, r0
     cbc:	e5943000 	ldr	r3, [r4]
     cc0:	e1a07001 	mov	r7, r1
     cc4:	e1a08002 	mov	r8, r2
     cc8:	e58d3034 	str	r3, [sp, #52]	; 0x34
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:452
     ccc:	0a000029 	beq	d78 <tcf_action_init_1+0xd4>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:464
     cd0:	e28d5024 	add	r5, sp, #36	; 0x24
     cd4:	e1a01006 	mov	r1, r6
     cd8:	e3a02010 	mov	r2, #16
     cdc:	e1a00005 	mov	r0, r5
     ce0:	ebfffffe 	bl	0 <strlcpy>
     ce4:	e350000f 	cmp	r0, #15
     ce8:	8a000035 	bhi	dc4 <tcf_action_init_1+0x120>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:468
     cec:	e1a00005 	mov	r0, r5
     cf0:	ebfffde1 	bl	47c <tc_lookup_action_n>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:469
     cf4:	e250a000 	subs	sl, r0, #0
     cf8:	0a000039 	beq	de4 <tcf_action_init_1+0x140>
kmalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:453
     cfc:	e3003000 	movw	r3, #0
     d00:	e3403000 	movt	r3, #0
kmem_cache_alloc_trace():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:341
     d04:	e30810d0 	movw	r1, #32976	; 0x80d0
     d08:	e5930018 	ldr	r0, [r3, #24]
     d0c:	ebfffffe 	bl	0 <kmem_cache_alloc>
tcf_action_init_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:494
     d10:	e2505000 	subs	r5, r0, #0
     d14:	0a000040 	beq	e1c <tcf_action_init_1+0x178>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:500
     d18:	e3560000 	cmp	r6, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:498
     d1c:	e2853010 	add	r3, r5, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:497
     d20:	e585a004 	str	sl, [r5, #4]
INIT_LIST_HEAD():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:26
     d24:	e5853010 	str	r3, [r5, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:27
     d28:	e5853014 	str	r3, [r5, #20]
tcf_action_init_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:500
     d2c:	0a00003c 	beq	e24 <tcf_action_init_1+0x180>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:503
     d30:	e59d2058 	ldr	r2, [sp, #88]	; 0x58
     d34:	e1a00009 	mov	r0, r9
     d38:	e59d305c 	ldr	r3, [sp, #92]	; 0x5c
     d3c:	e1a01007 	mov	r1, r7
     d40:	e58d2000 	str	r2, [sp]
     d44:	e1a02008 	mov	r2, r8
     d48:	e58d3004 	str	r3, [sp, #4]
     d4c:	e1a03005 	mov	r3, r5
     d50:	e59ac034 	ldr	ip, [sl, #52]	; 0x34
     d54:	e12fff3c 	blx	ip
     d58:	e1a03000 	mov	r3, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:504
     d5c:	e3530000 	cmp	r3, #0
     d60:	ba00003b 	blt	e54 <tcf_action_init_1+0x1b0>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:511
     d64:	e3530001 	cmp	r3, #1
     d68:	0a000016 	beq	dc8 <tcf_action_init_1+0x124>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:519
     d6c:	e59a0020 	ldr	r0, [sl, #32]
     d70:	ebfffffe 	bl	0 <module_put>
     d74:	ea000013 	b	dc8 <tcf_action_init_1+0x124>
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
     d78:	e1d130b0 	ldrh	r3, [r1]
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
     d7c:	e28d000c 	add	r0, sp, #12
     d80:	e58d6000 	str	r6, [sp]
     d84:	e3a01005 	mov	r1, #5
     d88:	e2433004 	sub	r3, r3, #4
     d8c:	e2872004 	add	r2, r7, #4
     d90:	ebfffffe 	bl	0 <nla_parse>
tcf_action_init_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:454
     d94:	e3500000 	cmp	r0, #0
     d98:	b1a05000 	movlt	r5, r0
     d9c:	ba000009 	blt	dc8 <tcf_action_init_1+0x124>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:457
     da0:	e59d1010 	ldr	r1, [sp, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:458
     da4:	e3510000 	cmp	r1, #0
     da8:	0a000005 	beq	dc4 <tcf_action_init_1+0x120>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:460
     dac:	e28d5024 	add	r5, sp, #36	; 0x24
     db0:	e3a02010 	mov	r2, #16
     db4:	e1a00005 	mov	r0, r5
     db8:	ebfffffe 	bl	0 <nla_strlcpy>
     dbc:	e350000f 	cmp	r0, #15
     dc0:	9affffc9 	bls	cec <tcf_action_init_1+0x48>
     dc4:	e3e05015 	mvn	r5, #21
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:522
     dc8:	e59d2034 	ldr	r2, [sp, #52]	; 0x34
     dcc:	e1a00005 	mov	r0, r5
     dd0:	e5943000 	ldr	r3, [r4]
     dd4:	e1520003 	cmp	r2, r3
     dd8:	1a000021 	bne	e64 <tcf_action_init_1+0x1c0>
     ddc:	e28dd038 	add	sp, sp, #56	; 0x38
     de0:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:471
     de4:	ebfffffe 	bl	0 <rtnl_unlock>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:472
     de8:	e1a02005 	mov	r2, r5
     dec:	e3001000 	movw	r1, #0
     df0:	e3a00001 	mov	r0, #1
     df4:	e3401000 	movt	r1, #0
     df8:	ebfffffe 	bl	0 <__request_module>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:473
     dfc:	ebfffffe 	bl	0 <rtnl_lock>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:475
     e00:	e1a00005 	mov	r0, r5
     e04:	ebfffd9c 	bl	47c <tc_lookup_action_n>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:483
     e08:	e250a000 	subs	sl, r0, #0
     e0c:	03e05001 	mvneq	r5, #1
     e10:	0affffec 	beq	dc8 <tcf_action_init_1+0x124>
     e14:	e3e0500a 	mvn	r5, #10
     e18:	eaffffd3 	b	d6c <tcf_action_init_1+0xc8>
     e1c:	e3e0500b 	mvn	r5, #11
     e20:	eaffffd1 	b	d6c <tcf_action_init_1+0xc8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:501
     e24:	e59d2058 	ldr	r2, [sp, #88]	; 0x58
     e28:	e1a00009 	mov	r0, r9
     e2c:	e59d305c 	ldr	r3, [sp, #92]	; 0x5c
     e30:	e59d1014 	ldr	r1, [sp, #20]
     e34:	e58d2000 	str	r2, [sp]
     e38:	e1a02008 	mov	r2, r8
     e3c:	e58d3004 	str	r3, [sp, #4]
     e40:	e1a03005 	mov	r3, r5
     e44:	e59ac034 	ldr	ip, [sl, #52]	; 0x34
     e48:	e12fff3c 	blx	ip
     e4c:	e1a03000 	mov	r3, r0
     e50:	eaffffc1 	b	d5c <tcf_action_init_1+0xb8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:517
     e54:	e1a00005 	mov	r0, r5
     e58:	e1a05003 	mov	r5, r3
     e5c:	ebfffffe 	bl	0 <kfree>
     e60:	eaffffc1 	b	d6c <tcf_action_init_1+0xc8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:522
     e64:	ebfffffe 	bl	0 <__stack_chk_fail>

00000e68 <tcf_action_init>:
tcf_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:527
     e68:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
     e6c:	e24dd094 	sub	sp, sp, #148	; 0x94
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
     e70:	e1d1c0b0 	ldrh	ip, [r1]
tcf_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:527
     e74:	e1a07000 	mov	r7, r0
     e78:	e1a08002 	mov	r8, r2
     e7c:	e1a09003 	mov	r9, r3
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
     e80:	e2812004 	add	r2, r1, #4
     e84:	e24c3004 	sub	r3, ip, #4
     e88:	e28d000c 	add	r0, sp, #12
     e8c:	e3a0c000 	mov	ip, #0
     e90:	e3a01020 	mov	r1, #32
     e94:	e58dc000 	str	ip, [sp]
tcf_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:527
     e98:	e59da0bc 	ldr	sl, [sp, #188]	; 0xbc
     e9c:	e59d60c0 	ldr	r6, [sp, #192]	; 0xc0
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
     ea0:	ebfffffe 	bl	0 <nla_parse>
tcf_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:534
     ea4:	e3500000 	cmp	r0, #0
     ea8:	ba000019 	blt	f14 <tcf_action_init+0xac>
     eac:	e28db00c 	add	fp, sp, #12
     eb0:	e3a05001 	mov	r5, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:537 
(discriminator 2)
     eb4:	e5bb1004 	ldr	r1, [fp, #4]!
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:538 
(discriminator 2)
     eb8:	e1a00007 	mov	r0, r7
     ebc:	e1a02008 	mov	r2, r8
     ec0:	e1a03009 	mov	r3, r9
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:537 
(discriminator 2)
     ec4:	e3510000 	cmp	r1, #0
     ec8:	0a000010 	beq	f10 <tcf_action_init+0xa8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:538
     ecc:	e59dc0b8 	ldr	ip, [sp, #184]	; 0xb8
     ed0:	e58da004 	str	sl, [sp, #4]
     ed4:	e58dc000 	str	ip, [sp]
     ed8:	ebfffffe 	bl	ca4 <tcf_action_init_1>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:539
     edc:	e3700a01 	cmn	r0, #4096	; 0x1000
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:538
     ee0:	e1a04000 	mov	r4, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:544
     ee4:	e2802010 	add	r2, r0, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:539
     ee8:	8a00000b 	bhi	f1c <tcf_action_init+0xb4>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:543
     eec:	e580500c 	str	r5, [r0, #12]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:537
     ef0:	e2855001 	add	r5, r5, #1
list_add_tail():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:76
     ef4:	e5963004 	ldr	r3, [r6, #4]
tcf_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:537
     ef8:	e3550021 	cmp	r5, #33	; 0x21
__list_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:41
     efc:	e5862004 	str	r2, [r6, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:42
     f00:	e5806010 	str	r6, [r0, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:43
     f04:	e5803014 	str	r3, [r0, #20]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:44
     f08:	e5832000 	str	r2, [r3]
tcf_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:537
     f0c:	1affffe8 	bne	eb4 <tcf_action_init+0x4c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:546
     f10:	e3a00000 	mov	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:551
     f14:	e28dd094 	add	sp, sp, #148	; 0x94
     f18:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:549
     f1c:	e1a00006 	mov	r0, r6
     f20:	e1a0100a 	mov	r1, sl
     f24:	ebfffffe 	bl	bf8 <tcf_action_destroy>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:550
     f28:	e1a00004 	mov	r0, r4
     f2c:	eafffff8 	b	f14 <tcf_action_init+0xac>

00000f30 <tcf_action_copy_stats>:
tcf_action_copy_stats():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:555
     f30:	e92d4070 	push	{r4, r5, r6, lr}
     f34:	e24dd050 	sub	sp, sp, #80	; 0x50
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:558
     f38:	e5914000 	ldr	r4, [r1]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:560
     f3c:	e3540000 	cmp	r4, #0
     f40:	0a00002d 	beq	ffc <tcf_action_copy_stats+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:566
     f44:	e3520000 	cmp	r2, #0
     f48:	0a000005 	beq	f64 <tcf_action_copy_stats+0x34>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:567
     f4c:	e5913008 	ldr	r3, [r1, #8]
     f50:	e3530006 	cmp	r3, #6
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:571
     f54:	13a00000 	movne	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:567
     f58:	0a00001e 	beq	fd8 <tcf_action_copy_stats+0xa8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:592
     f5c:	e28dd050 	add	sp, sp, #80	; 0x50
     f60:	e8bd8070 	pop	{r4, r5, r6, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:573
     f64:	e28d5008 	add	r5, sp, #8
     f68:	e3a01004 	mov	r1, #4
     f6c:	e2842068 	add	r2, r4, #104	; 0x68
     f70:	e1a03005 	mov	r3, r5
     f74:	ebfffffe 	bl	0 <gnet_stats_start_copy>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:576
     f78:	e3500000 	cmp	r0, #0
     f7c:	ba00001e 	blt	ffc <tcf_action_copy_stats+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:579
     f80:	e2846038 	add	r6, r4, #56	; 0x38
     f84:	e1a00005 	mov	r0, r5
     f88:	e1a01006 	mov	r1, r6
     f8c:	ebfffffe 	bl	0 <gnet_stats_copy_basic>
     f90:	e3500000 	cmp	r0, #0
     f94:	ba000018 	blt	ffc <tcf_action_copy_stats+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:580 
(discriminator 1)
     f98:	e1a01006 	mov	r1, r6
     f9c:	e1a00005 	mov	r0, r5
     fa0:	e2842058 	add	r2, r4, #88	; 0x58
     fa4:	ebfffffe 	bl	0 <gnet_stats_copy_rate_est>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:579 
(discriminator 1)
     fa8:	e3500000 	cmp	r0, #0
     fac:	ba000012 	blt	ffc <tcf_action_copy_stats+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:582
     fb0:	e2841044 	add	r1, r4, #68	; 0x44
     fb4:	e1a00005 	mov	r0, r5
     fb8:	ebfffffe 	bl	0 <gnet_stats_copy_queue>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:581
     fbc:	e3500000 	cmp	r0, #0
     fc0:	ba00000d 	blt	ffc <tcf_action_copy_stats+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:585
     fc4:	e1a00005 	mov	r0, r5
     fc8:	ebfffffe 	bl	0 <gnet_stats_finish_copy>
     fcc:	e1a00fc0 	asr	r0, r0, #31
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:592
     fd0:	e28dd050 	add	sp, sp, #80	; 0x50
     fd4:	e8bd8070 	pop	{r4, r5, r6, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:568
     fd8:	e2843068 	add	r3, r4, #104	; 0x68
     fdc:	e28d5008 	add	r5, sp, #8
     fe0:	e58d3000 	str	r3, [sp]
     fe4:	e3a01000 	mov	r1, #0
     fe8:	e58d5004 	str	r5, [sp, #4]
     fec:	e3a02003 	mov	r2, #3
     ff0:	e3a03004 	mov	r3, #4
     ff4:	ebfffffe 	bl	0 <gnet_stats_start_copy_compat>
     ff8:	eaffffde 	b	f78 <tcf_action_copy_stats+0x48>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:591
     ffc:	e3e00000 	mvn	r0, #0
    1000:	eaffffd5 	b	f5c <tcf_action_copy_stats+0x2c>

00001004 <tcf_action_dump_1>:
tcf_action_dump_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:391
    1004:	e92d43f8 	push	{r3, r4, r5, r6, r7, r8, r9, lr}
    1008:	e1a04000 	mov	r4, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:396
    100c:	e5915004 	ldr	r5, [r1, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:391
    1010:	e1a07001 	mov	r7, r1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:390
    1014:	e590609c 	ldr	r6, [r0, #156]	; 0x9c
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:391
    1018:	e1a09002 	mov	r9, r2
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:396
    101c:	e285500c 	add	r5, r5, #12
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:391
    1020:	e1a08003 	mov	r8, r3
nla_put_string():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:935
    1024:	e1a00005 	mov	r0, r5
    1028:	ebfffffe 	bl	0 <strlen>
    102c:	e3a01001 	mov	r1, #1
    1030:	e1a03005 	mov	r3, r5
    1034:	e0802001 	add	r2, r0, r1
    1038:	e1a00004 	mov	r0, r4
    103c:	ebfffffe 	bl	0 <nla_put>
tcf_action_dump_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:396
    1040:	e2502000 	subs	r2, r0, #0
    1044:	0a000009 	beq	1070 <tcf_action_dump_1+0x6c>
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:523
    1048:	e3560000 	cmp	r6, #0
    104c:	0a000005 	beq	1068 <tcf_action_dump_1+0x64>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:524
    1050:	e59410a8 	ldr	r1, [r4, #168]	; 0xa8
    1054:	e1a00004 	mov	r0, r4
    1058:	e0611006 	rsb	r1, r1, r6
    105c:	ebfffffe 	bl	0 <skb_trim>
tcf_action_dump_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:411
    1060:	e3e00000 	mvn	r0, #0
    1064:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}
    1068:	e3e00000 	mvn	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:412
    106c:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:398
    1070:	e1a00004 	mov	r0, r4
    1074:	e1a01007 	mov	r1, r7
    1078:	ebfffffe 	bl	f30 <tcf_action_copy_stats>
    107c:	e2502000 	subs	r2, r0, #0
    1080:	1afffff0 	bne	1048 <tcf_action_dump_1+0x44>
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1084:	e1a00004 	mov	r0, r4
    1088:	e1a03002 	mov	r3, r2
    108c:	e3a01002 	mov	r1, #2
tcf_action_dump_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1110
    1090:	e594509c 	ldr	r5, [r4, #156]	; 0x9c
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1094:	ebfffffe 	bl	0 <nla_put>
    1098:	e3500000 	cmp	r0, #0
    109c:	baffffe9 	blt	1048 <tcf_action_dump_1+0x44>
tcf_action_dump_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:401
    10a0:	e3550000 	cmp	r5, #0
    10a4:	0affffe7 	beq	1048 <tcf_action_dump_1+0x44>
tcf_action_dump_old():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:386
    10a8:	e597c004 	ldr	ip, [r7, #4]
    10ac:	e1a02009 	mov	r2, r9
    10b0:	e1a03008 	mov	r3, r8
    10b4:	e1a01007 	mov	r1, r7
    10b8:	e1a00004 	mov	r0, r4
    10bc:	e59cc028 	ldr	ip, [ip, #40]	; 0x28
    10c0:	e12fff3c 	blx	ip
tcf_action_dump_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:404
    10c4:	e3500000 	cmp	r0, #0
    10c8:	daffffde 	ble	1048 <tcf_action_dump_1+0x44>
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
    10cc:	e594309c 	ldr	r3, [r4, #156]	; 0x9c
    10d0:	e0653003 	rsb	r3, r5, r3
    10d4:	e1c530b0 	strh	r3, [r5]
tcf_action_dump_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:406
    10d8:	e8bd83f8 	pop	{r3, r4, r5, r6, r7, r8, r9, pc}

000010dc <tcf_generic_walker>:
tcf_generic_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:148
    10dc:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:149
    10e0:	e3520031 	cmp	r2, #49	; 0x31
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:148
    10e4:	e24dd014 	sub	sp, sp, #20
    10e8:	e1a09003 	mov	r9, r3
    10ec:	e1a0a000 	mov	sl, r0
    10f0:	e58d1004 	str	r1, [sp, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:149
    10f4:	0a000053 	beq	1248 <tcf_generic_walker+0x16c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:151
    10f8:	e3520032 	cmp	r2, #50	; 0x32
    10fc:	1a00009d 	bne	1378 <tcf_generic_walker+0x29c>
current_thread_info():
/home/kelly/source/src/Kernel/linux-3.14.0-
plug/arch/arm/include/asm/thread_info.h:110
    1100:	e1a0100d 	mov	r1, sp
    1104:	e3c12d7f 	bic	r2, r1, #8128	; 0x1fc0
    1108:	e3c2203f 	bic	r2, r2, #63	; 0x3f
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:67
    110c:	e5931004 	ldr	r1, [r3, #4]
spin_lock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
    1110:	e5923004 	ldr	r3, [r2, #4]
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:67
    1114:	e591b008 	ldr	fp, [r1, #8]
__preempt_count_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/asm-
generic/preempt.h:56
    1118:	e2833c02 	add	r3, r3, #512	; 0x200
    111c:	e2833001 	add	r3, r3, #1
    1120:	e5823004 	str	r3, [r2, #4]
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:77
    1124:	e59b3004 	ldr	r3, [fp, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:70
    1128:	e3a06000 	mov	r6, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:75
    112c:	e59d2004 	ldr	r2, [sp, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:77
    1130:	e3730001 	cmn	r3, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:75
    1134:	e5928024 	ldr	r8, [r2, #36]	; 0x24
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:77
    1138:	0a000029 	beq	11e4 <tcf_generic_walker+0x108>
    113c:	e1a0a00b 	mov	sl, fp
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:70
    1140:	e3e05000 	mvn	r5, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:77
    1144:	e1a02006 	mov	r2, r6
    1148:	e1a0b000 	mov	fp, r0
    114c:	e58d6000 	str	r6, [sp]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:78
    1150:	e59a1000 	ldr	r1, [sl]
tcf_hash():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/act_api.h:47
    1154:	e0022003 	and	r2, r2, r3
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:80
    1158:	e7914102 	ldr	r4, [r1, r2, lsl #2]
    115c:	e3540000 	cmp	r4, #0
    1160:	1a000003 	bne	1174 <tcf_generic_walker+0x98>
    1164:	ea00002a 	b	1214 <tcf_generic_walker+0x138>
    1168:	e5944000 	ldr	r4, [r4]
    116c:	e3540000 	cmp	r4, #0
    1170:	0a000026 	beq	1210 <tcf_generic_walker+0x134>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:81
    1174:	e2855001 	add	r5, r5, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:82
    1178:	e1580005 	cmp	r8, r5
    117c:	cafffff9 	bgt	1168 <tcf_generic_walker+0x8c>
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1180:	e3a02000 	mov	r2, #0
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:84
    1184:	e5894000 	str	r4, [r9]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:85
    1188:	e589600c 	str	r6, [r9, #12]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    118c:	e1a03002 	mov	r3, r2
    1190:	e1a0000b 	mov	r0, fp
    1194:	e1a01006 	mov	r1, r6
tcf_generic_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1110
    1198:	e59b709c 	ldr	r7, [fp, #156]	; 0x9c
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    119c:	ebfffffe 	bl	0 <nla_put>
    11a0:	e3500000 	cmp	r0, #0
    11a4:	ba00000e 	blt	11e4 <tcf_generic_walker+0x108>
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:88
    11a8:	e3570000 	cmp	r7, #0
    11ac:	0a00000c 	beq	11e4 <tcf_generic_walker+0x108>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:90
    11b0:	e3a02000 	mov	r2, #0
    11b4:	e1a0000b 	mov	r0, fp
    11b8:	e1a03002 	mov	r3, r2
    11bc:	e1a01009 	mov	r1, r9
    11c0:	ebfffffe 	bl	1004 <tcf_action_dump_1>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:91
    11c4:	e3500000 	cmp	r0, #0
    11c8:	ba000019 	blt	1234 <tcf_generic_walker+0x158>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:97
    11cc:	e2866001 	add	r6, r6, #1
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
    11d0:	e59b309c 	ldr	r3, [fp, #156]	; 0x9c
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:98
    11d4:	e356001f 	cmp	r6, #31
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
    11d8:	e0673003 	rsb	r3, r7, r3
    11dc:	e1c730b0 	strh	r3, [r7]
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:98
    11e0:	daffffe0 	ble	1168 <tcf_generic_walker+0x8c>
spin_unlock_bh():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/spinlock.h:348
    11e4:	e59f01bc 	ldr	r0, [pc, #444]	; 13a8 <tcf_generic_walker+0x2cc>
    11e8:	e3001201 	movw	r1, #513	; 0x201
    11ec:	ebfffffe 	bl	0 <__local_bh_enable_ip>
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:104
    11f0:	e3560000 	cmp	r6, #0
tcf_generic_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:152
    11f4:	e1a00006 	mov	r0, r6
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:105
    11f8:	159d2004 	ldrne	r2, [sp, #4]
    11fc:	15923024 	ldrne	r3, [r2, #36]	; 0x24
    1200:	10833006 	addne	r3, r3, r6
    1204:	15823024 	strne	r3, [r2, #36]	; 0x24
tcf_generic_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:157
    1208:	e28dd014 	add	sp, sp, #20
    120c:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
    1210:	e59a3004 	ldr	r3, [sl, #4]
tcf_dump_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:77
    1214:	e59d1000 	ldr	r1, [sp]
    1218:	e2832001 	add	r2, r3, #1
    121c:	e2811001 	add	r1, r1, #1
    1220:	e58d1000 	str	r1, [sp]
    1224:	e1510002 	cmp	r1, r2
    1228:	e1a02001 	mov	r2, r1
    122c:	3affffc7 	bcc	1150 <tcf_generic_walker+0x74>
    1230:	eaffffeb 	b	11e4 <tcf_generic_walker+0x108>
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:524
    1234:	e59b10a8 	ldr	r1, [fp, #168]	; 0xa8
    1238:	e1a0000b 	mov	r0, fp
    123c:	e0611007 	rsb	r1, r1, r7
    1240:	ebfffffe 	bl	0 <skb_trim>
    1244:	eaffffe6 	b	11e4 <tcf_generic_walker+0x108>
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:115
    1248:	e593e004 	ldr	lr, [r3, #4]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    124c:	e3a02000 	mov	r2, #0
    1250:	e1a03002 	mov	r3, r2
    1254:	e599100c 	ldr	r1, [r9, #12]
tcf_generic_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1110
    1258:	e590709c 	ldr	r7, [r0, #156]	; 0x9c
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:115
    125c:	e59e5008 	ldr	r5, [lr, #8]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1260:	ebfffffe 	bl	0 <nla_put>
    1264:	e3500000 	cmp	r0, #0
    1268:	ba000040 	blt	1370 <tcf_generic_walker+0x294>
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:123
    126c:	e3570000 	cmp	r7, #0
    1270:	0a00003e 	beq	1370 <tcf_generic_walker+0x294>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:125
    1274:	e5994004 	ldr	r4, [r9, #4]
    1278:	e284400c 	add	r4, r4, #12
nla_put_string():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:935
    127c:	e1a00004 	mov	r0, r4
    1280:	ebfffffe 	bl	0 <strlen>
    1284:	e3a01001 	mov	r1, #1
    1288:	e1a03004 	mov	r3, r4
    128c:	e0802001 	add	r2, r0, r1
    1290:	e1a0000a 	mov	r0, sl
    1294:	ebfffffe 	bl	0 <nla_put>
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:125
    1298:	e3500000 	cmp	r0, #0
    129c:	1a00002f 	bne	1360 <tcf_generic_walker+0x284>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:127
    12a0:	e5952004 	ldr	r2, [r5, #4]
    12a4:	e3720001 	cmn	r2, #1
    12a8:	0a00003b 	beq	139c <tcf_generic_walker+0x2c0>
    12ac:	e1a08000 	mov	r8, r0
    12b0:	e1a06000 	mov	r6, r0
    12b4:	e1a03000 	mov	r3, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:129
    12b8:	e5951000 	ldr	r1, [r5]
tcf_hash():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/act_api.h:47
    12bc:	e0033002 	and	r3, r3, r2
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:129
    12c0:	e7913103 	ldr	r3, [r1, r3, lsl #2]
    12c4:	e3530000 	cmp	r3, #0
    12c8:	1a000003 	bne	12dc <tcf_generic_walker+0x200>
    12cc:	ea000010 	b	1314 <tcf_generic_walker+0x238>
    12d0:	e3540000 	cmp	r4, #0
    12d4:	0a00000d 	beq	1310 <tcf_generic_walker+0x234>
    12d8:	e1a03004 	mov	r3, r4
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:130
    12dc:	e1a00003 	mov	r0, r3
    12e0:	e3a01000 	mov	r1, #0
    12e4:	e1a02005 	mov	r2, r5
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:129
    12e8:	e5934000 	ldr	r4, [r3]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:130
    12ec:	ebfffffe 	bl	dc <tcf_hash_release>
    12f0:	e3500001 	cmp	r0, #1
    12f4:	1afffff5 	bne	12d0 <tcf_generic_walker+0x1f4>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:131
    12f8:	e5993004 	ldr	r3, [r9, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:132
    12fc:	e2888001 	add	r8, r8, #1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:131
    1300:	e5930020 	ldr	r0, [r3, #32]
    1304:	ebfffffe 	bl	0 <module_put>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:129
    1308:	e3540000 	cmp	r4, #0
    130c:	1afffff1 	bne	12d8 <tcf_generic_walker+0x1fc>
    1310:	e5952004 	ldr	r2, [r5, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:127
    1314:	e2866001 	add	r6, r6, #1
    1318:	e2823001 	add	r3, r2, #1
    131c:	e1560003 	cmp	r6, r3
    1320:	e1a03006 	mov	r3, r6
    1324:	3affffe3 	bcc	12b8 <tcf_generic_walker+0x1dc>
    1328:	e1a02008 	mov	r2, r8
    132c:	e28d3010 	add	r3, sp, #16
nla_put_u32():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:802
    1330:	e1a0000a 	mov	r0, sl
    1334:	e3a01006 	mov	r1, #6
    1338:	e5232004 	str	r2, [r3, #-4]!
    133c:	e3a02004 	mov	r2, #4
    1340:	ebfffffe 	bl	0 <nla_put>
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:136
    1344:	e3500000 	cmp	r0, #0
    1348:	1a000004 	bne	1360 <tcf_generic_walker+0x284>
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
    134c:	e59a309c 	ldr	r3, [sl, #156]	; 0x9c
    1350:	e1a00008 	mov	r0, r8
    1354:	e0673003 	rsb	r3, r7, r3
    1358:	e1c730b0 	strh	r3, [r7]
    135c:	eaffffa9 	b	1208 <tcf_generic_walker+0x12c>
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:524
    1360:	e59a10a8 	ldr	r1, [sl, #168]	; 0xa8
    1364:	e1a0000a 	mov	r0, sl
    1368:	e0611007 	rsb	r1, r1, r7
    136c:	ebfffffe 	bl	0 <skb_trim>
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:143
    1370:	e3e00015 	mvn	r0, #21
    1374:	eaffffa3 	b	1208 <tcf_generic_walker+0x12c>
tcf_generic_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:154
    1378:	e1a03002 	mov	r3, r2
    137c:	e3000000 	movw	r0, #0
    1380:	e3002000 	movw	r2, #0
    1384:	e3400000 	movt	r0, #0
    1388:	e3402000 	movt	r2, #0
    138c:	e3a0109a 	mov	r1, #154	; 0x9a
    1390:	ebfffffe 	bl	0 <warn_slowpath_fmt>
    1394:	e3e00015 	mvn	r0, #21
    1398:	eaffff9a 	b	1208 <tcf_generic_walker+0x12c>
tcf_del_walker():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:127
    139c:	e1a02000 	mov	r2, r0
    13a0:	e1a08000 	mov	r8, r0
    13a4:	eaffffe0 	b	132c <tcf_generic_walker+0x250>
    13a8:	000011e4 	.word	0x000011e4

000013ac <tcf_action_dump>:
tcf_action_dump():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:417
    13ac:	e92d47f0 	push	{r4, r5, r6, r7, r8, r9, sl, lr}
    13b0:	e1a07001 	mov	r7, r1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:422
    13b4:	e5915000 	ldr	r5, [r1]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:417
    13b8:	e1a04000 	mov	r4, r0
    13bc:	e1a09002 	mov	r9, r2
    13c0:	e1a08003 	mov	r8, r3
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:422
    13c4:	e1510005 	cmp	r1, r5
    13c8:	e2455010 	sub	r5, r5, #16
    13cc:	1a00000c 	bne	1404 <tcf_action_dump+0x58>
    13d0:	ea000019 	b	143c <tcf_action_dump+0x90>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:424
    13d4:	e3560000 	cmp	r6, #0
    13d8:	0a000015 	beq	1434 <tcf_action_dump+0x88>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:426
    13dc:	ebfffffe 	bl	1004 <tcf_action_dump_1>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:427
    13e0:	e250a000 	subs	sl, r0, #0
    13e4:	ba000016 	blt	1444 <tcf_action_dump+0x98>
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
    13e8:	e594009c 	ldr	r0, [r4, #156]	; 0x9c
    13ec:	e0660000 	rsb	r0, r6, r0
    13f0:	e1c600b0 	strh	r0, [r6]
tcf_action_dump():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:422
    13f4:	e5955010 	ldr	r5, [r5, #16]
    13f8:	e1570005 	cmp	r7, r5
    13fc:	e2455010 	sub	r5, r5, #16
    1400:	0a00000d 	beq	143c <tcf_action_dump+0x90>
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1404:	e3a02000 	mov	r2, #0
    1408:	e595100c 	ldr	r1, [r5, #12]
    140c:	e1a03002 	mov	r3, r2
    1410:	e1a00004 	mov	r0, r4
tcf_action_dump():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1110
    1414:	e594609c 	ldr	r6, [r4, #156]	; 0x9c
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1418:	ebfffffe 	bl	0 <nla_put>
tcf_action_dump():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:426
    141c:	e1a01005 	mov	r1, r5
    1420:	e1a02009 	mov	r2, r9
    1424:	e1a03008 	mov	r3, r8
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1428:	e3500000 	cmp	r0, #0
tcf_action_dump():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:426
    142c:	e1a00004 	mov	r0, r4
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    1430:	aaffffe7 	bge	13d4 <tcf_action_dump+0x28>
tcf_action_dump():
    1434:	e3e00015 	mvn	r0, #21
    1438:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:432
    143c:	e3a00000 	mov	r0, #0
    1440:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:524
    1444:	e59410a8 	ldr	r1, [r4, #168]	; 0xa8
    1448:	e1a00004 	mov	r0, r4
    144c:	e0611006 	rsb	r1, r1, r6
    1450:	ebfffffe 	bl	0 <skb_trim>
tcf_action_dump():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:426
    1454:	e1a0000a 	mov	r0, sl
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:439
    1458:	e8bd87f0 	pop	{r4, r5, r6, r7, r8, r9, sl, pc}

0000145c <tca_get_fill.constprop.22>:
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:595
    145c:	e92d43f0 	push	{r4, r5, r6, r7, r8, r9, lr}
    1460:	e24dd00c 	sub	sp, sp, #12
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
    1464:	e5905054 	ldr	r5, [r0, #84]	; 0x54
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:595
    1468:	e1a04000 	mov	r4, r0
    146c:	e590709c 	ldr	r7, [r0, #156]	; 0x9c
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
    1470:	e3550000 	cmp	r5, #0
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:595
    1474:	e1ddc2b8 	ldrh	ip, [sp, #40]	; 0x28
skb_tailroom():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:1569
    1478:	1a00002a 	bne	1528 <tca_get_fill.constprop.22+0xcc>
    147c:	e1a08001 	mov	r8, r1
    1480:	e59010a0 	ldr	r1, [r0, #160]	; 0xa0
    1484:	e0671001 	rsb	r1, r7, r1
nlmsg_put():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:446
    1488:	e3510013 	cmp	r1, #19
    148c:	da000025 	ble	1528 <tca_get_fill.constprop.22+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:449
    1490:	e58dc004 	str	ip, [sp, #4]
    1494:	e1a01002 	mov	r1, r2
    1498:	e3a0c004 	mov	ip, #4
    149c:	e1a02003 	mov	r2, r3
    14a0:	e58dc000 	str	ip, [sp]
    14a4:	e59d302c 	ldr	r3, [sp, #44]	; 0x2c
    14a8:	ebfffffe 	bl	0 <__nlmsg_put>
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:604
    14ac:	e2506000 	subs	r6, r0, #0
    14b0:	0a00001c 	beq	1528 <tca_get_fill.constprop.22+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:607
    14b4:	e5c65010 	strb	r5, [r6, #16]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    14b8:	e1a00004 	mov	r0, r4
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:608
    14bc:	e5c65011 	strb	r5, [r6, #17]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    14c0:	e3a01001 	mov	r1, #1
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:609
    14c4:	e1c651b2 	strh	r5, [r6, #18]
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    14c8:	e1a02005 	mov	r2, r5
    14cc:	e1a03005 	mov	r3, r5
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1110
    14d0:	e594909c 	ldr	r9, [r4, #156]	; 0x9c
nla_nest_start():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1114
    14d4:	ebfffffe 	bl	0 <nla_put>
    14d8:	e3500000 	cmp	r0, #0
    14dc:	ba000011 	blt	1528 <tca_get_fill.constprop.22+0xcc>
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:612
    14e0:	e3590000 	cmp	r9, #0
    14e4:	0a00000f 	beq	1528 <tca_get_fill.constprop.22+0xcc>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:615
    14e8:	e1a01008 	mov	r1, r8
    14ec:	e1a02005 	mov	r2, r5
    14f0:	e1a00004 	mov	r0, r4
    14f4:	e59d3030 	ldr	r3, [sp, #48]	; 0x30
    14f8:	ebfffffe 	bl	13ac <tcf_action_dump>
    14fc:	e3500000 	cmp	r0, #0
    1500:	ba000008 	blt	1528 <tca_get_fill.constprop.22+0xcc>
nla_nest_end():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:1132
    1504:	e594309c 	ldr	r3, [r4, #156]	; 0x9c
    1508:	e0693003 	rsb	r3, r9, r3
    150c:	e1c930b0 	strh	r3, [r9]
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:620
    1510:	e594309c 	ldr	r3, [r4, #156]	; 0x9c
    1514:	e0677003 	rsb	r7, r7, r3
    1518:	e5867000 	str	r7, [r6]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:621
    151c:	e5940050 	ldr	r0, [r4, #80]	; 0x50
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:626
    1520:	e28dd00c 	add	sp, sp, #12
    1524:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:523
    1528:	e3570000 	cmp	r7, #0
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:625
    152c:	03e00000 	mvneq	r0, #0
nlmsg_trim():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:523
    1530:	0afffffa 	beq	1520 <tca_get_fill.constprop.22+0xc4>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:524
    1534:	e59410a8 	ldr	r1, [r4, #168]	; 0xa8
    1538:	e1a00004 	mov	r0, r4
    153c:	e0611007 	rsb	r1, r1, r7
    1540:	ebfffffe 	bl	0 <skb_trim>
tca_get_fill():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:625
    1544:	e3e00000 	mvn	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:626
    1548:	e28dd00c 	add	sp, sp, #12
    154c:	e8bd83f0 	pop	{r4, r5, r6, r7, r8, r9, pc}

00001550 <tca_action_gd>:
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:820
    1550:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
    1554:	e24dd0cc 	sub	sp, sp, #204	; 0xcc
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
    1558:	e1d1c0b0 	ldrh	ip, [r1]
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:824
    155c:	e28d5024 	add	r5, sp, #36	; 0x24
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:820
    1560:	e58d001c 	str	r0, [sp, #28]
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
    1564:	e28d0044 	add	r0, sp, #68	; 0x44
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:820
    1568:	e58d2014 	str	r2, [sp, #20]
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
    156c:	e2812004 	add	r2, r1, #4
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:820
    1570:	e58d3018 	str	r3, [sp, #24]
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
    1574:	e3a01020 	mov	r1, #32
    1578:	e24c3004 	sub	r3, ip, #4
    157c:	e3a0c000 	mov	ip, #0
    1580:	e58dc000 	str	ip, [sp]
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:824
    1584:	e58d5024 	str	r5, [sp, #36]	; 0x24
    1588:	e58d5028 	str	r5, [sp, #40]	; 0x28
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
    158c:	ebfffffe 	bl	0 <nla_parse>
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:827
    1590:	e3500000 	cmp	r0, #0
    1594:	ba000056 	blt	16f4 <tca_action_gd+0x1a4>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:830
    1598:	e59dc0f0 	ldr	ip, [sp, #240]	; 0xf0
    159c:	e35c0031 	cmp	ip, #49	; 0x31
    15a0:	0a000045 	beq	16bc <tca_action_gd+0x16c>
kmalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:453 
(discriminator 2)
    15a4:	e3007000 	movw	r7, #0
    15a8:	e28d4044 	add	r4, sp, #68	; 0x44
tcf_action_get_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:685 
(discriminator 2)
    15ac:	e3a0b001 	mov	fp, #1
kzalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:453 
(discriminator 2)
    15b0:	e3407000 	movt	r7, #0
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736 
(discriminator 2)
    15b4:	e3a06000 	mov	r6, #0
    15b8:	ea00000e 	b	15f8 <tca_action_gd+0xa8>
tcf_action_get_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:658
    15bc:	e3e08015 	mvn	r8, #21
    15c0:	e1a0a008 	mov	sl, r8
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:685
    15c4:	e1a0000a 	mov	r0, sl
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:839
    15c8:	e3780a01 	cmn	r8, #4096	; 0x1000
    15cc:	8a000098 	bhi	1834 <tca_action_gd+0x2e4>
list_add_tail():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:76
    15d0:	e59d3028 	ldr	r3, [sp, #40]	; 0x28
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:844
    15d4:	e2802010 	add	r2, r0, #16
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:843
    15d8:	e580b00c 	str	fp, [r0, #12]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:837
    15dc:	e28bb001 	add	fp, fp, #1
    15e0:	e35b0021 	cmp	fp, #33	; 0x21
__list_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:42
    15e4:	e5805010 	str	r5, [r0, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:41
    15e8:	e58d2028 	str	r2, [sp, #40]	; 0x28
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:43
    15ec:	e5803014 	str	r3, [r0, #20]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:44
    15f0:	e5832000 	str	r2, [r3]
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:837
    15f4:	0a000040 	beq	16fc <tca_action_gd+0x1ac>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:837 
(discriminator 2)
    15f8:	e5b42004 	ldr	r2, [r4, #4]!
    15fc:	e3520000 	cmp	r2, #0
    1600:	0a00003d 	beq	16fc <tca_action_gd+0x1ac>
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
    1604:	e1d230b0 	ldrh	r3, [r2]
nla_parse_nested():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:736
    1608:	e28d002c 	add	r0, sp, #44	; 0x2c
    160c:	e2822004 	add	r2, r2, #4
    1610:	e58d6000 	str	r6, [sp]
    1614:	e2433004 	sub	r3, r3, #4
    1618:	e3a01005 	mov	r1, #5
    161c:	ebfffffe 	bl	0 <nla_parse>
tcf_action_get_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:654
    1620:	e3500000 	cmp	r0, #0
    1624:	b1a0a000 	movlt	sl, r0
    1628:	b1a0800a 	movlt	r8, sl
    162c:	baffffe4 	blt	15c4 <tca_action_gd+0x74>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:658
    1630:	e59d3038 	ldr	r3, [sp, #56]	; 0x38
    1634:	e3530000 	cmp	r3, #0
    1638:	0affffdf 	beq	15bc <tca_action_gd+0x6c>
nla_len():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:679
    163c:	e1d320b0 	ldrh	r2, [r3]
    1640:	e2422004 	sub	r2, r2, #4
tcf_action_get_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:658
    1644:	e3520003 	cmp	r2, #3
    1648:	9affffdb 	bls	15bc <tca_action_gd+0x6c>
kmem_cache_alloc_trace():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:341
    164c:	e5970018 	ldr	r0, [r7, #24]
    1650:	e30810d0 	movw	r1, #32976	; 0x80d0
nla_get_u32():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:967
    1654:	e5938004 	ldr	r8, [r3, #4]
kzalloc():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/slab.h:341
    1658:	ebfffffe 	bl	0 <kmem_cache_alloc>
tcf_action_get_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:665
    165c:	e2509000 	subs	r9, r0, #0
    1660:	0a000050 	beq	17a8 <tca_action_gd+0x258>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:668
    1664:	e2892010 	add	r2, r9, #16
INIT_LIST_HEAD():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:26
    1668:	e5892010 	str	r2, [r9, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/list.h:27
    166c:	e5892014 	str	r2, [r9, #20]
tcf_action_get_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:670
    1670:	e59d0030 	ldr	r0, [sp, #48]	; 0x30
    1674:	ebfffbaa 	bl	524 <tc_lookup_action>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:671
    1678:	e3500000 	cmp	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:670
    167c:	e5890004 	str	r0, [r9, #4]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:671
    1680:	0a000051 	beq	17cc <tca_action_gd+0x27c>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:674
    1684:	e5902030 	ldr	r2, [r0, #48]	; 0x30
    1688:	e1a01008 	mov	r1, r8
    168c:	e1a00009 	mov	r0, r9
    1690:	e12fff32 	blx	r2
    1694:	e3500000 	cmp	r0, #0
    1698:	1a000045 	bne	17b4 <tca_action_gd+0x264>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:681
    169c:	e5991004 	ldr	r1, [r9, #4]
    16a0:	e3e08001 	mvn	r8, #1
    16a4:	e1a0a008 	mov	sl, r8
    16a8:	e5910020 	ldr	r0, [r1, #32]
    16ac:	ebfffffe 	bl	0 <module_put>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:683
    16b0:	e1a00009 	mov	r0, r9
    16b4:	ebfffffe 	bl	0 <kfree>
    16b8:	eaffffc1 	b	15c4 <tca_action_gd+0x74>
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:830 
(discriminator 1)
    16bc:	e59dc014 	ldr	ip, [sp, #20]
    16c0:	e1dc30b6 	ldrh	r3, [ip, #6]
    16c4:	e3130c01 	tst	r3, #256	; 0x100
    16c8:	0affffb5 	beq	15a4 <tca_action_gd+0x54>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:831
    16cc:	e59d1048 	ldr	r1, [sp, #72]	; 0x48
    16d0:	e3510000 	cmp	r1, #0
    16d4:	0a000061 	beq	1860 <tca_action_gd+0x310>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:832
    16d8:	e59dc018 	ldr	ip, [sp, #24]
    16dc:	e59d001c 	ldr	r0, [sp, #28]
    16e0:	e58dc000 	str	ip, [sp]
    16e4:	e59dc014 	ldr	ip, [sp, #20]
    16e8:	e28c2006 	add	r2, ip, #6
    16ec:	e28c3008 	add	r3, ip, #8
    16f0:	ebfffcbf 	bl	9f4 <tca_action_flush.isra.16>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:858
    16f4:	e28dd0cc 	add	sp, sp, #204	; 0xcc
    16f8:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:847
    16fc:	e59dc0f0 	ldr	ip, [sp, #240]	; 0xf0
    1700:	e35c0032 	cmp	ip, #50	; 0x32
    1704:	0a000033 	beq	17d8 <tca_action_gd+0x288>
alloc_skb():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:668
    1708:	e3a00d3d 	mov	r0, #3904	; 0xf40
    170c:	e3a010d0 	mov	r1, #208	; 0xd0
    1710:	e3a02000 	mov	r2, #0
    1714:	e3e03000 	mvn	r3, #0
    1718:	ebfffffe 	bl	0 <__alloc_skb>
tcf_del_notify():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:798
    171c:	e2506000 	subs	r6, r0, #0
    1720:	0a000048 	beq	1848 <tca_action_gd+0x2f8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:801
    1724:	e59dc014 	ldr	ip, [sp, #20]
    1728:	e3a04000 	mov	r4, #0
    172c:	e3a02031 	mov	r2, #49	; 0x31
    1730:	e1a01005 	mov	r1, r5
    1734:	e59c3008 	ldr	r3, [ip, #8]
    1738:	e58d2004 	str	r2, [sp, #4]
    173c:	e3a02001 	mov	r2, #1
    1740:	e58d4000 	str	r4, [sp]
    1744:	e58d2008 	str	r2, [sp, #8]
    1748:	e59d2018 	ldr	r2, [sp, #24]
    174c:	ebffff42 	bl	145c <tca_get_fill.constprop.22>
    1750:	e1500004 	cmp	r0, r4
    1754:	da00003d 	ble	1850 <tca_action_gd+0x300>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:808
    1758:	e1a00005 	mov	r0, r5
    175c:	e1a01004 	mov	r1, r4
    1760:	ebfffffe 	bl	bf8 <tcf_action_destroy>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:810
    1764:	e59dc014 	ldr	ip, [sp, #20]
    1768:	e1a00006 	mov	r0, r6
    176c:	e59d101c 	ldr	r1, [sp, #28]
    1770:	e59d2018 	ldr	r2, [sp, #24]
    1774:	e1dc30b6 	ldrh	r3, [ip, #6]
    1778:	e2033008 	and	r3, r3, #8
    177c:	e58d3000 	str	r3, [sp]
    1780:	e3a03004 	mov	r3, #4
    1784:	ebfffffe 	bl	0 <rtnetlink_send>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:812
    1788:	e2506000 	subs	r6, r0, #0
    178c:	a1a00004 	movge	r0, r4
    1790:	aaffffd7 	bge	16f4 <tca_action_gd+0x1a4>
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:856
    1794:	e1a00005 	mov	r0, r5
    1798:	ebfffa65 	bl	134 <cleanup_a>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:857
    179c:	e1a00006 	mov	r0, r6
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:858
    17a0:	e28dd0cc 	add	sp, sp, #204	; 0xcc
    17a4:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
tcf_action_get_1():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:665
    17a8:	e3e0800b 	mvn	r8, #11
    17ac:	e1a0a008 	mov	sl, r8
    17b0:	eaffff83 	b	15c4 <tca_action_gd+0x74>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:677
    17b4:	e5992004 	ldr	r2, [r9, #4]
    17b8:	e1a08009 	mov	r8, r9
    17bc:	e5920020 	ldr	r0, [r2, #32]
    17c0:	ebfffffe 	bl	0 <module_put>
    17c4:	e1a00009 	mov	r0, r9
    17c8:	eaffff7e 	b	15c8 <tca_action_gd+0x78>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:671
    17cc:	e3e08015 	mvn	r8, #21
    17d0:	e1a0a008 	mov	sl, r8
    17d4:	eaffffb5 	b	16b0 <tca_action_gd+0x160>
alloc_skb():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:668
    17d8:	e3a00d3d 	mov	r0, #3904	; 0xf40
    17dc:	e3a010d0 	mov	r1, #208	; 0xd0
    17e0:	e3a02000 	mov	r2, #0
    17e4:	e3e03000 	mvn	r3, #0
    17e8:	ebfffffe 	bl	0 <__alloc_skb>
act_get_notify():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:635
    17ec:	e2504000 	subs	r4, r0, #0
    17f0:	0a000014 	beq	1848 <tca_action_gd+0x2f8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:637
    17f4:	e59dc014 	ldr	ip, [sp, #20]
    17f8:	e1a01005 	mov	r1, r5
    17fc:	e59d20f0 	ldr	r2, [sp, #240]	; 0xf0
    1800:	e59c3008 	ldr	r3, [ip, #8]
    1804:	e3a0c000 	mov	ip, #0
    1808:	e58d2004 	str	r2, [sp, #4]
    180c:	e58dc000 	str	ip, [sp]
    1810:	e59d2018 	ldr	r2, [sp, #24]
    1814:	e58dc008 	str	ip, [sp, #8]
    1818:	ebffff0f 	bl	145c <tca_get_fill.constprop.22>
    181c:	e3500000 	cmp	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:638
    1820:	e1a00004 	mov	r0, r4
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:637
    1824:	da00000a 	ble	1854 <tca_action_gd+0x304>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:642
    1828:	e59d101c 	ldr	r1, [sp, #28]
    182c:	e59d2018 	ldr	r2, [sp, #24]
    1830:	ebfffffe 	bl	0 <rtnl_unicast>
    1834:	e1a06000 	mov	r6, r0
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:856
    1838:	e1a00005 	mov	r0, r5
    183c:	ebfffa3c 	bl	134 <cleanup_a>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:857
    1840:	e1a00006 	mov	r0, r6
    1844:	eaffffd5 	b	17a0 <tca_action_gd+0x250>
tcf_del_notify():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:799
    1848:	e3e06068 	mvn	r6, #104	; 0x68
    184c:	eaffffd0 	b	1794 <tca_action_gd+0x244>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:803
    1850:	e1a00006 	mov	r0, r6
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:804
    1854:	e3e06015 	mvn	r6, #21
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:803
    1858:	ebfffffe 	bl	0 <kfree_skb>
    185c:	eaffffcc 	b	1794 <tca_action_gd+0x244>
tca_action_gd():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:834
    1860:	e3e00015 	mvn	r0, #21
    1864:	eaffffa2 	b	16f4 <tca_action_gd+0x1a4>

00001868 <tc_ctl_action>:
tc_ctl_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:905
    1868:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:908
    186c:	e3500000 	cmp	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/sock.h:2242
    1870:	e5903010 	ldr	r3, [r0, #16]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:905
    1874:	e24dd034 	sub	sp, sp, #52	; 0x34
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:908
    1878:	15908024 	ldrne	r8, [r0, #36]	; 0x24
    187c:	01a08000 	moveq	r8, r0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:905
    1880:	e1a05001 	mov	r5, r1
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/sock.h:2242
    1884:	e5937024 	ldr	r7, [r3, #36]	; 0x24
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:911
    1888:	e1d130b4 	ldrh	r3, [r1, #4]
    188c:	e3530032 	cmp	r3, #50	; 0x32
    1890:	0a000004 	beq	18a8 <tc_ctl_action+0x40>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:911 
(discriminator 1)
    1894:	e3a0000c 	mov	r0, #12
    1898:	ebfffffe 	bl	0 <capable>
    189c:	e3500000 	cmp	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:912 
(discriminator 1)
    18a0:	03e00000 	mvneq	r0, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:911 
(discriminator 1)
    18a4:	0a000003 	beq	18b8 <tc_ctl_action+0x50>
nlmsg_parse():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:369
    18a8:	e5953000 	ldr	r3, [r5]
    18ac:	e3530013 	cmp	r3, #19
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:370
    18b0:	93e00015 	mvnls	r0, #21
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:369
    18b4:	8a000001 	bhi	18c0 <tc_ctl_action+0x58>
tc_ctl_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:952
    18b8:	e28dd034 	add	sp, sp, #52	; 0x34
    18bc:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
nlmsg_parse():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/net/netlink.h:372
    18c0:	e2433014 	sub	r3, r3, #20
    18c4:	e3a0a000 	mov	sl, #0
    18c8:	e28d0018 	add	r0, sp, #24
    18cc:	e58da000 	str	sl, [sp]
    18d0:	e3a01005 	mov	r1, #5
    18d4:	e2852014 	add	r2, r5, #20
    18d8:	ebfffffe 	bl	0 <nla_parse>
tc_ctl_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:915
    18dc:	e3500000 	cmp	r0, #0
    18e0:	bafffff4 	blt	18b8 <tc_ctl_action+0x50>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:918
    18e4:	e59d101c 	ldr	r1, [sp, #28]
    18e8:	e151000a 	cmp	r1, sl
    18ec:	0a000047 	beq	1a10 <tc_ctl_action+0x1a8>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:924
    18f0:	e1d5b0b4 	ldrh	fp, [r5, #4]
    18f4:	e35b0031 	cmp	fp, #49	; 0x31
    18f8:	0a000004 	beq	1910 <tc_ctl_action+0xa8>
    18fc:	e35b0032 	cmp	fp, #50	; 0x32
    1900:	0a000002 	beq	1910 <tc_ctl_action+0xa8>
    1904:	e35b0030 	cmp	fp, #48	; 0x30
    1908:	0a000007 	beq	192c <tc_ctl_action+0xc4>
    190c:	e7f001f2 	.word	0xe7f001f2
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:944
    1910:	e58db000 	str	fp, [sp]
    1914:	e1a00007 	mov	r0, r7
    1918:	e1a02005 	mov	r2, r5
    191c:	e1a03008 	mov	r3, r8
    1920:	ebffff0a 	bl	1550 <tca_action_gd>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:952
    1924:	e28dd034 	add	sp, sp, #52	; 0x34
    1928:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:932
    192c:	e1d590b6 	ldrh	r9, [r5, #6]
    1930:	e28d4010 	add	r4, sp, #16
    1934:	e7e09459 	ubfx	r9, r9, #8, #1
    1938:	ea000002 	b	1948 <tc_ctl_action+0xe0>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:936
    193c:	e376000b 	cmn	r6, #11
    1940:	1a000029 	bne	19ec <tc_ctl_action+0x184>
    1944:	e59d101c 	ldr	r1, [sp, #28]
tcf_action_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:891 
(discriminator 1)
    1948:	e3a02000 	mov	r2, #0
    194c:	e88d0600 	stm	sp, {r9, sl}
    1950:	e58d4008 	str	r4, [sp, #8]
    1954:	e1a03002 	mov	r3, r2
    1958:	e1a00007 	mov	r0, r7
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:889 
(discriminator 1)
    195c:	e58d4010 	str	r4, [sp, #16]
    1960:	e58d4014 	str	r4, [sp, #20]
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:891 
(discriminator 1)
    1964:	ebfffffe 	bl	e68 <tcf_action_init>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:892 
(discriminator 1)
    1968:	e2506000 	subs	r6, r0, #0
    196c:	1afffff2 	bne	193c <tc_ctl_action+0xd4>
alloc_skb():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/include/linux/skbuff.h:668
    1970:	e3a00d3d 	mov	r0, #3904	; 0xf40
    1974:	e3a010d0 	mov	r1, #208	; 0xd0
    1978:	e1a02006 	mov	r2, r6
    197c:	e3e03000 	mvn	r3, #0
    1980:	ebfffffe 	bl	0 <__alloc_skb>
tcf_add_notify():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:868
    1984:	e250b000 	subs	fp, r0, #0
    1988:	0a00001a 	beq	19f8 <tc_ctl_action+0x190>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:871
    198c:	e1d5e0b6 	ldrh	lr, [r5, #6]
    1990:	e3a0c030 	mov	ip, #48	; 0x30
    1994:	e5953008 	ldr	r3, [r5, #8]
    1998:	e1a01004 	mov	r1, r4
    199c:	e1a02008 	mov	r2, r8
    19a0:	e58dc004 	str	ip, [sp, #4]
    19a4:	e58d6008 	str	r6, [sp, #8]
    19a8:	e58de000 	str	lr, [sp]
    19ac:	ebfffeaa 	bl	145c <tca_get_fill.constprop.22>
    19b0:	e3500000 	cmp	r0, #0
    19b4:	da000011 	ble	1a00 <tc_ctl_action+0x198>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:877
    19b8:	e1d530b6 	ldrh	r3, [r5, #6]
    19bc:	e1a0000b 	mov	r0, fp
    19c0:	e1a01007 	mov	r1, r7
    19c4:	e1a02008 	mov	r2, r8
    19c8:	e203c008 	and	ip, r3, #8
    19cc:	e3a03004 	mov	r3, #4
    19d0:	e58dc000 	str	ip, [sp]
    19d4:	ebfffffe 	bl	0 <rtnetlink_send>
    19d8:	e0006fc0 	and	r6, r0, r0, asr #31
tcf_action_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:899
    19dc:	e1a00004 	mov	r0, r4
    19e0:	ebfff9d3 	bl	134 <cleanup_a>
tc_ctl_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:936
    19e4:	e376000b 	cmn	r6, #11
    19e8:	0affffd5 	beq	1944 <tc_ctl_action+0xdc>
    19ec:	e1a00006 	mov	r0, r6
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:952
    19f0:	e28dd034 	add	sp, sp, #52	; 0x34
    19f4:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}
tcf_action_add():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:869
    19f8:	e3e06068 	mvn	r6, #104	; 0x68
    19fc:	eafffff6 	b	19dc <tc_ctl_action+0x174>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:873
    1a00:	e1a0000b 	mov	r0, fp
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:874
    1a04:	e3e06015 	mvn	r6, #21
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:873
    1a08:	ebfffffe 	bl	0 <kfree_skb>
    1a0c:	eafffff2 	b	19dc <tc_ctl_action+0x174>
tc_ctl_action():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:919
    1a10:	e3000000 	movw	r0, #0
    1a14:	e3400000 	movt	r0, #0
    1a18:	ebfffffe 	bl	0 <printk>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:920
    1a1c:	e3e00015 	mvn	r0, #21
    1a20:	eaffffa4 	b	18b8 <tc_ctl_action+0x50>

Disassembly of section .init.text:

00000000 <tc_action_init>:
tc_action_init():
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1042
   0:	e92d4030 	push	{r4, r5, lr}
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1043
   4:	e3005000 	movw	r5, #0
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1042
   8:	e24dd00c 	sub	sp, sp, #12
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1043
   c:	e3405000 	movt	r5, #0
  10:	e3a04000 	mov	r4, #0
  14:	e3a01030 	mov	r1, #48	; 0x30
  18:	e1a02005 	mov	r2, r5
  1c:	e1a00004 	mov	r0, r4
  20:	e1a03004 	mov	r3, r4
  24:	e58d4000 	str	r4, [sp]
  28:	ebfffffe 	bl	0 <rtnl_register>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1044
  2c:	e1a02005 	mov	r2, r5
  30:	e1a00004 	mov	r0, r4
  34:	e1a03004 	mov	r3, r4
  38:	e58d4000 	str	r4, [sp]
  3c:	e3a01031 	mov	r1, #49	; 0x31
  40:	ebfffffe 	bl	0 <rtnl_register>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1045
  44:	e1a00004 	mov	r0, r4
  48:	e1a02005 	mov	r2, r5
  4c:	e58d4000 	str	r4, [sp]
  50:	e3a01032 	mov	r1, #50	; 0x32
  54:	e3003000 	movw	r3, #0
  58:	e3403000 	movt	r3, #0
  5c:	ebfffffe 	bl	0 <rtnl_register>
/home/kelly/source/src/Kernel/linux-3.14.0-plug/net/sched/act_api.c:1049
  60:	e1a00004 	mov	r0, r4
  64:	e28dd00c 	add	sp, sp, #12
  68:	e8bd8030 	pop	{r4, r5, pc}

