Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934729Ab3IDJpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:45:30 -0400
Received: from gmmr3.centrum.cz ([46.255.225.251]:33624 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934370Ab3IDJp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:45:27 -0400
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Wed, 04 Sep 2013 11:45:23 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Andrew_Morton?= <akpm@linux-foundation.org>,
        =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>,
        =?utf-8?q?David_Rientjes?= <rientjes@google.com>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <x86@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>, <20130803170831.GB23319@cmpxchg.org>, <20130830215852.3E5D3D66@pobox.sk>, <20130902123802.5B8E8CB1@pobox.sk> <20130903204850.GA1412@cmpxchg.org>
In-Reply-To: <20130903204850.GA1412@cmpxchg.org>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130904114523.A9F0173C@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hello azur,
>
>On Mon, Sep 02, 2013 at 12:38:02PM +0200, azurIt wrote:
>> >>Hi azur,
>> >>
>> >>here is the x86-only rollup of the series for 3.2.
>> >>
>> >>Thanks!
>> >>Johannes
>> >>---
>> >
>> >
>> >Johannes,
>> >
>> >unfortunately, one problem arises: I have (again) cgroup which cannot be deleted :( it's a user who had very high memory usage and was reaching his limit very often. Do you need any info which i can gather now?
>
>Did the OOM killer go off in this group?
>
>Was there a warning in the syslog ("Fixing unhandled memcg OOM
>context")?
>
>If it happens again, could you check if there are tasks left in the
>cgroup?  And provide /proc/<pid>/stack of the hung task trying to
>delete the cgroup?
>
>> Now i can definitely confirm that problem is NOT fixed :( it happened again but i don't have any data because i already disabled all debug output.
>
>Which debug output?
>
>Do you still have access to the syslog?
>
>It's possible that, as your system does not deadlock on the OOMing
>cgroup anymore, you hit a separate bug...
>
>Thanks!



My script has just detected (and killed) another freezed cgroup. I must say that i'm not 100% sure that cgroup was really freezed but it has 99% or more memory usage for at least 30 seconds (well, or it has 99% memory usage in both two cases the script was checking it). Here are stacks of processes inside it before they were killed:



pid: 26490
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26503
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26517
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26518
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26519
stack:
[<ffffffff815cb618>] retint_careful+0xd/0x1a
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26520
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26521
stack:
[<ffffffff815cb618>] retint_careful+0xd/0x1a
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26522
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26523
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26524
stack:
[<ffffffff81052671>] sys_sched_yield+0x41/0x70
[<ffffffff81148d91>] free_more_memory+0x21/0x60
[<ffffffff8114941d>] __getblk+0x14d/0x2c0
[<ffffffff8119888b>] ext3_getblk+0xeb/0x240
[<ffffffff811989f9>] ext3_bread+0x19/0x90
[<ffffffff8119cea3>] ext3_dx_find_entry+0x83/0x1e0
[<ffffffff8119d2e4>] ext3_find_entry+0x2e4/0x480
[<ffffffff8119dbcd>] ext3_lookup+0x4d/0x120
[<ffffffff811228f5>] d_alloc_and_lookup+0x45/0x90
[<ffffffff81125578>] __lookup_hash+0xa8/0xf0
[<ffffffff81127852>] do_last+0x312/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26526
stack:
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26531
stack:
[<ffffffff81127842>] do_last+0x302/0xa60
[<ffffffff81128077>] path_openat+0xd7/0x470
[<ffffffff81128529>] do_filp_open+0x49/0xa0
[<ffffffff81114a16>] do_sys_open+0x106/0x240
[<ffffffff81114b90>] sys_open+0x20/0x30
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26533
stack:
[<ffffffff815cb618>] retint_careful+0xd/0x1a
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26536
stack:
[<ffffffff81080a45>] refrigerator+0x95/0x160
[<ffffffff8106ac2b>] get_signal_to_deliver+0x1cb/0x540
[<ffffffff8100188b>] do_signal+0x6b/0x750
[<ffffffff81001fc5>] do_notify_resume+0x55/0x80
[<ffffffff815cb662>] retint_signal+0x3d/0x7b
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 26539
stack:
[<ffffffff815cb618>] retint_careful+0xd/0x1a
[<ffffffffffffffff>] 0xffffffffffffffff
