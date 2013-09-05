Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584Ab3IEJOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:14:41 -0400
Received: from gmmr4.centrum.cz ([46.255.227.253]:42749 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763266Ab3IEJOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:14:39 -0400
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Thu, 05 Sep 2013 11:14:30 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>,
        =?utf-8?q?Andrew_Morton?= <akpm@linux-foundation.org>,
        =?utf-8?q?David_Rientjes?= <rientjes@google.com>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <x86@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>, <20130803170831.GB23319@cmpxchg.org>, <20130830215852.3E5D3D66@pobox.sk>, <20130902123802.5B8E8CB1@pobox.sk>, <20130903204850.GA1412@cmpxchg.org>, <20130904114523.A9F0173C@pobox.sk>, <20130904115741.GA28285@dhcp22.suse.cz>, <20130904141000.0F910EFA@pobox.sk> <20130904122632.GB28285@dhcp22.suse.cz>
In-Reply-To: <20130904122632.GB28285@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130905111430.CB1392B4@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >[...]
>> >> My script has just detected (and killed) another freezed cgroup. I
>> >> must say that i'm not 100% sure that cgroup was really freezed but it
>> >> has 99% or more memory usage for at least 30 seconds (well, or it has
>> >> 99% memory usage in both two cases the script was checking it). Here
>> >> are stacks of processes inside it before they were killed:
>> >[...]
>> >> pid: 26536
>> >> stack:
>> >> [<ffffffff81080a45>] refrigerator+0x95/0x160
>> >> [<ffffffff8106ac2b>] get_signal_to_deliver+0x1cb/0x540
>> >> [<ffffffff8100188b>] do_signal+0x6b/0x750
>> >> [<ffffffff81001fc5>] do_notify_resume+0x55/0x80
>> >> [<ffffffff815cb662>] retint_signal+0x3d/0x7b
>> >> [<ffffffffffffffff>] 0xffffffffffffffff
>> >
>> >[...]
>> >
>> >This task is sitting in the refigerator which means it has been frozen
>> >by the freezer cgroup most probably. I am not familiar with the
>> >implementation but my recollection is that you have to thaw that group
>> >in order the killed process can pass away.
>> 
>> Yes, my script is freezing the cgroup before killing processes inside
>> it. Stacks are taken after the freeze, it that problem?
>
>I thought you had a problem to remove this particular group...
>-- 
>Michal Hocko
>SUSE Labs




My script detected another freezed cgroup today, sending stacks. Is there anything interesting?



pid: 947
stack:
[<ffffffff810ceefe>] sleep_on_page_killable+0xe/0x40
[<ffffffff810cee57>] __lock_page_killable+0x67/0x70
[<ffffffff810d1067>] generic_file_aio_read+0x4d7/0x790
[<ffffffff81116a8a>] do_sync_read+0xea/0x130
[<ffffffff81117a40>] vfs_read+0xf0/0x220
[<ffffffff81117c71>] sys_read+0x51/0x90
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 949
stack:
[<ffffffff810ceefe>] sleep_on_page_killable+0xe/0x40
[<ffffffff810cee57>] __lock_page_killable+0x67/0x70
[<ffffffff810d1067>] generic_file_aio_read+0x4d7/0x790
[<ffffffff81116a8a>] do_sync_read+0xea/0x130
[<ffffffff81117a40>] vfs_read+0xf0/0x220
[<ffffffff81117c71>] sys_read+0x51/0x90
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 985
stack:
[<ffffffff810ceefe>] sleep_on_page_killable+0xe/0x40
n[<ffffffff810cee57>] __lock_page_killable+0x67/0x70
[<ffffffff810d1067>] generic_file_aio_read+0x4d7/0x790
[<ffffffff81116a8a>] do_sync_read+0xea/0x130
[<ffffffff81117a40>] vfs_read+0xf0/0x220
[<ffffffff81117c71>] sys_read+0x51/0x90
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 987
stack:
[<ffffffff810ceefe>] sleep_on_page_killable+0xe/0x40
[<ffffffff810cee57>] __lock_page_killable+0x67/0x70
[<ffffffff810d1067>] generic_file_aio_read+0x4d7/0x790
[<ffffffff81116a8a>] do_sync_read+0xea/0x130
[<ffffffff81117a40>] vfs_read+0xf0/0x220
[<ffffffff81117c71>] sys_read+0x51/0x90
[<ffffffff815cbce6>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 1031
stack:
[<ffffffff8110f255>] mem_cgroup_oom_synchronize+0x165/0x190
[<ffffffff810d269e>] pagefault_out_of_memory+0xe/0x120
[<ffffffff81026f5e>] mm_fault_error+0x9e/0x150
[<ffffffff81027414>] do_page_fault+0x404/0x490
[<ffffffff815cb7bf>] page_fault+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 1032
stack:
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 1036
stack:
[<ffffffff8110f255>] mem_cgroup_oom_synchronize+0x165/0x190
[<ffffffff810d269e>] pagefault_out_of_memory+0xe/0x120
[<ffffffff81026f5e>] mm_fault_error+0x9e/0x150
[<ffffffff81027414>] do_page_fault+0x404/0x490
[<ffffffff815cb7bf>] page_fault+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff


pid: 1038
stack:
[<ffffffff8110f255>] mem_cgroup_oom_synchronize+0x165/0x190
[<ffffffff810d269e>] pagefault_out_of_memory+0xe/0x120
[<ffffffff81026f5e>] mm_fault_error+0x9e/0x150
[<ffffffff81027414>] do_page_fault+0x404/0x490
[<ffffffff815cb7bf>] page_fault+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff
