Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaKKVOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:14:14 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaKKVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:14:12 -0500
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: geert@linux-m68k.org, peterz@infradead.org, hpa@zytor.com, oleg@redhat.com,
        kirill.shutemov@linux.intel.com, prarit@redhat.com,
        michael.opdenacker@free-electrons.com, rusty@rustcorp.com.au,
        fabf@skynet.be, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] Params: Fix parse_args() return code checking
Date: Tue, 11 Nov 2014 22:14:01 +0100
Message-Id: <1415740441-1042-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_args() returns beside of NULL also ERR_PTR().

Fixes:
[    0.000000] BUG: unable to handle kernel paging request at ffffffffffffffea
[    0.000000] IP: [<ffffffff81350a8d>] strnlen+0xd/0x40
[    0.000000] PGD 1e14067 PUD 1e16067 PMD 0
[    0.000000] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc4+ #524
[    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140816_022509-build35 04/01/2014
[    0.000000] task: ffffffff81e184c0 ti: ffffffff81e00000 task.ti: ffffffff81e00000
[    0.000000] RIP: 0010:[<ffffffff81350a8d>]  [<ffffffff81350a8d>] strnlen+0xd/0x40
[    0.000000] RSP: 0000:ffffffff81e03d38  EFLAGS: 00010086
[    0.000000] RAX: ffffffff81c97b93 RBX: ffffffff82f2b20e RCX: fffffffffffffffe
[    0.000000] RDX: ffffffffffffffea RSI: ffffffffffffffff RDI: ffffffffffffffea
[    0.000000] RBP: ffffffff81e03d38 R08: 000000000000ffff R09: 000000000000ffff
[    0.000000] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffffffffea
[    0.000000] R13: ffffffff82f2b5e0 R14: 00000000ffffffff R15: 0000000000000000
[    0.000000] FS:  0000000000000000(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: ffffffffffffffea CR3: 0000000001e13000 CR4: 00000000000000b0
[    0.000000] Stack:
[    0.000000]  ffffffff81e03d78 ffffffff81352daf ffffffff81e3f2b8 ffffffff82f2b20e
[    0.000000]  ffffffff82f2b5e0 ffffffff81e03eb0 ffffffff81c9454e ffffffff81c9454e
[    0.000000]  ffffffff81e03df8 ffffffff81354361 ffffffff81e3f218 ffffffff82f2d95c
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81352daf>] string.isra.7+0x3f/0x100
[    0.000000]  [<ffffffff81354361>] vsnprintf+0x181/0x590
[    0.000000]  [<ffffffff81354781>] vscnprintf+0x11/0x30
[    0.000000]  [<ffffffff8109ac9b>] vprintk_emit+0xab/0x570
[    0.000000]  [<ffffffff818ce419>] ? mutex_unlock+0x9/0x10
[    0.000000]  [<ffffffff818c0f50>] printk+0x48/0x4a
[    0.000000]  [<ffffffff81064c3d>] parse_args+0x3d/0x3d0
[    0.000000]  [<ffffffff818c0f50>] ? printk+0x48/0x4a
[    0.000000]  [<ffffffff820d5d54>] start_kernel+0x1d6/0x40d
[    0.000000]  [<ffffffff820d5918>] ? repair_env_string+0x5c/0x5c
[    0.000000]  [<ffffffff820d5581>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff820d567a>] x86_64_start_kernel+0xf7/0xfb
[    0.000000] Code: c0 01 80 38 00 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83
[    0.000000] RIP  [<ffffffff81350a8d>] strnlen+0xd/0x40
[    0.000000]  RSP <ffffffff81e03d38>
[    0.000000] CR2: ffffffffffffffea
[    0.000000] ---[ end trace 92a634b381315d0c ]---

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 800a0da..321d0ce 100644
--- a/init/main.c
+++ b/init/main.c
@@ -544,7 +544,7 @@ asmlinkage __visible void __init start_kernel(void)
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
 				  -1, -1, &unknown_bootoption);
-	if (after_dashes)
+	if (!IS_ERR_OR_NULL(after_dashes))
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   set_init_arg);
 
-- 
1.8.4.5

