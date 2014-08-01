Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaHARwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:52:05 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:32658
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754577AbaHARwB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:52:01 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Aaron Lu <aaron.lu@intel.com>
CC: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, "lkp@01.org" <lkp@01.org>
Subject: Re: [LKP] [cxgb4i] INFO: suspicious RCU usage. ]
Thread-Topic: [LKP] [cxgb4i] INFO: suspicious RCU usage. ]
Thread-Index: AQHPqghfMp51Tbi8S0SSSXjRmwZPppu8DoJL
Date: Fri, 1 Aug 2014 17:51:57 +0000
Message-ID: <8a9f6239-f6a2-48dc-af51-a3e71d2d84f7@chelsio.com>
References: <53d5ad9c.fzl0M4Fc3SsHBimO%fengguang.wu@intel.com>,<53D5AFB8.3020604@intel.com>
In-Reply-To: <53D5AFB8.3020604@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



One socket to bind them all

From: Aaron Lu <aaron.lu@intel.com>
Sent: Jul 27, 2014 7:05 PM
To: Anish Bhatt
Cc: "David S. Miller" <davem@davemloft.net>;LKML;lkp@01.org
Subject: [LKP] [cxgb4i] INFO: suspicious RCU usage. ]

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 759a0cc5a3e1bc2cc48fa3c0b91bdcad8b8f87d6 ("cxgb4i: Add ipv6 code to driver, call into libcxgbi ipv6 api")



[    7.671997] Key type encrypted registered
[    7.676647]
[    7.676874] ===============================
[    7.677354] [ INFO: suspicious RCU usage. ]
[    7.677867] 3.16.0-rc6-01233-gac3d2e5 #1272 Not tainted
[    7.678466] -------------------------------
[    7.678973] include/linux/rcupdate.h:513 Illegal context switch in RCU read-side critical section!
[    7.680252]
[    7.680252] other info that might help us debug this:
[    7.680252]
[    7.681194]
[    7.681194] rcu_scheduler_active = 1, debug_locks = 1
[    7.682071] 3 locks held by swapper/1:
[    7.682667]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff87bb12fc>] rtnl_lock+0x17/0x19
[    7.683990]  #1:  (rcu_read_lock){......}, at: [<ffffffff86ca617e>] __atomic_notifier_call_chain+0x5/0x105
[    7.685606]  #2:  (rcu_read_lock){......}, at: [<ffffffff8769aa05>] cxgbi_inet6addr_handler+0x5/0x202
[    7.687150]
[    7.687150] stack backtrace:
[    7.687837] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-rc6-01233-gac3d2e5 #1272
[    7.689016]  0000000000000000 ffff880100d639f8 ffffffff87e25ccc ffff880100d63a28
[    7.690951]  ffffffff86cbc38c ffffffff885d9370 000000000000024a 0000000000000000
[    7.692164]  ffff880100c66000 ffff880100d63a50 ffffffff86cadfd4 ffffffff88ad4d90
[    7.693375] Call Trace:
[    7.693795]  [<ffffffff87e25ccc>] dump_stack+0x19/0x1b
[    7.694579]  [<ffffffff86cbc38c>] lockdep_rcu_suspicious+0xe9/0xf2
[    7.695533]  [<ffffffff86cadfd4>] __might_sleep+0x58/0x1e9
[    7.696372]  [<ffffffff87e3da83>] mutex_lock_nested+0x3b/0x3d3
[    7.697265]  [<ffffffff86caf1b6>] ? sched_clock_local.constprop.2+0x34/0xa1
[    7.698323]  [<ffffffff87690861>] cxgbi_device_find_by_netdev+0x63/0x102
[    7.699359]  [<ffffffff8769aaa1>] cxgbi_inet6addr_handler+0xa1/0x202
[    7.700380]  [<ffffffff8769aa05>] ? cxgbi_inet6addr_handler+0x5/0x202
[    7.701384]  [<ffffffff86ca60c2>] notifier_call_chain+0xf4/0x126
[    7.702322]  [<ffffffff86ca6215>] __atomic_notifier_call_chain+0x9c/0x105
[    7.703366]  [<ffffffff86ca617e>] ? __atomic_notifier_call_chain+0x5/0x105
[    7.704241]  [<ffffffff86ca6292>] atomic_notifier_call_chain+0x14/0x16
[    7.705234]  [<ffffffff87ce2e9c>] inet6addr_notifier_call_chain+0x1b/0x1d
[    7.706505]  [<ffffffff87c9f6e1>] ipv6_add_addr+0x218/0x544
[    7.707539]  [<ffffffff87c9f52e>] ? ipv6_add_addr+0x65/0x544
[    7.708484]  [<ffffffff87ca4a92>] add_addr+0x31/0x93
[    7.709420]  [<ffffffff87ca61ad>] addrconf_notify+0x65e/0x9b9
[    7.710559]  [<ffffffff87e414e2>] ? _raw_read_unlock+0x27/0x31
[    7.711523]  [<ffffffff86cba29c>] ? __lock_is_held+0x37/0x4f
[    7.712588]  [<ffffffff86ca60c2>] notifier_call_chain+0xf4/0x126
[    7.713683]  [<ffffffff86ca6487>] raw_notifier_call_chain+0x14/0x16
[    7.714706]  [<ffffffff87b9c1a1>] call_netdevice_notifiers_info+0x71/0x7a
[    7.715987]  [<ffffffff87b9f800>] call_netdevice_notifiers+0x13/0x15
[    7.717071]  [<ffffffff87ba39e6>] __dev_notify_flags+0x54/0x82
[    7.718127]  [<ffffffff87ba4039>] dev_change_flags+0x4d/0x58
[    7.719187]  [<ffffffff88d4cd83>] ip_auto_config+0x177/0xdbf
[    7.720146]  [<ffffffff86d4eee6>] ? slob_free+0x2cb/0x2d8
[    7.721173]  [<ffffffff88d4cc00>] ? root_nfs_parse_addr+0xa3/0xaf
[    7.722309]  [<ffffffff88cda08f>] ? do_one_initcall+0x98/0x1d0
[    7.723252]  [<ffffffff88d4cc0c>] ? root_nfs_parse_addr+0xaf/0xaf
[    7.724522]  [<ffffffff88cda1b2>] do_one_initcall+0x1bb/0x1d0
[    7.725547]  [<ffffffff86c9fe00>] ? param_array_set+0x82/0x11e
[    7.726539]  [<ffffffff86ca00a0>] ? parse_args+0x1a5/0x27f
[    7.727463]  [<ffffffff88cda2bf>] kernel_init_freeable+0xf8/0x17d
[    7.728598]  [<ffffffff88cd97fd>] ? initcall_blacklist+0x9f/0x9f
[    7.729585]  [<ffffffff87e0c212>] ? rest_init+0x136/0x136
[    7.730678]  [<ffffffff87e0c220>] kernel_init+0xe/0xda
[    7.731661]  [<ffffffff87e41eba>] ret_from_fork+0x7a/0xb0
[    7.732532]  [<ffffffff87e0c212>] ? rest_init+0x136/0x136
[    7.734390] IP-Config: Failed to open gretap0
[    7.735138] IP-Config: No network devices available
[    7.736057] ALSA device list:



Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Aaron
