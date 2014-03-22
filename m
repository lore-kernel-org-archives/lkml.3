Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaCVAlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:41:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37094 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaCVAlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:41:08 -0400
Message-ID: <532CDC1F.1030103@oracle.com>
Date: Fri, 21 Mar 2014 20:41:03 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: reiserfs-devel@vger.kernel.org
CC: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: reiserfs: kernel BUG at fs/reiserfs/journal.c:1095!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following:

[  825.014684] kernel BUG at fs/reiserfs/journal.c:1095!
[  825.014783] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  825.014783] Dumping ftrace buffer:
[  825.014783]    (ftrace buffer empty)
[  825.014783] Modules linked in:
[  825.014783] CPU: 1 PID: 22304 Comm: trinity-c57 Tainted: G        W     3.14.0-rc7-next-20140321-sasha-00018-g0516fe6-dirty #265
[  825.014783] task: ffff8802ec7bb000 ti: ffff8802e3bb8000 task.ti: ffff8802e3bb8000
[  825.014783] RIP:  flush_commit_list (fs/reiserfs/journal.c:1095)
[  825.014783] RSP: 0018:ffff8802e3bb9d68  EFLAGS: 00010202
[  825.014783] RAX: 0000000000000023 RBX: ffff88003da2b3d8 RCX: 0000000000000006
[  825.014783] RDX: ffffc9000b5d0000 RSI: ffffffff813f413f RDI: ffff88007e12cd80
[  825.014783] RBP: ffff8802e3bb9dd8 R08: 0000000000000000 R09: 0000000000000000
[  825.014783] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000002
[  825.014783] R13: ffff8807a4c537e4 R14: 0000000000000000 R15: ffff8807a4c537c8
[  825.014783] FS:  00007f60da8fe700(0000) GS:ffff88007ec00000(0000) knlGS:0000000000000000
[  825.014783] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  825.014783] CR2: 00007f6557d11489 CR3: 00000002dde16000 CR4: 00000000000006a0
[  825.014783] Stack:
[  825.014783]  ffff8802e3bb9d78 ffffc9000b5d01d8 ffff880200000000 ffff8807a4c537f0
[  825.014783]  000000010b5d01d8 ffffc9000b5d0000 ffff8802e3bb9dd8 ffff88007e12dcb0
[  825.014783]  ffffc9000b5d0000 ffffc9000b5d0000 ffff880078886c48 ffffc9000b5d02f8
[  825.014783] Call Trace:
[  825.014783]  do_journal_end.isra.16 (fs/reiserfs/journal.c:4194)
[  825.014783]  ? SyS_tee (fs/sync.c:77)
[  825.014783]  journal_end_sync (fs/reiserfs/journal.c:3429)
[  825.014783]  reiserfs_sync_fs (fs/reiserfs/super.c:77)
[  825.014783]  ? SyS_tee (fs/sync.c:77)
[  825.014783]  ? iterate_supers (fs/super.c:510)
[  825.014783]  sync_fs_one_sb (fs/sync.c:80)
[  825.014783]  iterate_supers (fs/super.c:512)
[  825.014783]  sys_sync (fs/sync.c:109)
[  825.014783]  tracesys (arch/x86/kernel/entry_64.S:749)
[  825.014783] Code: 82 1f ff ff ff 41 8b 47 1c 83 f8 01 74 06 0f 0b 0f 1f 40 00 45 85 f6 75 5e 48 8b 55 b8 48 8b 42 28 a8 08 0f 84 db 02 00 00 eb 4c <0f> 0b 0f 1f 80 00 00 00 00 e8 1b 78 f5 ff 48 89 df e8 03 7e 00
[  825.014783] RIP  flush_commit_list (fs/reiserfs/journal.c:1095)
[  825.014783]  RSP <ffff8802e3bb9d68>


Thanks,
Sasha
