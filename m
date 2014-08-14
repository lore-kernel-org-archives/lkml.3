Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaHNVYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:24:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52254 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaHNVYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:24:00 -0400
Date: Thu, 14 Aug 2014 23:23:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 3.17-rc0: kobject_put on uninitialied object
Message-ID: <20140814212357.GA26204@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

3.17-rc0, but I lost sources from this one. I guess I'll restart with
newer kernel and see if it happens again...
								Pavel

Aug 14 19:59:58 duo kernel: perf interrupt took too long (5749 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
Aug 14 20:04:20 duo kernel: e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
Aug 14 20:04:20 duo kernel: e1000e 0000:02:00.0 eth0: Link Speed was downgraded by SmartSpeed
Aug 14 20:04:20 duo kernel: e1000e 0000:02:00.0 eth0: 10/100 speed: disabling TSO
Aug 14 20:04:27 duo kernel: wlan0: deauthenticating from 00:11:95:05:30:d7 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug 14 20:04:27 duo kernel: cfg80211: Calling CRDA to update world regulatory domain
Aug 14 20:05:31 duo kernel: nm-connection-e[24493]: segfault at 2c ip 08073c24 sp bfd50640 error 4 in nm-connection-editor[8048000+56000]
Aug 14 21:08:23 duo kernel: ------------[ cut here ]------------
Aug 14 21:08:23 duo kernel: WARNING: CPU: 1 PID: 23996 at lib/kobject.c:670 kobject_put+0x61/0x70()
Aug 14 21:08:23 duo kernel: kobject: '(null)' (caff26b8): is not initialized, yet kobject_put() is being called.
Aug 14 21:08:23 duo kernel: Modules linked in:
Aug 14 21:08:23 duo kernel: CPU: 1 PID: 23996 Comm: umount Not tainted 3.16.0+ #390
Aug 14 21:08:23 duo kernel: Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
Aug 14 21:08:23 duo kernel: 0000029e c2fe5c44 c482b92d c4a6097c c2fe5c74 c4038f2a c4a60b2c c2fe5ca0
Aug 14 21:08:23 duo kernel: 00005dbc c4a6097c 0000029e c4282561 c4282561 dc977800 caff26b0 dc977a20
Aug 14 21:08:23 duo kernel: c2fe5c8c c4038fce 00000009 c2fe5c84 c4a60b2c c2fe5ca0 c2fe5cac c4282561
Aug 14 21:08:23 duo kernel: Call Trace:
Aug 14 21:08:23 duo kernel: [<c482b92d>] dump_stack+0x41/0x52
Aug 14 21:08:23 duo kernel: [<c4038f2a>] warn_slowpath_common+0x7a/0xa0
Aug 14 21:08:23 duo kernel: [<c4282561>] ? kobject_put+0x61/0x70
Aug 14 21:08:23 duo kernel: [<c4282561>] ? kobject_put+0x61/0x70
Aug 14 21:08:23 duo kernel: [<c4038fce>] warn_slowpath_fmt+0x2e/0x30
Aug 14 21:08:23 duo kernel: [<c4282561>] kobject_put+0x61/0x70
Aug 14 21:08:23 duo kernel: [<c4407aff>] put_device+0xf/0x20
Aug 14 21:08:23 duo kernel: [<c4426212>] scsi_host_dev_release+0xb2/0xe0
Aug 14 21:08:23 duo kernel: [<c4408207>] device_release+0x27/0x90
Aug 14 21:08:23 duo kernel: [<c40efe38>] ? cache_free_debugcheck+0x258/0x310
Aug 14 21:08:23 duo kernel: [<c42823ba>] kobject_release+0x7a/0x1c0
Aug 14 21:08:23 duo kernel: [<c4293c34>] ? debug_check_no_obj_freed+0x124/0x190
Aug 14 21:08:23 duo kernel: [<c428252f>] kobject_put+0x2f/0x70
Aug 14 21:08:23 duo kernel: [<c4407aff>] put_device+0xf/0x20
Aug 14 21:08:23 duo kernel: [<c442d8f5>] scsi_target_dev_release+0x15/0x20
Aug 14 21:08:23 duo kernel: [<c4408207>] device_release+0x27/0x90
Aug 14 21:08:23 duo kernel: [<c40efe38>] ? cache_free_debugcheck+0x258/0x310
Aug 14 21:08:23 duo kernel: [<c42823ba>] kobject_release+0x7a/0x1c0
Aug 14 21:08:23 duo kernel: [<c4293c34>] ? debug_check_no_obj_freed+0x124/0x190
Aug 14 21:08:23 duo kernel: [<c428252f>] kobject_put+0x2f/0x70
Aug 14 21:08:23 duo kernel: [<c4407aff>] put_device+0xf/0x20
Aug 14 21:08:23 duo kernel: [<c4430db0>] scsi_device_dev_release_usercontext+0xe0/0xf0
Aug 14 21:08:23 duo kernel: [<c4430cd0>] ? scsi_device_dev_release+0x20/0x20
Aug 14 21:08:23 duo kernel: [<c404dc14>] execute_in_process_context+0x74/0x80
Aug 14 21:08:23 duo kernel: [<c4430cc3>] scsi_device_dev_release+0x13/0x20
Aug 14 21:08:23 duo kernel: [<c4408207>] device_release+0x27/0x90
Aug 14 21:08:23 duo kernel: [<c42823ba>] kobject_release+0x7a/0x1c0
Aug 14 21:08:23 duo kernel: [<c42823d8>] ? kobject_release+0x98/0x1c0
Aug 14 21:08:23 duo kernel: [<c428252f>] kobject_put+0x2f/0x70
Aug 14 21:08:23 duo kernel: [<c428252f>] ? kobject_put+0x2f/0x70
Aug 14 21:08:23 duo kernel: [<c4407aff>] put_device+0xf/0x20
Aug 14 21:08:23 duo kernel: [<c44245d3>] scsi_device_put+0x33/0x50
Aug 14 21:08:23 duo kernel: [<c4433fdd>] scsi_disk_put+0x2d/0x50
Aug 14 21:08:23 duo kernel: [<c443601f>] sd_release+0x2f/0x60
Aug 14 21:08:23 duo kernel: [<c4124528>] __blkdev_put+0x138/0x170
Aug 14 21:08:23 duo kernel: [<c41244d7>] __blkdev_put+0xe7/0x170
Aug 14 21:08:23 duo kernel: [<c41245a7>] blkdev_put+0x47/0x130
Aug 14 21:08:23 duo kernel: [<c40f8b4e>] kill_block_super+0x3e/0x70
Aug 14 21:08:23 duo kernel: [<c40f8d98>] deactivate_locked_super+0x48/0x70
Aug 14 21:08:23 duo kernel: [<c40f9371>] deactivate_super+0x51/0x70
Aug 14 21:08:23 duo kernel: [<c4111c4f>] mntput_no_expire+0x12f/0x1f0
Aug 14 21:08:23 duo kernel: [<c41133c7>] ? SyS_umount+0xa7/0x430
Aug 14 21:08:23 duo kernel: [<c41133c7>] SyS_umount+0xa7/0x430
Aug 14 21:08:23 duo kernel: [<c41106d9>] ? SyS_oldumount+0x19/0x20
Aug 14 21:08:23 duo kernel: [<c41106d9>] SyS_oldumount+0x19/0x20
Aug 14 21:08:23 duo kernel: [<c483085e>] syscall_call+0x7/0x7
Aug 14 21:08:23 duo kernel: ---[ end trace 7486deb8b98bf654 ]---
Linux duo 3.16.0+ #390 SMP Mon Aug 11 11:07:27 CEST 2014 i686 GNU/Linux

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
