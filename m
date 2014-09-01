Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaIAWih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:38:37 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62945 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaIAWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:38:35 -0400
Date: Mon, 1 Sep 2014 23:42:24 +0100
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [3.17-rc3] Warning in ieee80211_can_queue_work
Message-ID: <20140901224224.GA3885@linux-g29b.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using the kernel 3.17-rc3 which I compiled today and
I get the warning below right before suspending to RAM:

[   37.856537] ------------[ cut here ]------------
[   37.856559] WARNING: CPU: 3 PID: 43 at /home/mafra/linux-2.6/net/mac80211/util.c:716 ieee80211_can_queue_work.isra.38+0x2d/0x40 [mac80211]()
[   37.856559] queueing ieee80211 work while going to suspend
[   37.856575] Modules linked in: ctr ccm nls_iso8859_1 nls_cp437 vfat fat arc4 b43 mac80211 snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic snd_hda_intel snd_hda_controller cfg80211 snd_hda_codec snd_hwdep x86_pkg_temp_thermal snd_pcm crc32c_intel ghash_clmulni_intel uvcvideo rfkill videobuf2_core bcm5974 ssb videobuf2_vmalloc videobuf2_memops snd_timer rtc_cmos
[   37.856577] CPU: 3 PID: 43 Comm: kworker/3:1 Not tainted 3.17.0-rc3 #44
[   37.856578] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
[   37.856583] Workqueue: events led_work_function
[   37.856586]  0000000000000009 ffff88026409fd18 ffffffff816f6176 ffff88026409fd60
[   37.856587]  ffff88026409fd50 ffffffff81067343 ffff880263920660 ffff8802639222f0
[   37.856589]  0000000000000000 0000000000000000 ffff88026f391300 ffff88026409fdb0
[   37.856589] Call Trace:
[   37.856594]  [<ffffffff816f6176>] dump_stack+0x4d/0x6f
[   37.856598]  [<ffffffff81067343>] warn_slowpath_common+0x73/0x90
[   37.856600]  [<ffffffff810673a7>] warn_slowpath_fmt+0x47/0x50
[   37.856604]  [<ffffffff81091abc>] ? put_prev_entity+0x2c/0x3b0
[   37.856606]  [<ffffffff81094957>] ? pick_next_task_fair+0x1f7/0x8a0
[   37.856615]  [<ffffffffa015a75d>] ieee80211_can_queue_work.isra.38+0x2d/0x40 [mac80211]
[   37.856622]  [<ffffffffa015a790>] ieee80211_queue_work+0x20/0x40 [mac80211]
[   37.856630]  [<ffffffffa01e4947>] b43_led_brightness_set+0x27/0x30 [b43]
[   37.856632]  [<ffffffff815d0d93>] led_work_function+0x113/0x130
[   37.856634]  [<ffffffff8107bf46>] process_one_work+0x166/0x390
[   37.856636]  [<ffffffff8107c51b>] worker_thread+0x11b/0x490
[   37.856638]  [<ffffffff8107c400>] ? rescuer_thread+0x290/0x290
[   37.856641]  [<ffffffff81080f1d>] kthread+0xcd/0xf0
[   37.856643]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
[   37.856645]  [<ffffffff816fe62c>] ret_from_fork+0x7c/0xb0
[   37.856647]  [<ffffffff81080e50>] ? kthread_create_on_node+0x170/0x170
[   37.856649] ---[ end trace 01a2610015279813 ]---


The reason for such an early suspend (37 seconds after booting) is
related to another issue which I hope to describe in another email but
which is "fixed" by a suspend cycle.

The wireless seems to be working fine right now though, using the 'b43'
module.

I'm not sure if the warning is new in 3.17-rcX since I haven't tested
the previous releases for a while (sorry), but I can test patches.

The kernel config and dmesg are here:

http://damtp.cam.ac.uk/user/crm66/dmesg-3.17-rc3.txt
http://damtp.cam.ac.uk/user/crm66/config-3.17-rc2+
