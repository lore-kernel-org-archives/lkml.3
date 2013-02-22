Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3BVMBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:01:09 -0500
Received: from gmmr2.centrum.cz ([46.255.227.252]:50864 "EHLO gmmr2.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab3BVMBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:01:04 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 22 Feb 2013 13:00:55 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk>, <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk>, <20130208171012.GH7557@dhcp22.suse.cz>, <20130208220243.EDEE0825@pobox.sk>, <20130210150310.GA9504@dhcp22.suse.cz>, <20130210174619.24F20488@pobox.sk> <20130211112240.GC19922@dhcp22.suse.cz>
In-Reply-To: <20130211112240.GC19922@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130222130055.29151595@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Unfortunately I am not able to reproduce this behavior even if I try
>to hammer OOM like mad so I am afraid I cannot help you much without
>further debugging patches.
>I do realize that experimenting in your environment is a problem but I
>do not many options left. Please do not use strace and rather collect
>/proc/pid/stack instead. It would be also helpful to get group/tasks
>file to have a full list of tasks in the group



Sending new info!

I found out one interesting thing. When problem occurs (it probably happen when OOM is started in target cgroup but i'm not sure), the target cgroup, somehow, becames broken. In other words, after the problem occurs once in target cgroup, it is happening always in this cgroup. I made this test:

1.) I create cgroup A with limits (also with memory limit).
2.) Waited when OOM is started (can takes hours). Processes in target cgroup becames freezed so they must be killed.
3.) After this, processes are always freezing in cgroup A, it usually takes 20-30 seconds after killing previously freezed processes.
4.) I created cgroup B with the *same* limits as cgroup A and moved user from A to B. Problem disappears.
5.) Go to (2)

And second thing, i got've kernel oops, look at the end of:
http://watchdog.sk/lkml/oops
