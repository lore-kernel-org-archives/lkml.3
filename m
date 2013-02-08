Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947149Ab3BHVCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:02:50 -0500
Received: from gmmr8.centrum.cz ([46.255.227.254]:41941 "EHLO gmmr8.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947069Ab3BHVCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:02:46 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 08 Feb 2013 22:02:43 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20130206140119.GD10254@dhcp22.suse.cz>, <20130206142219.GF10254@dhcp22.suse.cz>, <20130206160051.GG10254@dhcp22.suse.cz>, <20130208060304.799F362F@pobox.sk>, <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk>, <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk> <20130208171012.GH7557@dhcp22.suse.cz>
In-Reply-To: <20130208171012.GH7557@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130208220243.EDEE0825@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>I assume you have checked that the killed processes eventually die,
>right?
>


When i killed them by hand, yes, they dissappeard from process list (i saw it). I don't know if they really died when OOM killed them.


>Well, I do not see anything supsicious during that time period
>(timestamps translate between Fri Feb  8 02:34:05 and Fri Feb  8
>02:36:48). The kernel log shows a lot of oom during that time. All
>killed processes die eventually.


No, they didn't died by OOM when cgroup was freezed. Just check PIDs from memcg-bug-4.tar.gz and try to find them in kernel log. Why are all PIDs waiting on 'mem_cgroup_handle_oom' and there is no OOM message in the log? Data in memcg-bug-4.tar.gz are only for 2 minutes but i let it run for about 15-20 minutes, no single process killed by OOM. I'm 100% sure that OOM was not killing them (maybe it was trying to but it didn't happen).


>
>Nothing shows it would be a deadlock so far. It is well possible that
>the userspace went mad when seeing a lot of processes dying because it
>doesn't expect it.
>


Lots of processes are dying also now, without your latest patch, and no such things are happening. I'm sure there is something more it this, maybe it revealed another bug?


azur
