Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaAJFhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 00:37:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaAJFho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 00:37:44 -0500
Date: Fri, 10 Jan 2014 00:37:33 -0500
From: Dave Jones <davej@redhat.com>
To: rds-devel@oss.oracle.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: oops in rds_iw_laddr_check
Message-ID: <20140110053733.GA10856@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, rds-devel@oss.oracle.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 0 PID: 5036 Comm: trinity-main Not tainted 3.13.0-rc7+ #15 
task: ffff88008fc6b7b0 ti: ffff880090796000 task.ti: ffff880090796000
RIP: 0010:[<ffffffffa1684093>]  [<ffffffffa1684093>] rds_iw_laddr_check+0x73/0xc0 [rds_rdma]
RSP: 0018:ffff880090797e10  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8802147a2520 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa1673220
RBP: ffff880090797e38 R08: 0000000000000000 R09: 0000000000000000
R10: 00000001800d0004 R11: 000000007fc1fa61 R12: 0000000000000000
R13: 00000000ac178800 R14: 000000000000d6ff R15: 000000000000d6ff
FS:  00007faf4a474740(0000) GS:ffff88024d000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000007bc CR3: 0000000090789000 CR4: 00000000001407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 ac17880000000002 0000000000000000 000000001d88df67 0000000000000008
 ffffffffa168e6c0 ffff880090797e60 ffffffffa161c7ca ffff880090797ec0
 ffff8802146bb480 00000000ac178800 ffff880090797ea8 ffffffffa1616fb9
Call Trace:
 [<ffffffffa161c7ca>] rds_trans_get_preferred+0x5a/0xa0 [rds]
 [<ffffffffa1616fb9>] rds_bind+0xf9/0x190 [rds]
 [<ffffffff815b8780>] SYSC_bind+0xe0/0x120
 [<ffffffff8108c931>] ? vtime_account_user+0x91/0xa0
 [<ffffffff811324fb>] ? context_tracking_user_exit+0x9b/0x100
 [<ffffffff810104b5>] ? syscall_trace_enter+0x145/0x270
 [<ffffffff815b9bfe>] SyS_bind+0xe/0x10
 [<ffffffff816f2664>] tracesys+0xdd/0xe2
Code: 48 c7 45 d8 00 00 00 00 48 8d 75 d8 44 89 65 dc 48 c7 45 e0 00 00 00 00 66 89 45 d8 e8 47 ae fe ff 85 c0 41 89 c4 75 40 48 8b 03 <80> b8 bc 07 00 00 04 b8 9d ff ff ff 44 0f 45 e0 48 89 df e8 75 


        /* due to this, we will claim to support IB devices unless we
           check node_type. */
        if (ret || cm_id->device->node_type != RDMA_NODE_RNIC)
 1ce:   75 40                   jne    210 <rds_iw_laddr_check+0xb0>
 1d0:   48 8b 03                mov    (%rbx),%rax
                ret = -EADDRNOTAVAIL;
 1d3:   80 b8 bc 07 00 00 04    cmpb   $0x4,0x7bc(%rax)
 1da:   b8 9d ff ff ff          mov    $0xffffff9d,%eax
 1df:   44 0f 45 e0             cmovne %eax,%r12d

Looks like cm_id->device was NULL.

	Dave

