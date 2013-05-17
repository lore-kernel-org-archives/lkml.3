Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3EQJEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:04:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27592 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab3EQJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:04:05 -0400
Message-ID: <5195F265.4000603@huawei.com>
Date: Fri, 17 May 2013 17:03:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: (cred_guard_mutex vs seq->lock) INFO: possible circular locking dependency
 detected
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  130.287724] ======================================================
[  130.287732] [ INFO: possible circular locking dependency detected ]
[  130.287742] 3.10.0-rc1-0.7-default+ #9 Not tainted
[  130.287749] -------------------------------------------------------
[  130.287758] trinity-child3/11061 is trying to acquire lock:
[  130.287766]  (&p->lock){+.+.+.}, at: [<ffffffff811a3ed0>] seq_read+0x40/0x410
[  130.287784]
[  130.287784] but task is already holding lock:
[  130.287794]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81183f77>] prepare_bprm_creds+0x37/0x80
[  130.287812]
[  130.287812] which lock already depends on the new lock.
[  130.287812]
[  130.287826]
[  130.287826] the existing dependency chain (in reverse order) is:
[  130.287837]
[  130.287837] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[  130.287851]        [<ffffffff810aa49c>] lock_acquire+0xdc/0x110
[  130.287862]        [<ffffffff814994cc>] mutex_lock_killable_nested+0x4c/0x420
[  130.287876]        [<ffffffff8103cd24>] mm_access+0x34/0xc0
[  130.287886]        [<ffffffff811e5d71>] m_start+0x71/0x180
[  130.287897]        [<ffffffff811a3f2b>] seq_read+0x9b/0x410
[  130.287907]        [<ffffffff8117d558>] vfs_read+0xc8/0x130
[  130.287919]        [<ffffffff8117dbf4>] SyS_read+0x64/0xa0
[  130.287929]        [<ffffffff814a6682>] system_call_fastpath+0x16/0x1b
[  130.287941]
[  130.287941] -> #0 (&p->lock){+.+.+.}:
[  130.287953]        [<ffffffff810a9ffd>] __lock_acquire+0x14dd/0x18a0
[  130.287963]        [<ffffffff810aa49c>] lock_acquire+0xdc/0x110
[  130.287973]        [<ffffffff81498d20>] mutex_lock_nested+0x40/0x390
[  130.287984]        [<ffffffff811a3ed0>] seq_read+0x40/0x410
[  130.287993]        [<ffffffff811e6f1f>] proc_reg_read+0x4f/0x80
[  130.288004]        [<ffffffff8117d558>] vfs_read+0xc8/0x130
[  130.288013]        [<ffffffff81184369>] kernel_read+0x49/0x60
[  130.288023]        [<ffffffff8118446a>] prepare_binprm+0xea/0x180
[  130.288033]        [<ffffffff811850bb>] do_execve_common+0x48b/0x6e0
[  130.288044]        [<ffffffff811853d9>] do_execve+0x39/0x40
[  130.288054]        [<ffffffff81185427>] SyS_execve+0x47/0x70
[  130.288063]        [<ffffffff814a6c79>] stub_execve+0x69/0xa0
[  130.288074]
[  130.288074] other info that might help us debug this:
[  130.288074]
[  130.288088]  Possible unsafe locking scenario:
[  130.288088]
[  130.288098]        CPU0                    CPU1
[  130.288105]        ----                    ----
[  130.288111]   lock(&sig->cred_guard_mutex);
[  130.288120]                                lock(&p->lock);
[  130.288130]                                lock(&sig->cred_guard_mutex);
[  130.288140]   lock(&p->lock);
[  130.288147]
[  130.288147]  *** DEADLOCK ***
[  130.288147]
[  130.288160] 1 lock held by trinity-child3/11061:
[  130.288167]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81183f77>] prepare_bprm_creds+0x37/0x80
[  130.288184]
[  130.288184] stack backtrace:
[  130.288195] CPU: 3 PID: 11061 Comm: trinity-child3 Not tainted 3.10.0-rc1-0.7-default+ #9
[  130.288205] Hardware name: Huawei Technologies Co., Ltd. Tecal RH2285          /BC11BTSA              , BIOS CTSAV036 04/27/2011
[  130.288217]  ffffffff81e51fa0 ffff880bf6cb5b18 ffffffff8149845c ffff880bf6cb5b58
[  130.288231]  ffffffff810a7183 0000000000000001 0000000000000000 0000000000000001
[  130.288244]  0000000000000000 ffff880bf8be2680 00000000002e2188 ffff880bf6cb5c38
[  130.288257] Call Trace:
[  130.288266]  [<ffffffff8149845c>] dump_stack+0x19/0x1d
[  130.288276]  [<ffffffff810a7183>] print_circular_bug+0x223/0x330
[  130.288286]  [<ffffffff810a9ffd>] __lock_acquire+0x14dd/0x18a0
[  130.288296]  [<ffffffff810aa49c>] lock_acquire+0xdc/0x110
[  130.288306]  [<ffffffff811a3ed0>] ? seq_read+0x40/0x410
[  130.288317]  [<ffffffff81498d20>] mutex_lock_nested+0x40/0x390
[  130.288327]  [<ffffffff811a3ed0>] ? seq_read+0x40/0x410
[  130.288337]  [<ffffffff811a3ed0>] seq_read+0x40/0x410
[  130.288347]  [<ffffffff8149d3fb>] ? _raw_spin_unlock+0x2b/0x40
[  130.288360]  [<ffffffff811971cf>] ? dput+0x9f/0x230
[  130.288369]  [<ffffffff811e6f1f>] proc_reg_read+0x4f/0x80
[  130.288380]  [<ffffffff8117d558>] vfs_read+0xc8/0x130
[  130.288389]  [<ffffffff81184369>] kernel_read+0x49/0x60
[  130.288399]  [<ffffffff8118446a>] prepare_binprm+0xea/0x180
[  130.288409]  [<ffffffff811850bb>] do_execve_common+0x48b/0x6e0
[  130.288419]  [<ffffffff81184d4f>] ? do_execve_common+0x11f/0x6e0
[  130.288430]  [<ffffffff811853d9>] do_execve+0x39/0x40
[  130.288440]  [<ffffffff81185427>] SyS_execve+0x47/0x70
[  130.288450]  [<ffffffff814a6c79>] stub_execve+0x69/0xa0
