Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228Ab3IDHx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:53:56 -0400
Received: from gmmr2.centrum.cz ([46.255.227.252]:57488 "EHLO gmmr2.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762057Ab3IDHxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:53:54 -0400
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Wed, 04 Sep 2013 09:53:51 +0200
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
Message-Id: <20130904095351.8220AA75@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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



# cat /cgroups/cannot_rm_01/memory.oom_control 
oom_kill_disable 0
under_oom 1
#




>Was there a warning in the syslog ("Fixing unhandled memcg OOM
>context")?



Really don't know cos i don't know the exact day when it happens. I just find that out on 30.8. but it could happen anytime before. Uptime on that server is 27 days so maybe i can grep all syslog logs i have if it helps. I just need to find out the original name of that  cgroup cos i renamed it to 'cannot_rm_01' so my software will ignore it.



>If it happens again, could you check if there are tasks left in the
>cgroup?  And provide /proc/<pid>/stack of the hung task trying to
>delete the cgroup?



# cat /cgroups/cannot_rm_01/tasks
#



>> Now i can definitely confirm that problem is NOT fixed :( it happened again but i don't have any data because i already disabled all debug output.
>
>Which debug output?



Debug output from my own scripts which are suppose to handle this situation and kill frozen processes. I already reactivated it, it is grabbing content of 'stacks' from all processes before killing them.



>Do you still have access to the syslog?



>From that day (30.8.)? Yes.


>It's possible that, as your system does not deadlock on the OOMing
>cgroup anymore, you hit a separate bug...
>
>Thanks!
>
