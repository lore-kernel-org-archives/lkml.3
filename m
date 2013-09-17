Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3IQOKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:10:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3IQOKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:10:18 -0400
Date: Tue, 17 Sep 2013 16:10:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Message-ID: <20130917141013.GA30838@dhcp22.suse.cz>
References: <20130916134014.GA3674@dhcp22.suse.cz>
 <20130916160119.2E76C2A1@pobox.sk>
 <20130916140607.GC3674@dhcp22.suse.cz>
 <20130916161316.5113F6E7@pobox.sk>
 <20130916145744.GE3674@dhcp22.suse.cz>
 <20130916170543.77F1ECB4@pobox.sk>
 <20130916152548.GF3674@dhcp22.suse.cz>
 <20130916225246.A633145B@pobox.sk>
 <20130917000244.GD3278@cmpxchg.org>
 <20130917131535.94E0A843@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917131535.94E0A843@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-09-13 13:15:35, azurIt wrote:
[...]
> Is something unusual on this stack?
> 
> 
> [<ffffffff810d1a5e>] dump_header+0x7e/0x1e0
> [<ffffffff810d195f>] ? find_lock_task_mm+0x2f/0x70
> [<ffffffff810d1f25>] oom_kill_process+0x85/0x2a0
> [<ffffffff810d24a8>] mem_cgroup_out_of_memory+0xa8/0xf0
> [<ffffffff8110fb76>] mem_cgroup_oom_synchronize+0x2e6/0x310
> [<ffffffff8110efc0>] ? mem_cgroup_uncharge_page+0x40/0x40
> [<ffffffff810d2703>] pagefault_out_of_memory+0x13/0x130
> [<ffffffff81026f6e>] mm_fault_error+0x9e/0x150
> [<ffffffff81027424>] do_page_fault+0x404/0x490
> [<ffffffff810f952c>] ? do_mmap_pgoff+0x3dc/0x430
> [<ffffffff815cb87f>] page_fault+0x1f/0x30

This is a regular memcg OOM killer. Which dumps messages about what is
going to do. So no, nothing unusual, except if it was like that for ever
which would mean that oom_kill_process is in the endless loop. But a
single stack doesn't tell us much.

Just a note. When you see something hogging a cpu and you are not sure
whether it might be in an endless loop inside the kernel it makes sense
to take several snaphosts of the stack trace and see if it changes. If
not and the process is not sleeping (there is no schedule on the trace)
then it might be looping somewhere waiting for Godot. If it is sleeping
then it is slightly harder because you would have to identify what it is
waiting for which requires to know a deeper context.
-- 
Michal Hocko
SUSE Labs
