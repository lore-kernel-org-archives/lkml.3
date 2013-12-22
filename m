Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3LVUqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 15:46:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39916 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab3LVUqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 15:46:49 -0500
Message-ID: <52B74FB1.7070306@oracle.com>
Date: Sun, 22 Dec 2013 15:46:41 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: kernfs: WARNING: CPU: 59 PID: 10414 at lib/debugobjects.c:260
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've stumbled on 
the following spew.

Beyond regular trinity fuzzing, the machine was in the middle of attempting to offline all of it's 
cpus (64 of them).

[  645.148744] WARNING: CPU: 59 PID: 10414 at lib/debugobjects.c:260 debug_print_object
+0x8d/0xb0()
[  645.150844] ODEBUG: free active (active state 0) object type: timer_list hint: delay
ed_work_timer_fn+0x0/0x20
[  645.152178] Modules linked in:
[  645.152699] CPU: 59 PID: 10414 Comm: sh Tainted: G        W    3.13.0-rc4-next-20131
220-sasha-00013-gf9a57f1-dirty #6
[  645.154113]  0000000000000104 ffff88001a74fa68 ffffffff845d3d3c ffffffff858006ee
[  645.155294]  ffff88001a74fab8 ffff88001a74faa8 ffffffff8112f93c ffff88001a74fad8
[  645.155294]  ffffffff8594fab2 ffff880168f10a10 ffffffff86068c00 ffffffff8891eaf8
[  645.157180] Call Trace:
[  645.157697]  [<ffffffff845d3d3c>] dump_stack+0x52/0x7f
[  645.157975]  [<ffffffff8112f93c>] warn_slowpath_common+0x8c/0xc0
[  645.158744]  [<ffffffff8112fa26>] warn_slowpath_fmt+0x46/0x50
[  645.158744]  [<ffffffff81adcd2d>] debug_print_object+0x8d/0xb0
[  645.158744]  [<ffffffff81153130>] ? __queue_work+0x3f0/0x3f0
[  645.158744]  [<ffffffff81add535>] __debug_check_no_obj_freed+0xa5/0x220
[  645.158744]  [<ffffffff8107e346>] ? cpuid4_cache_sysfs_exit+0x46/0xc0
[  645.158744]  [<ffffffff8107e346>] ? cpuid4_cache_sysfs_exit+0x46/0xc0
[  645.158744]  [<ffffffff81add6c5>] debug_check_no_obj_freed+0x15/0x20
[  645.158744]  [<ffffffff812ae4bf>] kfree+0x21f/0x2e0
[  645.158744]  [<ffffffff8107e346>] cpuid4_cache_sysfs_exit+0x46/0xc0
[  645.158744]  [<ffffffff8107ebea>] cache_remove_dev+0x11a/0x130
[  645.158744]  [<ffffffff8107f128>] cacheinfo_cpu_callback+0x78/0x90
[  645.158744]  [<ffffffff845e027e>] notifier_call_chain+0xee/0x130
[  645.158744]  [<ffffffff8116273e>] __raw_notifier_call_chain+0xe/0x10
[  645.158744]  [<ffffffff8112fbe0>] __cpu_notify+0x20/0x40
[  645.158744]  [<ffffffff8112fc15>] cpu_notify_nofail+0x15/0x30
[  645.158744]  [<ffffffff845caf75>] _cpu_down+0x195/0x2e0
[  645.158744]  [<ffffffff8112fc97>] ? cpu_maps_update_begin+0x17/0x20
[  645.158744]  [<ffffffff8207f745>] ? device_offline+0x55/0xd0
[  645.158744]  [<ffffffff845c9825>] ? klist_next+0xf5/0x120
[  645.158744]  [<ffffffff845d67cd>] ? mutex_trylock+0x1fd/0x270
[  645.158744]  [<ffffffff845cb0f6>] cpu_down+0x36/0x50
[  645.158744]  [<ffffffff82086034>] cpu_subsys_offline+0x14/0x20
[  645.158744]  [<ffffffff8207f772>] device_offline+0x82/0xd0
[  645.158744]  [<ffffffff820806d8>] online_store+0x58/0x80
[  645.158744]  [<ffffffff8207e6d0>] dev_attr_store+0x20/0x30
[  645.158744]  [<ffffffff8135d62f>] sysfs_kf_write+0x4f/0x70
[  645.158744]  [<ffffffff8136160b>] kernfs_fop_write+0xdb/0x140
[  645.158744]  [<ffffffff812d51a3>] vfs_write+0xf3/0x1e0
[  645.158744]  [<ffffffff812d5392>] SyS_write+0x62/0xa0
[  645.158744]  [<ffffffff845e4e90>] tracesys+0xdd/0xe2


Thanks,
Sasha
