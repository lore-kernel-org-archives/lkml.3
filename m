Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3FQKVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:21:39 -0400
Received: from gmmr1.centrum.cz ([46.255.225.252]:35912 "EHLO gmmr1.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab3FQKVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:21:37 -0400
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Mon, 17 Jun 2013 12:21:34 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk>, <20130208171012.GH7557@dhcp22.suse.cz>, <20130208220243.EDEE0825@pobox.sk>, <20130210150310.GA9504@dhcp22.suse.cz>, <20130210174619.24F20488@pobox.sk>, <20130211112240.GC19922@dhcp22.suse.cz>, <20130222092332.4001E4B6@pobox.sk>, <20130606160446.GE24115@dhcp22.suse.cz>, <20130606181633.BCC3E02E@pobox.sk> <20130607131157.GF8117@dhcp22.suse.cz>
In-Reply-To: <20130607131157.GF8117@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20130617122134.2E072BA8@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Here we go. I hope I didn't screw anything (Johannes might double check)
>because there were quite some changes in the area since 3.2. Nothing
>earth shattering though. Please note that I have only compile tested
>this. Also make sure you remove the previous patches you have from me.


Hi Michal,

it, unfortunately, didn't work. Everything was working fine but original problem is still occuring. I'm unable to send you stacks or more info because problem is taking down the whole server for some time now (don't know what exactly caused it to start happening, maybe newer versions of 3.2.x). But i'm sure of one thing - when problem occurs, nothing is able to access hard drives (every process which tries it is freezed until problem is resolved or server is rebooted). Problem is fixed after killing processes from cgroup which caused it and everything immediatelly starts to work normally. I find this out by keeping terminal opened from another server to one where my problem is occuring quite often and running several apps there (htop, iotop, etc.). When problem occurs, all apps which wasn't working with HDD was ok. The htop proved to be very usefull here because it's only reading proc filesystem and is also able to send KILL signals - i was able to resolve the problem with it
  without rebooting the server.

I created a special daemon (about month ago) which is able to detect and fix the problem so i'm not having server outages now. The point was to NOT access anything which is stored on HDDs, the daemon is only reading info from cgroup filesystem and sending KILL signals to processes. Maybe i should be able to also read stack files before killing, i will try it.

Btw, which vanilla kernel includes this patch?

Thank you and everyone involved very much for time and help.

azur
