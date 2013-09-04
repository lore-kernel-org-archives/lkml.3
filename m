Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785Ab3IDMja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:39:30 -0400
Received: from gmmr5.centrum.cz ([46.255.225.250]:49421 "EHLO gmmr5.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934599Ab3IDMj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:39:27 -0400
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Wed, 04 Sep 2013 14:39:25 +0200
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
Message-Id: <20130904143925.6672E0C4@pobox.sk>
X-Maser: brud
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



No, this one is different from the unremovable one. This was, probably, hanged just like when i was originaly reporting this problem (but, as i said, i'm not 100% sure because of reasons i described). Sorry for confusion.

azur
