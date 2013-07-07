Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3GGXme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 19:42:34 -0400
Received: from gmmr7.centrum.cz ([46.255.225.249]:42814 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3GGXmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 19:42:32 -0400
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Mon, 08 Jul 2013 01:42:24 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>
References: <20130606160446.GE24115@dhcp22.suse.cz>, <20130606181633.BCC3E02E@pobox.sk>, <20130607131157.GF8117@dhcp22.suse.cz>, <20130617122134.2E072BA8@pobox.sk>, <20130619132614.GC16457@dhcp22.suse.cz>, <20130622220958.D10567A4@pobox.sk>, <20130624201345.GA21822@cmpxchg.org>, <20130628120613.6D6CAD21@pobox.sk>, <20130705181728.GQ17812@cmpxchg.org>, <20130705210246.11D2135A@pobox.sk> <20130705191854.GR17812@cmpxchg.org>
In-Reply-To: <20130705191854.GR17812@cmpxchg.org>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130708014224.50F06960@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CC: "Michal Hocko" <mhocko@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "cgroups mailinglist" <cgroups@vger.kernel.org>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
>On Fri, Jul 05, 2013 at 09:02:46PM +0200, azurIt wrote:
>> >I looked at your debug messages but could not find anything that would
>> >hint at a deadlock.  All tasks are stuck in the refrigerator, so I
>> >assume you use the freezer cgroup and enabled it somehow?
>> 
>> 
>> Yes, i'm really using freezer cgroup BUT i was checking if it's not
>> doing problems - unfortunately, several days passed from that day
>> and now i don't fully remember if i was checking it for both cases
>> (unremoveabled cgroups and these freezed processes holding web
>> server port). I'm 100% sure i was checking it for unremoveable
>> cgroups but not so sure for the other problem (i had to act quickly
>> in that case). Are you sure (from stacks) that freezer cgroup was
>> enabled there?
>
>Yeah, all the traces without exception look like this:
>
>1372089762/23433/stack:[<ffffffff81080925>] refrigerator+0x95/0x160
>1372089762/23433/stack:[<ffffffff8106ab7b>] get_signal_to_deliver+0x1cb/0x540
>1372089762/23433/stack:[<ffffffff8100188b>] do_signal+0x6b/0x750
>1372089762/23433/stack:[<ffffffff81001fc5>] do_notify_resume+0x55/0x80
>1372089762/23433/stack:[<ffffffff815cac77>] int_signal+0x12/0x17
>1372089762/23433/stack:[<ffffffffffffffff>] 0xffffffffffffffff
>
>so the freezer was already enabled when you took the backtraces.
>
>> Btw, what about that other stacks? I mean this file:
>> http://watchdog.sk/lkml/memcg-bug-7.tar.gz
>> 
>> It was taken while running the kernel with your patch and from
>> cgroup which was under unresolveable OOM (just like my very original
>> problem).
>
>I looked at these traces too, but none of the tasks are stuck in rmdir
>or the OOM path.  Some /are/ in the page fault path, but they are
>happily doing reclaim and don't appear to be stuck.  So I'm having a
>hard time matching this data to what you otherwise observed.
>
>However, based on what you reported the most likely explanation for
>the continued hangs is the unfinished OOM handling for which I sent
>the followup patch for arch/x86/mm/fault.c.
>



Johannes,

today I tested both of your patches but problem with unremovable cgroups, unfortunately, persists.

azur
