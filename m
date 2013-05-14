Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3ENMGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:06:15 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65247 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3ENMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:06:14 -0400
X-Nat-Received: from [202.181.97.72]:57766 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368533170.18178
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [3.10-rc1 SLUB?] kmemcheck reports read from freed/unallocated memory
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201305142106.AAG35418.JOSFOLFMHOFVQt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 14 May 2013 21:06:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14052013 #9976473, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below warning. The problem might be in SLUB code.

  WARNING: kmemcheck: Caught 64-bit read from freed memory (ffff88007a1297a0)
  6098127a0088ffff0000000001000000c0c6fe790088ffff0800000000000000
   f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f
   ^
  RIP: 0010:[<ffffffff8113e023>]  [<ffffffff8113e023>] __kmalloc+0xb3/0x1a0
  RSP: 0018:ffff880079a17be8  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 0000000000000010 RCX: ffff88007b9d5580
  RDX: 0000000000000427 RSI: ffffffff81c23600 RDI: 00000000001d5580
  RBP: ffff880079a17c18 R08: ffff880079a16000 R09: 0000000000000001
  R10: 0000000000000000 R11: 0000000000000004 R12: ffff88007ac03c80
  R13: 00000000000000d0 R14: ffff88007a1297a0 R15: ffffffff8119a5bd
  FS:  00007f1b62687700(0000) GS:ffff88007b200000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff88007a6346c8 CR3: 0000000073cc0000 CR4: 00000000000407f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
   [<ffffffff8119a5bd>] load_elf_binary+0x29d/0xe70
   [<ffffffff8114dd9f>] search_binary_handler+0x1af/0x400
   [<ffffffff811989fc>] load_script+0x24c/0x290
   [<ffffffff8114dd9f>] search_binary_handler+0x1af/0x400
   [<ffffffff8114fd16>] do_execve_common+0x2a6/0x370
   [<ffffffff8114fde9>] do_execve+0x9/0x10
   [<ffffffff8114fe28>] SyS_execve+0x38/0x60
   [<ffffffff817a7b09>] stub_execve+0x69/0xa0
   [<ffffffffffffffff>] 0xffffffffffffffff

Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-3.10-rc1-kmemcheck
Full dmesg is at http://I-love.SAKURA.ne.jp/tmp/dmesg-3.10-rc1-kmemcheck.txt

Regards.
