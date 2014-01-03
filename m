Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaACNBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:01:40 -0500
Received: from plane.gmane.org ([80.91.229.3]:60485 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaACNBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:01:38 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Subject: 3.12.6 warning/lockup at kernel/workqueue.c:1587
 worker_enter_idle+0xde/0x150()
Date: Fri, 3 Jan 2014 13:01:14 +0000 (UTC)
Message-ID: <pan.2014.01.03.13.01.26@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5b006574.dip0.t-ipconnect.de
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For one of my machines the new year started with a hiccup:

Jan  1 01:55:39 tux kernel: ------------[ cut here ]------------
Jan  1 01:55:39 tux kernel: WARNING: CPU: 1 PID: 21725 at kernel/workqueue.c:1587 worker_enter_idle+0xde/0x150()
Jan  1 01:55:39 tux kernel: Modules linked in: sch_fq_codel btrfs libcrc32c xor raid6_pq nfsd auth_rpcgss oid_registry lockd sunrpc usbhid snd_hda_codec_hdmi snd_hda_codec_realtek x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd snd_hda_intel snd_hda_codec r8169 i2c_i801 snd_pcm mii i2c_core snd_page_alloc snd_timer snd video soundcore
Jan  1 01:55:39 tux kernel: CPU: 1 PID: 21725 Comm: kworker/1:1 Not tainted 3.12.6 #1
Jan  1 01:55:39 tux kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 0703 10/21/2011
Jan  1 01:55:39 tux kernel:  0000000000000009 ffff88020d599e08 ffffffff814636ef 0000000000000000
Jan  1 01:55:39 tux kernel:  ffff88020d599e40 ffffffff8103c2e3 ffff88023fa91440 ffff880221a3f830
Jan  1 01:55:39 tux kernel:  ffff8800965fe9a0 ffff88023fa91440 ffff880221a3f800 ffff88020d599e50
Jan  1 01:55:39 tux kernel: Call Trace:
Jan  1 01:55:39 tux kernel:  [<ffffffff814636ef>] dump_stack+0x45/0x56
Jan  1 01:55:39 tux kernel:  [<ffffffff8103c2e3>] warn_slowpath_common+0x73/0x90
Jan  1 01:55:39 tux kernel:  [<ffffffff8103c3b5>] warn_slowpath_null+0x15/0x20
Jan  1 01:55:39 tux kernel:  [<ffffffff810514ee>] worker_enter_idle+0xde/0x150
Jan  1 01:55:39 tux kernel:  [<ffffffff810535d8>] worker_thread+0x1a8/0x390
Jan  1 01:55:39 tux kernel:  [<ffffffff81053430>] ? manage_workers.isra.26+0x2a0/0x2a0
Jan  1 01:55:39 tux kernel:  [<ffffffff8105944b>] kthread+0xbb/0xc0
Jan  1 01:55:39 tux kernel:  [<ffffffff81059390>] ? kthread_create_on_node+0x110/0x110
Jan  1 01:55:39 tux kernel:  [<ffffffff8146e3fc>] ret_from_fork+0x7c/0xb0
Jan  1 01:55:39 tux kernel:  [<ffffffff81059390>] ? kthread_create_on_node+0x110/0x110
Jan  1 01:55:39 tux kernel: ---[ end trace 4500aee39afe638c ]---

The machine was doing pretty much nothing at the time; I only noticed the problem
when I couldn't ssh in, though pings were still coming in and out (console worked).
Apparently some thread was now stuck so going into single-user or even controlled
reboot no longer worked; I had to hit the big switch. Unkillable processes were
e.g. chrony (ntp server) and NFS.

Any insights? The box is rock solid otherwise, and the only thing out of the
ordinary is that it's running the latest BFS, which so far has not shown to be
a problem in any way, on multiple machines.

thanks,
Holger

