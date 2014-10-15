Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaJOMVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:21:08 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63116 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:21:06 -0400
Date: Wed, 15 Oct 2014 14:21:02 +0200
From: Paolo Pisati <p.pisati@gmail.com>
To: Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
        Laura Abbott <lauraa@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: arm: JUMP_LABEL and DEBUG_SET_MODULE_RONX should be mutually
 exclusive?
Message-ID: <20141015122102.GB4427@stinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i keep hitting this with BRIDGE=m, JUMP_LABEL=y and DEBUG_SET_MODULE_RONX=y:

[   48.419401] Unable to handle kernel paging request at virtual address bf076f58
[   48.426630] pgd = e4e54000
[   48.429328] [bf076f58] *pgd=24d49811, *pte=249e94df, *ppte=249e965e
[   48.435603] Internal error: Oops: 80f [#1] SMP ARM
[   48.440383] Modules linked in: bridge(+) stp llc ipv6
[   48.445442] CPU: 1 PID: 911 Comm: modprobe Not tainted 3.17.0 #37
[   48.451525] task: e8da9b00 ti: e4a22000 task.ti: e4a22000
[   48.456918] PC is at patch_text+0x4/0x10
[   48.460833] LR is at __jump_label_update+0x64/0x6c
[   48.465615] pc : [<c0215448>]    lr : [<c02b6008>]    psr: 80000013
[   48.465615] sp : e4a23db8  ip : 000141b2  fp : bf07e7dc
[   48.477079] r10: 00000000  r9 : e4a22030  r8 : 00000000
[   48.482293] r7 : 00000001  r6 : c0d1c5a8  r5 : bf07e794  r4 : bf07e6f8
[   48.488809] r3 : bf076f58  r2 : ea000000  r1 : ea000007  r0 : bf076f58
[   48.495326] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   48.502450] Control: 10c5387d  Table: 24e5406a  DAC: 00000015
[   48.508185] Process modprobe (pid: 911, stack limit = 0xe4a22250)
[   48.514267] Stack: (0xe4a23db8 to 0xe4a24000)
[   48.518614] 3da0:                                                       00000001 e4d6f740
[   48.526780] 3dc0: c0d1c5a8 00000001 00000000 c02b605c c0d1c5a8 00000000 e4d3e580 00000007
[   48.534947] 3de0: bf07e5fc c02b6158 bf07e5fc c07cef04 bf07e61c c07cefdc bf07e8fc c0bfd960
[   48.543113] 3e00: e4d3e580 bf07e794 bf084000 bf084190 bf07e8fc c07a81e8 00000000 00000000
[   48.551279] 3e20: c0bfd960 bf084050 c0bfd960 c0208c90 e8dee9c0 e4961f40 e8e93000 c0a3d75c
[   48.559446] 3e40: c0bfd844 eb7ccf20 00000000 8040003f 80000000 e97e9000 00000001 e4d3ea40
[   48.567612] 3e60: bf07e7dc c02bf0e4 c0d07448 8040003f bf07e7dc 0000001e 0000001e e4961f40
[   48.575778] 3e80: f0a6d000 e4a23f58 00000001 bf07e7a0 bf07e794 e4d3ea00 00000001 e4d3ea40
[   48.583944] 3ea0: bf07e7dc c02a5108 bf07e7a0 00007fff c02a213c c02fafc0 0001d23e 00000000
[   48.592110] 3ec0: f0a6d000 00000000 bf07e7a0 e4d3ea08 e4a22028 e4a23ef4 e4a22030 000003b8
[   48.600277] 3ee0: 00181414 00000000 00800002 000081a4 00000001 bf07c024 00000001 bf07c02c
[   48.608443] 3f00: 00000003 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   48.616609] 3f20: 00000000 00000000 00000000 00000000 e8dee0c0 00000000 00000000 b6fc2398
[   48.624776] 3f40: 0000017b c020e624 e4a22000 00000000 b6fd61a8 c02a56c4 f0a6d000 0001d23e
[   48.632942] 3f60: f0a7df38 f0a7dce5 f0a87280 00011000 00012770 00000000 00000000 00000000
[   48.641108] 3f80: 00000036 00000037 0000002d 00000000 0000001b 00000000 b6fc3608 b6fc3e18
[   48.649274] 3fa0: b6fc3990 c020e4a0 b6fc3608 b6fc3e18 00000000 b6fc2398 00000000 b6fc3968
[   48.657440] 3fc0: b6fc3608 b6fc3e18 b6fc3990 0000017b b6fd6278 00000000 00000000 b6fd61a8
[   48.665607] 3fe0: bee78a38 bee78a28 b6fb9177 b6f2c2b2 40010030 00000000 2b7de821 2b7dec21
[   48.673779] [<c0215448>] (patch_text) from [<c02b6008>] (__jump_label_update+0x64/0x6c)
[   48.681775] [<c02b6008>] (__jump_label_update) from [<c02b605c>] (jump_label_update+0x4c/0x90)
[   48.690378] [<c02b605c>] (jump_label_update) from [<c02b6158>] (static_key_slow_inc+0xb8/0xe0)
[   48.698981] [<c02b6158>] (static_key_slow_inc) from [<c07cef04>] (nf_register_hook+0xb4/0xc0)
[   48.707497] [<c07cef04>] (nf_register_hook) from [<c07cefdc>] (nf_register_hooks+0x34/0x74)
[   48.715848] [<c07cefdc>] (nf_register_hooks) from [<bf084190>] (br_netfilter_init+0x38/0xea8 [bridge])
[   48.725160] [<bf084190>] (br_netfilter_init [bridge]) from [<bf084050>] (br_init+0x50/0xbc [bridge])
[   48.734292] [<bf084050>] (br_init [bridge]) from [<c0208c90>] (do_one_initcall+0x8c/0x1c4)
[   48.742548] [<c0208c90>] (do_one_initcall) from [<c02a5108>] (load_module+0x1b24/0x1f88)
[   48.750629] [<c02a5108>] (load_module) from [<c02a56c4>] (SyS_finit_module+0x68/0x78)
[   48.758451] [<c02a56c4>] (SyS_finit_module) from [<c020e4a0>] (ret_fast_syscall+0x0/0x30)
[   48.766618] Code: e4831004 e1a01003 ea0025d3 e1a03000 (e4831004) 
[   48.772720] ---[ end trace 5a993d4461f1ebf2 ]---

i found a conversion from April 2014 outlining the same problem, but the situation hasn't changed (the above oops 
comes from a 3.17 kernel):

http://comments.gmane.org/gmane.linux.kernel/1675790

shouldn't JUMP_LABEL and DEBUG_SET_MODULE_RONX be mutually exclusive, at least on arm?
or was DEBUG_SET_MODULE_RONX superseded by something more fine grained that i
can use to circumvent this problem?
-- 
bye,
p.
