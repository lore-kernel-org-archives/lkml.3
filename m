Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3LPLAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:00:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23800 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3LPLAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:00:12 -0500
Message-ID: <52AEDD2F.8040704@oracle.com>
Date: Mon, 16 Dec 2013 16:29:59 +0530
From: Allen Pais <allen.pais@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc64: convert spinlock_t to raw_spinlock_t in
 mmu_context_t
References: <1387166853-10782-1-git-send-email-allen.pais@oracle.com> <1387166853-10782-3-git-send-email-allen.pais@oracle.com> <52AED5BB.1060002@linutronix.de>
In-Reply-To: <52AED5BB.1060002@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Issue debugged by Thomas Gleixner <tglx@linutronix.de>
The kernel crashed while I attempted preempt_rt support on log
at:

[ 1487.027884] I7: <rt_mutex_setprio+0x3c/0x2c0>
[ 1487.027885] Call Trace:
[ 1487.027887]  [00000000004967dc] rt_mutex_setprio+0x3c/0x2c0
[ 1487.027892]  [00000000004afe20] task_blocks_on_rt_mutex+0x180/0x200
[ 1487.027895]  [0000000000819114] rt_spin_lock_slowlock+0x94/0x300
[ 1487.027897]  [0000000000817ebc] __schedule+0x39c/0x53c
[ 1487.027899]  [00000000008185fc] schedule+0x1c/0xc0
[ 1487.027908]  [000000000048fff4] smpboot_thread_fn+0x154/0x2e0
[ 1487.027913]  [000000000048753c] kthread+0x7c/0xa0
[ 1487.027920]  [00000000004060c4] ret_from_syscall+0x1c/0x2c
[ 1487.027922]  [0000000000000000]           (null)

Thomas debugged it and pointed me towards the fix.

> 
> I think davem would appreciate if you add a little here than this. The
> same goes for 3/3.
> 

The same goes with 3/3

[ 2317.606015]  [00000000008072f4] rt_spin_lock_slowlock+0x94/0x300
[ 2317.606020]  [0000000000451d74] get_new_mmu_context+0x14/0x160
[ 2317.606026]  [0000000000806394] switch_to_pc+0xd4/0x2a0
[ 2317.606029]  [00000000008067dc] schedule+0x1c/0xc0
[ 2317.606031]  [0000000000807364] rt_spin_lock_slowlock+0x104/0x300
[ 2317.606033]  [0000000000450284] destroy_context+0x84/0x120
[ 2317.606036]  [000000000045c788] __mmdrop+0x28/0xe0
[ 2317.606045]  [00000000004bf290] rcu_process_callbacks+0x450/0x760
[ 2317.606049]  [0000000000466d48] do_current_softirqs+0x208/0x3c0
[ 2317.606051]  [0000000000466f14] run_ksoftirqd+0x14/0x40
[ 2317.606057]  [000000000048c64c] smpboot_thread_fn+0x18c/0x2e0
[ 2317.606061]  [0000000000483b5c] kthread+0x7c/0xa0
[ 2317.606069]  [00000000004060c4] ret_from_syscall+0x1c/0x2c
[ 2317.606070]  [0000000000000000]           (null)

I am not sure if it'd be nice to put the call trace in the commit message.
But if needed I can re-send them.

- Allen
