Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3JUMJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:09:15 -0400
Received: from services.gouders.net ([141.101.32.176]:39456 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3JUMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:09:09 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [BUG bisected] WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 21 Oct 2013 14:09:40 +0200
Message-ID: <gifvruyge3.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Simon, all,

Recently, I noticed many traces (find a sample attached) in situations
when wpa_supplicant is running but no appropriate access-point available.

I started a bisect and ended at commit 3aede78aad2a7e
(mac80211: change IBSS channel state to chandef).

Please let me know if you need more information to inspect this problem.

Best regards,

Dirk

------------------------------------------------------------------------
Oct 21 13:56:06 lena kernel: ------------[ cut here ]------------
Oct 21 13:56:06 lena kernel: WARNING: CPU: 0 PID: 1550 at net/wireless/chan.c:373 cfg80211_chandef_usable+0x30/0x15f()
Oct 21 13:56:06 lena kernel: Modules linked in: brcmsmac cordic brcmutil bcma
Oct 21 13:56:06 lena kernel: CPU: 0 PID: 1550 Comm: kworker/u4:5 Tainted: G        W    3.12.0-rc6+ #20
Oct 21 13:56:06 lena kernel: Hardware name: LENOVO 08946MG/MoutCook, BIOS 33CN14WW        05/10/2010
Oct 21 13:56:06 lena kernel: Workqueue: phy0 ieee80211_iface_work
Oct 21 13:56:06 lena kernel: 0000000000000000 0000000000000009 ffffffff8161e3c7 0000000000000000
Oct 21 13:56:06 lena kernel: ffffffff81068b00 ffff88006f8be7c0 ffffffff815e79e4 0000000000000000
Oct 21 13:56:06 lena kernel: 000000000000000f ffff8800703e5dc2 ffff8800703e5d50 ffff88006f8bc200
Oct 21 13:56:06 lena kernel: Call Trace:
Oct 21 13:56:06 lena kernel: [<ffffffff8161e3c7>] ? dump_stack+0x50/0x80
Oct 21 13:56:06 lena kernel: [<ffffffff81068b00>] ? warn_slowpath_common+0x73/0x8b
Oct 21 13:56:06 lena kernel: [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
Oct 21 13:56:06 lena kernel: [<ffffffff815e79e4>] ? cfg80211_chandef_usable+0x30/0x15f
Oct 21 13:56:06 lena kernel: [<ffffffff815f7c2e>] ? __ieee80211_sta_join_ibss+0x162/0x6e2
Oct 21 13:56:06 lena kernel: [<ffffffff8161b8cd>] ? printk+0x4f/0x54
Oct 21 13:56:06 lena kernel: [<ffffffff815f8439>] ? ieee80211_sta_create_ibss+0xc8/0xce
Oct 21 13:56:06 lena kernel: [<ffffffff815f91ed>] ? ieee80211_ibss_work+0x255/0x3c5
Oct 21 13:56:06 lena kernel: [<ffffffff8107addb>] ? process_one_work+0x1c7/0x2e6
Oct 21 13:56:06 lena kernel: [<ffffffff81078c58>] ? pwq_activate_delayed_work+0x1e/0x28
Oct 21 13:56:06 lena kernel: [<ffffffff8107b346>] ? worker_thread+0x1cb/0x2c4
Oct 21 13:56:06 lena kernel: [<ffffffff8107b17b>] ? rescuer_thread+0x25c/0x25c
Oct 21 13:56:06 lena kernel: [<ffffffff8107ff37>] ? kthread+0xad/0xb5
Oct 21 13:56:06 lena kernel: [<ffffffff81080000>] ? kthread_create_on_node+0xc1/0x115
Oct 21 13:56:06 lena kernel: [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
Oct 21 13:56:06 lena kernel: [<ffffffff816247bc>] ? ret_from_fork+0x7c/0xb0
Oct 21 13:56:06 lena kernel: [<ffffffff8107fe8a>] ? kthread_freezable_should_stop+0x3b/0x3b
Oct 21 13:56:06 lena kernel: ---[ end trace ade89af8f1b5d90f ]---
------------------------------------------------------------------------
