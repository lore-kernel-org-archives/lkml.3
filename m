Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3GMXvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 19:51:21 -0400
Received: from gmmr2.centrum.cz ([46.255.227.252]:59670 "EHLO gmmr2.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab3GMXvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 19:51:20 -0400
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Sun, 14 Jul 2013 01:51:12 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        <righi.andrea@gmail.com>
References: <20130624201345.GA21822@cmpxchg.org>, <20130628120613.6D6CAD21@pobox.sk>, <20130705181728.GQ17812@cmpxchg.org>, <20130705210246.11D2135A@pobox.sk>, <20130705191854.GR17812@cmpxchg.org>, <20130708014224.50F06960@pobox.sk>, <20130709131029.GH20281@dhcp22.suse.cz>, <20130709151921.5160C199@pobox.sk>, <20130709135450.GI20281@dhcp22.suse.cz>, <20130710182506.F25DF461@pobox.sk>, <20130711072507.GA21667@dhcp22.suse.cz> <20130714012641.C2DA4E05@pobox.sk>
In-Reply-To: <20130714012641.C2DA4E05@pobox.sk>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130714015112.FFCB7AF7@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CC: "Johannes Weiner" <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "cgroups mailinglist" <cgroups@vger.kernel.org>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, righi.andrea@gmail.com
>> CC: "Johannes Weiner" <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "cgroups mailinglist" <cgroups@vger.kernel.org>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, righi.andrea@gmail.com
>>On Wed 10-07-13 18:25:06, azurIt wrote:
>>> >> Now i realized that i forgot to remove UID from that cgroup before
>>> >> trying to remove it, so cgroup cannot be removed anyway (we are using
>>> >> third party cgroup called cgroup-uid from Andrea Righi, which is able
>>> >> to associate all user's processes with target cgroup). Look here for
>>> >> cgroup-uid patch:
>>> >> https://www.develer.com/~arighi/linux/patches/cgroup-uid/cgroup-uid-v8.patch
>>> >> 
>>> >> ANYWAY, i'm 101% sure that 'tasks' file was empty and 'under_oom' was
>>> >> permanently '1'.
>>> >
>>> >This is really strange. Could you post the whole diff against stable
>>> >tree you are using (except for grsecurity stuff and the above cgroup-uid
>>> >patch)?
>>> 
>>> 
>>> Here are all patches which i applied to kernel 3.2.48 in my last test:
>>> http://watchdog.sk/lkml/patches3/
>>
>>The two patches from Johannes seem correct.
>>
>>From a quick look even grsecurity patchset shouldn't interfere as it
>>doesn't seem to put any code between handle_mm_fault and mm_fault_error
>>and there also doesn't seem to be any new handle_mm_fault call sites.
>>
>>But I cannot tell there aren't other code paths which would lead to a
>>memcg charge, thus oom, without proper FAULT_FLAG_KERNEL handling.
>
>
>Michal,
>
>now i can definitely confirm that problem with unremovable cgroups persists. What info do you need from me? I applied also your little 'WARN_ON' patch.
>
>azur



Ok, i think you want this:
http://watchdog.sk/lkml/kern4.log
