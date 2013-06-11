Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3FKR0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:26:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab3FKR0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:26:41 -0400
Date: Tue, 11 Jun 2013 13:26:24 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: jussi.kivilinna@iki.fi, herbert@gondor.hengli.com.au
Subject: GPF in aesni_xts_crypt8 (3.10-rc5)
Message-ID: <20130611172624.GA20496@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jussi.kivilinna@iki.fi,
	herbert@gondor.apana.org.au
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just found that 3.10-rc doesn't boot on my laptop with encrypted disk.


general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: xfs libcrc32c dm_crypt crc32c_intel ghash_clmulni_intel aesni_intel glue_helper ablk_helper i915 i2c_algo_bit drm_kms_helper drm i2c_core video
CPU: 1 PID: 53 Comm: kworker/1:1 Not tainted 3.10.0-rc5+ #5 
Hardware name: LENOVO 2356JK8/2356JK8, BIOS G7ET94WW (2.54 ) 04/30/2013
Workqueue: kcryptd kcryptd_crypt [dm_crypt]
task: ffff880135c58000 ti: ffff880135c54000 task.ti: ffff880135c54000
RIP: 0010:[<ffffffffa01433a2>]  [<ffffffffa01433a2>] aesni_xts_crypt8+0x42/0x1e0 [aesni_intel]
RSP: 0018:ffff880135c55b68  EFLAGS: 00010282
RAX: ffffffffa0142eb8 RBX: 0000000000000080 RCX: 00000000000000f0
RDX: ffff8801316eeaa8 RSI: ffff8801316eeaa8 RDI: ffff88012fd84440
RBP: ffff880135c55b70 R08: ffff8801304fe118 R09: 0000000000000020
R10: 00000000000000f0 R11: ffffffffa0142eb8 R12: ffff8801316eeb28
R13: 0000000000000080 R14: ffff8801316eeb28 R15: 0000000000000180
FS:  0000000000000000(0000) GS:ffff880139400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000039e88bc720 CR3: 0000000001c0b000 CR4: 00000000001407e0
Stack:
 ffffffffa0143683 ffff880135c55c40 ffffffffa00602fb ffff880135c55c70
 ffffffffa0146060 0000000001ad0190 ffffffffa0146060 ffffea0004c5bb80
 ffff8801316eeaa8 ffffea0004c5bb80 ffff8801316eeaa8 ffff8801304fe0c0
Call Trace:
 [<ffffffffa0143683>] ? aesni_xts_dec8+0x13/0x20 [aesni_intel]
 [<ffffffffa00602fb>] glue_xts_crypt_128bit+0x10b/0x1c0 [glue_helper]
 [<ffffffffa014358b>] xts_decrypt+0x4b/0x50 [aesni_intel]
 [<ffffffffa000617f>] ablk_decrypt+0x4f/0xd0 [ablk_helper]
 [<ffffffffa0067202>] crypt_convert+0x352/0x3b0 [dm_crypt]
 [<ffffffffa00675b5>] kcryptd_crypt+0x355/0x4e0 [dm_crypt]
 [<ffffffff81061b35>] ? process_one_work+0x1a5/0x700
 [<ffffffff81061ba1>] process_one_work+0x211/0x700
 [<ffffffff81061b35>] ? process_one_work+0x1a5/0x700
 [<ffffffff810621ab>] worker_thread+0x11b/0x3a0
 [<ffffffff81062090>] ? process_one_work+0x700/0x700
 [<ffffffff81069f4d>] kthread+0xed/0x100
 [<ffffffff81069e60>] ? insert_kthread_work+0x80/0x80
 [<ffffffff815fd41c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81069e60>] ? insert_kthread_work+0x80/0x80
Code: 8d 04 25 b8 2e 14 a0 41 0f 44 ca 4c 0f 44 d8 66 44 0f 6f 14 25 00 70 14 a0 41 0f 10 18 44 8b 8f e0 01 00 00 48 01 cf 66 0f 6f c3 <66> 0f ef 02 f3 0f 7f 1e 66 44 0f 70 db 13 66 0f d4 db 66 41 0f 
RIP  [<ffffffffa01433a2>] aesni_xts_crypt8+0x42/0x1e0 [aesni_intel]
 RSP <ffff880135c55b68>

   0:	8d 04 25 b8 2e 14 a0 	lea    0xffffffffa0142eb8,%eax
   7:	41 0f 44 ca          	cmove  %r10d,%ecx
   b:	4c 0f 44 d8          	cmove  %rax,%r11
   f:	66 44 0f 6f 14 25 00 	movdqa 0xffffffffa0147000,%xmm10
  16:	70 14 a0 
  19:	41 0f 10 18          	movups (%r8),%xmm3
  1d:	44 8b 8f e0 01 00 00 	mov    0x1e0(%rdi),%r9d
  24:	48 01 cf             	add    %rcx,%rdi
  27:	66 0f 6f c3          	movdqa %xmm3,%xmm0
  2b:*	66 0f ef 02          	pxor   (%rdx),%xmm0     <-- trapping instruction
  2f:	f3 0f 7f 1e          	movdqu %xmm3,(%rsi)
  33:	66 44 0f 70 db 13    	pshufd $0x13,%xmm3,%xmm11
  39:	66 0f d4 db          	paddq  %xmm3,%xmm3
  3d:	66                   	data16
  3e:	41                   	rex.B
  3f:	

