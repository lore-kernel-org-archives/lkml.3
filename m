Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3GUOza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 10:55:30 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:45319 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755542Ab3GUOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 10:55:28 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jul 2013 10:55:28 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru A372E7F4E6
Date: Sun, 21 Jul 2013 18:48:20 +0400
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
To: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: lockdep warning in edac_create_sysfs_mci_device
Message-ID: <20130721144819.GJ24717@sanechka.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am running Linux-3.10.0 with lockdep and see following warning
in edac_create_sysfs_mci_device:

[   21.596585] BUG: key ffff8801a80ae470 not in .data!
[   21.596586] ------------[ cut here ]------------
[   21.596592] WARNING: at kernel/lockdep.c:2987 lockdep_init_map+0xfe/0x151()
[   21.596593] DEBUG_LOCKS_WARN_ON(1)
[   21.596608] Modules linked in: snd(+) mdio(+) lrw(+) iTCO_wdt(+) psmouse(+) soundcore sb_edac(+) gf128mul glue_helper iTCO_vendor_support processor(+) mtd edac_core serio_raw pcspkr joydev ioatdma(+) evdev i2c_i801 wmi lpc_ich mfd_core thermal_sys button ext4 crc16 jbd2 mbcache hid_generic sg usbhid hid sd_mod crc_t10dif isci ahci libsas libahci microcode igb libata i2c_algo_bit ehci_pci i2c_core ehci_hcd scsi_transport_sas dca usbcore ptp usb_common scsi_mod pps_core
[   21.596610] CPU: 1 PID: 727 Comm: modprobe Tainted: G        W    3.10.0-1-debug-amd64 #2
[   21.596611] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 2.0a 04/19/2013
[   21.596614]  0000000000000000 ffff88026c3e3958 ffffffff813fa22f ffff88026c3e3990
[   21.596615]  ffffffff81041287 ffff88026c3e39a0 ffff880184bccd10 ffff8801a80ae470
[   21.596617]  0000000000000000 ffff880184bccc48 ffff88026c3e39f0 ffffffff8104133e
[   21.596618] Call Trace:
[   21.596622]  [<ffffffff813fa22f>] dump_stack+0x19/0x1b
[   21.596625]  [<ffffffff81041287>] warn_slowpath_common+0x60/0x78
[   21.596627]  [<ffffffff8104133e>] warn_slowpath_fmt+0x47/0x49
[   21.596629]  [<ffffffff8108c284>] lockdep_init_map+0xfe/0x151
[   21.596630]  [<ffffffff8108af49>] debug_mutex_init+0x2e/0x39
[   21.596633]  [<ffffffff81064998>] __mutex_init+0x51/0x58
[   21.596637]  [<ffffffff812c2b03>] bus_register+0x13b/0x29f
[   21.596642]  [<ffffffffa0302b8d>] edac_create_sysfs_mci_device+0x4c/0x44c [edac_core]
[   21.596645]  [<ffffffffa0300ef2>] edac_mc_add_mc+0x9a/0x1c3 [edac_core]
[   21.596648]  [<ffffffffa0319b0a>] sbridge_probe+0x94e/0xb3a [sb_edac]
[   21.596650]  [<ffffffff8108eabb>] ? trace_hardirqs_on_caller+0x145/0x1a1
[   21.596653]  [<ffffffff81223bad>] local_pci_probe+0x39/0x61
[   21.596654]  [<ffffffff812c3f89>] ? driver_probe_device+0x1b4/0x1b4
[   21.596656]  [<ffffffff81223d43>] pci_device_probe+0xbb/0xe1
[   21.596657]  [<ffffffff812c3e6d>] driver_probe_device+0x98/0x1b4
[   21.596659]  [<ffffffff812c3fd7>] __driver_attach+0x4e/0x6f
[   21.596660]  [<ffffffff812c25bf>] bus_for_each_dev+0x57/0x8a
[   21.596663]  [<ffffffff812c3984>] driver_attach+0x19/0x1b
[   21.596664]  [<ffffffff812c362b>] bus_add_driver+0xde/0x201
[   21.596666]  [<ffffffff812c453f>] driver_register+0x8c/0x110
[   21.596668]  [<ffffffff81223211>] __pci_register_driver+0x5b/0x5e
[   21.596669]  [<ffffffffa02f7000>] ? 0xffffffffa02f6fff
[   21.596672]  [<ffffffffa02f7032>] sbridge_init+0x32/0x1000 [sb_edac]
[   21.596673]  [<ffffffffa02f7000>] ? 0xffffffffa02f6fff
[   21.596676]  [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
[   21.596677]  [<ffffffffa02f7000>] ? 0xffffffffa02f6fff
[   21.596680]  [<ffffffff8109948a>] load_module+0x1cd2/0x2004
[   21.596681]  [<ffffffff81095a03>] ? __unlink_module+0x1e/0x1e
[   21.596684]  [<ffffffff8109985e>] SyS_init_module+0xa2/0xb1
[   21.596687]  [<ffffffff81404769>] system_call_fastpath+0x16/0x1b
[   21.596688] ---[ end trace 4a6dd3f6f9dd0a92 ]---

Feel free to ask for full dmesg if you need it; I can also try a patch.

-- 
Alexandra N. Kossovsky
OKTET Labs (http://www.oktetlabs.ru/)
e-mail: sasha@oktetlabs.ru
