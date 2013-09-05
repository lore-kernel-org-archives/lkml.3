Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935700Ab3IEKRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:17:10 -0400
Received: from gmmr5.centrum.cz ([46.255.225.250]:52068 "EHLO gmmr5.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935550Ab3IEKRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:17:08 -0400
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Thu, 05 Sep 2013 12:17:00 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>,
        =?utf-8?q?Andrew_Morton?= <akpm@linux-foundation.org>,
        =?utf-8?q?David_Rientjes?= <rientjes@google.com>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <x86@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>, <20130803170831.GB23319@cmpxchg.org>, <20130830215852.3E5D3D66@pobox.sk>, <20130902123802.5B8E8CB1@pobox.sk>, <20130903204850.GA1412@cmpxchg.org>, <20130904114523.A9F0173C@pobox.sk>, <20130904115741.GA28285@dhcp22.suse.cz>, <20130904141000.0F910EFA@pobox.sk>, <20130904122632.GB28285@dhcp22.suse.cz>, <20130905111430.CB1392B4@pobox.sk> <20130905095331.GA9702@dhcp22.suse.cz>
In-Reply-To: <20130905095331.GA9702@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130905121700.546B5881@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>[...]
>> My script detected another freezed cgroup today, sending stacks. Is
>> there anything interesting?
>
>3 tasks are sleeping and waiting for somebody to take an action to
>resolve memcg OOM. The memcg oom killer is enabled for that group?  If
>yes, which task has been selected to be killed? You can find that in oom
>report in dmesg.
>
>I can see a way how this might happen. If the killed task happened to
>allocate a memory while it is exiting then it would get to the oom
>condition again without freeing any memory so nobody waiting on the
>memcg_oom_waitq gets woken. We have a report like that: 
>https://lkml.org/lkml/2013/7/31/94
>
>The issue got silent in the meantime so it is time to wake it up.
>It would be definitely good to see what happened in your case though.
>If any of the bellow tasks was the oom victim then it is very probable
>this is the same issue.

Here it is:
http://watchdog.sk/lkml/kern5.log

Processes were killed by my script at about 11:05:35.

azur
