Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaFWEQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:16:37 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:39188 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaFWEQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:16:35 -0400
Date: Mon, 23 Jun 2014 00:16:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] memcg: mem_cgroup_charge_statistics needs
 preempt_disable
Message-ID: <20140623041621.GM7331@cmpxchg.org>
References: <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <1403282171-25502-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403282171-25502-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 06:36:11PM +0200, Michal Hocko wrote:
> preempt_disable was previously disabled by lock_page_cgroup which has
> been removed by "mm: memcontrol: rewrite uncharge API".
> 
> This fixes the a flood of splats like this:
> [    3.149371] BUG: using __this_cpu_add() in preemptible [00000000] code: udevd/1271
> [    3.151458] caller is __this_cpu_preempt_check+0x13/0x15
> [    3.152927] CPU: 0 PID: 1271 Comm: udevd Not tainted 3.15.0-test1 #366
> [    3.154637] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    3.156788]  0000000000000000 ffff88000005fba8 ffffffff814efe3f 0000000000000000
> [    3.158810]  ffff88000005fbd8 ffffffff8125b969 ffff880007413448 0000000000000001
> [    3.160836]  ffffea00001e8c00 0000000000000001 ffff88000005fbe8 ffffffff8125b9a8
> [    3.162950] Call Trace:
> [    3.163598]  [<ffffffff814efe3f>] dump_stack+0x4e/0x7a
> [    3.164942]  [<ffffffff8125b969>] check_preemption_disabled+0xd2/0xe5
> [    3.166618]  [<ffffffff8125b9a8>] __this_cpu_preempt_check+0x13/0x15
> [    3.168267]  [<ffffffff8112b630>] mem_cgroup_charge_statistics.isra.36+0xb5/0xc6
> [    3.170169]  [<ffffffff8112d2c5>] commit_charge+0x23c/0x256
> [    3.171823]  [<ffffffff8113101b>] mem_cgroup_commit_charge+0xb8/0xd7
> [    3.173838]  [<ffffffff810f5dab>] shmem_getpage_gfp+0x399/0x605
> [    3.175363]  [<ffffffff810f7456>] shmem_write_begin+0x3d/0x58
> [    3.176854]  [<ffffffff810e1361>] generic_perform_write+0xbc/0x192
> [    3.178445]  [<ffffffff8114a086>] ? file_update_time+0x34/0xac
> [    3.179952]  [<ffffffff810e2ae4>] __generic_file_aio_write+0x2c0/0x300
> [    3.181655]  [<ffffffff810e2b76>] generic_file_aio_write+0x52/0xbd
> [    3.183234]  [<ffffffff81133944>] do_sync_write+0x59/0x78
> [    3.184630]  [<ffffffff81133ea8>] vfs_write+0xc4/0x181
> [    3.185957]  [<ffffffff81134801>] SyS_write+0x4a/0x91
> [    3.187258]  [<ffffffff814fd30e>] tracesys+0xd0/0xd5
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Thanks, Michal.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
