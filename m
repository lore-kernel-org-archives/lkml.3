Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3ILRe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:34:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59204 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab3ILRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:34:58 -0400
Date: Thu, 12 Sep 2013 10:34:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, john.johansen@canonical.com,
        apparmor@lists.ubuntu.com
Subject: Re: Linus Git (3.11.0+) - security/apparmor/include/policy.h:363
 suspicious rcu_dereference_check() usage!
Message-ID: <20130912173450.GU3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAHFgRy-dNMFgrWtz9g=MphL58ti3TSYziE-gwS6K1rwN8zJmtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHFgRy-dNMFgrWtz9g=MphL58ti3TSYziE-gwS6K1rwN8zJmtA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091217-6688-0000-0000-000001A00303
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:39:31PM -0400, Miles Lane wrote:
> [   29.804534] [ INFO: suspicious RCU usage. ]
> [   29.804539] 3.11.0+ #5 Not tainted
> [   29.804541] -------------------------------
> [   29.804545] security/apparmor/include/policy.h:363 suspicious
> rcu_dereference_check() usage!

Adding the AppArmor maintainer and list on CC, looks like one for them.

							Thanx, Paul

> [   29.804548]
> [   29.804548] other info that might help us debug this:
> [   29.804548]
> [   29.804553]
> [   29.804553] rcu_scheduler_active = 1, debug_locks = 1
> [   29.804558] 2 locks held by apparmor_parser/1268:
> [   29.804560]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff81120a4c>]
> file_start_write+0x27/0x29
> [   29.804576]  #1:  (&ns->lock){+.+.+.}, at: [<ffffffff811f5d88>]
> aa_replace_profiles+0x166/0x57c
> [   29.804589]
> [   29.804589] stack backtrace:
> [   29.804595] CPU: 0 PID: 1268 Comm: apparmor_parser Not tainted 3.11.0+ #5
> [   29.804599] Hardware name: ASUSTeK Computer Inc.         UL50VT
>          /UL50VT    , BIOS 217     03/01/2010
> [   29.804602]  0000000000000000 ffff8800b95a1d90 ffffffff8144eb9b
> ffff8800b94db540
> [   29.804611]  ffff8800b95a1dc0 ffffffff81087439 ffff880138cc3a18
> ffff880138cc3a18
> [   29.804619]  ffff8800b9464a90 ffff880138cc3a38 ffff8800b95a1df0
> ffffffff811f5084
> [   29.804628] Call Trace:
> [   29.804636]  [<ffffffff8144eb9b>] dump_stack+0x4e/0x82
> [   29.804642]  [<ffffffff81087439>] lockdep_rcu_suspicious+0xfc/0x105
> [   29.804649]  [<ffffffff811f5084>] __aa_update_replacedby+0x53/0x7f
> [   29.804655]  [<ffffffff811f5408>] __replace_profile+0x11f/0x1ed
> [   29.804661]  [<ffffffff811f6032>] aa_replace_profiles+0x410/0x57c
> [   29.804668]  [<ffffffff811f16d4>] profile_replace+0x35/0x4c
> [   29.804674]  [<ffffffff81120fa3>] vfs_write+0xad/0x113
> [   29.804680]  [<ffffffff81121609>] SyS_write+0x44/0x7a
> [   29.804687]  [<ffffffff8145bfd2>] system_call_fastpath+0x16/0x1b
> [   29.804691]
> [   29.804694] ===============================
> [   29.804697] [ INFO: suspicious RCU usage. ]
> [   29.804700] 3.11.0+ #5 Not tainted
> [   29.804703] -------------------------------
> [   29.804706] security/apparmor/policy.c:566 suspicious
> rcu_dereference_check() usage!
> [   29.804709]
> [   29.804709] other info that might help us debug this:
> [   29.804709]
> [   29.804714]
> [   29.804714] rcu_scheduler_active = 1, debug_locks = 1
> [   29.804718] 2 locks held by apparmor_parser/1268:
> [   29.804721]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff81120a4c>]
> file_start_write+0x27/0x29
> [   29.804733]  #1:  (&ns->lock){+.+.+.}, at: [<ffffffff811f5d88>]
> aa_replace_profiles+0x166/0x57c
> [   29.804744]
> [   29.804744] stack backtrace:
> [   29.804750] CPU: 0 PID: 1268 Comm: apparmor_parser Not tainted 3.11.0+ #5
> [   29.804753] Hardware name: ASUSTeK Computer Inc.         UL50VT
>          /UL50VT    , BIOS 217     03/01/2010
> [   29.804756]  0000000000000000 ffff8800b95a1d80 ffffffff8144eb9b
> ffff8800b94db540
> [   29.804764]  ffff8800b95a1db0 ffffffff81087439 ffff8800b95b02b0
> 0000000000000000
> [   29.804772]  ffff8800b9efba08 ffff880138cc3a38 ffff8800b95a1dd0
> ffffffff811f4f94
> [   29.804779] Call Trace:
> [   29.804786]  [<ffffffff8144eb9b>] dump_stack+0x4e/0x82
> [   29.804791]  [<ffffffff81087439>] lockdep_rcu_suspicious+0xfc/0x105
> [   29.804798]  [<ffffffff811f4f94>] aa_free_replacedby_kref+0x4d/0x62
> [   29.804804]  [<ffffffff811f4f47>] ? aa_put_namespace+0x17/0x17
> [   29.804810]  [<ffffffff811f4f0b>] kref_put+0x36/0x40
> [   29.804816]  [<ffffffff811f5423>] __replace_profile+0x13a/0x1ed
> [   29.804822]  [<ffffffff811f6032>] aa_replace_profiles+0x410/0x57c
> [   29.804829]  [<ffffffff811f16d4>] profile_replace+0x35/0x4c
> [   29.804835]  [<ffffffff81120fa3>] vfs_write+0xad/0x113
> [   29.804840]  [<ffffffff81121609>] SyS_write+0x44/0x7a
> [   29.804847]  [<ffffffff8145bfd2>] system_call_fastpath+0x16/0x1b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

