Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaCFVMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:12:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42700 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaCFVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:12:33 -0500
Message-ID: <5318E4BC.50301@oracle.com>
Date: Thu, 06 Mar 2014 16:12:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: mm: kernel BUG at mm/mprotect.c:149
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've hit the
following spew. This seems to be introduced by your patch "mm,numa: reorganize change_pmd_range()".

[  886.745765] kernel BUG at mm/mprotect.c:149!
[  886.746831] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  886.748511] Dumping ftrace buffer:
[  886.749998]    (ftrace buffer empty)
[  886.750110] Modules linked in:
[  886.751396] CPU: 20 PID: 26219 Comm: trinity-c216 Tainted: G        W    3.14.0-rc5-next-20140305-sasha-00011-ge06f5f3-dirty #105
[  886.751396] task: ffff8800b6c80000 ti: ffff880228436000 task.ti: ffff880228436000
[  886.751396] RIP: 0010:[<ffffffff812aab33>]  [<ffffffff812aab33>] change_protection_range+0x3b3/0x500
[  886.751396] RSP: 0000:ffff880228437da8  EFLAGS: 00010282
[  886.751396] RAX: 8000000527c008e5 RBX: 00007f647916e000 RCX: 0000000000000000
[  886.751396] RDX: ffff8802ef488e40 RSI: 00007f6479000000 RDI: 8000000527c008e5
[  886.751396] RBP: ffff880228437e78 R08: 0000000000000000 R09: 0000000000000000
[  886.751396] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8802ef488e40
[  886.751396] R13: 00007f6479000000 R14: 00007f647916e000 R15: 00007f646e34e000
[  886.751396] FS:  00007f64b28d4700(0000) GS:ffff88052ba00000(0000) knlGS:0000000000000000
[  886.751396] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  886.751396] CR2: 00007f64aed83af8 CR3: 0000000206e52000 CR4: 00000000000006a0
[  886.751396] Stack:
[  886.751396]  ffff880200000001 ffffffff8447f152 ffff880228437dd8 ffff880228af3000
[  886.769142]  00007f646e34e000 00007f647916dfff 0000000000000000 00007f647916e000
[  886.769142]  ffff880206e527f0 00007f647916dfff 0000000000000000 0000000000000000
[  886.769142] Call Trace:
[  886.769142]  [<ffffffff8447f152>] ? preempt_count_sub+0xe2/0x120
[  886.769142]  [<ffffffff812aaca5>] change_protection+0x25/0x30
[  886.769142]  [<ffffffff812c3eeb>] change_prot_numa+0x1b/0x30
[  886.769142]  [<ffffffff8118df49>] task_numa_work+0x279/0x360
[  886.769142]  [<ffffffff8116c57e>] task_work_run+0xae/0xf0
[  886.769142]  [<ffffffff8106ffbe>] do_notify_resume+0x8e/0xe0
[  886.769142]  [<ffffffff8447a93b>] retint_signal+0x4d/0x92
[  886.769142] Code: 49 8b 3c 24 48 83 3d fc 2e ba 04 00 75 12 0f 0b 0f 1f 84 00 00 00 00 00 eb fe 66 0f 1f 44 00 00 48 89 f8 66 66 66 90 84 c0 79 0d <0f> 0b 0f 1f 00 eb fe 66 0f 1f 44 00 00 8b 4d 9c 44 8b 4d 98 89
[  886.769142] RIP  [<ffffffff812aab33>] change_protection_range+0x3b3/0x500
[  886.769142]  RSP <ffff880228437da8>


Thanks,
Sasha
