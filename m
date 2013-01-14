Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3ANMsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:48:01 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61770 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab3ANMr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:47:56 -0500
MIME-Version: 1.0
Date: Mon, 14 Jan 2013 13:47:55 +0100
X-Google-Sender-Auth: 6klUa8cNUTJj_Scu1t9lboomTkY
Message-ID: <CAONaPpFXoBp-5ZCXVjtKAviQ5Z9qenj_+RZHyOoMv8Ne5Z=LFg@mail.gmail.com>
Subject: [BUG RT] v3.6.11-rt25: BUG unable to handle kernel NULL pointer dereference
From: John Kacur <jkacur@redhat.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Our test systems are getting the following type of BUGs on v3.6.11-rt25 kernels

Test 1:

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff811573f1>] kmem_cache_alloc_node+0x51/0x180
PGD a2d39067 PUD b1641067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: sunrpc cpufreq_ondemand ipv6 tg3 joydev sg
serio_raw pcspkr k8temp amd64_edac_mod edac_core i2c_piix4 e100 mii
shpchp ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom sata_svw
ata_generic pata_acpi pata_serverworks radeon ttm drm_kms_helper drm
hwmon i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
CPU 3
Pid: 20878, comm: hackbench Not tainted 3.6.11-rt25.14.el6rt.x86_64 #1
empty empty/Tyan Transport GT24-B3992
RIP: 0010:[<ffffffff811573f1>]  [<ffffffff811573f1>]
kmem_cache_alloc_node+0x51/0x180
RSP: 0018:ffff8800a9b17d70  EFLAGS: 00010213
RAX: 0000000000000000 RBX: 0000000001200011 RCX: ffff8800a06d8000
RDX: 0000000004d92a03 RSI: 00000000000000d0 RDI: ffff88013b805500
RBP: ffff8800a9b17dc0 R08: ffff88023fd14d10 R09: ffffffff81041cbd
R10: 00007f4e3f06e9d0 R11: 0000000000000246 R12: ffff88013b805500
R13: ffff8801ff46af40 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f4e3f06e700(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000a2d3a000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hackbench (pid: 20878, threadinfo ffff8800a9b16000, task
ffff8800a06d8000)
Stack:
 ffff8800a9b17da0 ffffffff81202e08 ffff8800a9b17de0 000000d001200011
 0000000001200011 0000000001200011 0000000000000000 0000000000000000
 00007f4e3f06e9d0 0000000000000000 ffff8800a9b17e60 ffffffff81041cbd
Call Trace:
 [<ffffffff81202e08>] ? current_has_perm+0x68/0x80
 [<ffffffff81041cbd>] copy_process+0xdd/0x15b0
 [<ffffffff810a2125>] ? rt_up_read+0x25/0x30
 [<ffffffff8104369a>] do_fork+0x5a/0x360
 [<ffffffff8107c66b>] ? migrate_enable+0xeb/0x220
 [<ffffffff8100b068>] sys_clone+0x28/0x30
 [<ffffffff81527423>] stub_clone+0x13/0x20
 [<ffffffff81527152>] ? system_call_fastpath+0x16/0x1b
Code: 89 fc 89 75 cc 41 89 d6 4d 8b 04 24 65 4c 03 04 25 48 ae 00 00
49 8b 50 08 4d 8b 28 49 8b 40 10 4d 85 ed 74 12 41 83 fe ff 74 27 <48>
8b 00 48 c1 e8 3a 41 39 c6 74 1b 8b 75 cc 4c 89 c9 44 89 f2
RIP  [<ffffffff811573f1>] kmem_cache_alloc_node+0x51/0x180
 RSP <ffff8800a9b17d70>
CR2: 0000000000000000
---[ end trace 0000000000000002 ]---



Test 2:

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff811573f1>] kmem_cache_alloc_node+0x51/0x180
PGD 1d9a31067 PUD 223b24067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: sunrpc cpufreq_ondemand ipv6 tg3 serio_raw pcspkr
k8temp amd64_edac_mod edac_core joydev sg e100 mii i2c_piix4 shpchp
ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom sata_svw ata_generic
pata_acpi pata_serverworks radeon ttm drm_kms_helper drm hwmon
i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
CPU 1
Pid: 26603, comm: hackbench Not tainted 3.6.11-rt25.14.el6rt.x86_64 #1
empty empty/Tyan Transport GT24-B3992
RIP: 0010:[<ffffffff811573f1>]  [<ffffffff811573f1>]
kmem_cache_alloc_node+0x51/0x180
RSP: 0018:ffff880093bdbd70  EFLAGS: 00010213
RAX: 0000000000000000 RBX: 0000000001200011 RCX: ffff8800a1edde80
RDX: 000000001a29dd01 RSI: 00000000000000d0 RDI: ffff88013b805500
RBP: ffff880093bdbdc0 R08: ffff88013bd14d10 R09: ffffffff81041cbd
R10: 00007fcaec20e9d0 R11: 0000000000000246 R12: ffff88013b805500
R13: ffff8800abe95e80 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fcaec20e700(0000) GS:ffff88013bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000223c2d000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hackbench (pid: 26603, threadinfo ffff880093bda000, task
ffff8800a1edde80)
Stack:
 ffff880093bdbda0 ffffffff81202e08 ffff880081568690 000000d001200011
 0000000001200011 0000000001200011 0000000000000000 0000000000000000
 00007fcaec20e9d0 0000000000000000 ffff880093bdbe60 ffffffff81041cbd
Call Trace:
 [<ffffffff81202e08>] ? current_has_perm+0x68/0x80
 [<ffffffff81041cbd>] copy_process+0xdd/0x15b0
 [<ffffffff812069bb>] ? selinux_file_alloc_security+0x4b/0x80
 [<ffffffff8104369a>] do_fork+0x5a/0x360
 [<ffffffff8107c66b>] ? migrate_enable+0xeb/0x220
 [<ffffffff8100b068>] sys_clone+0x28/0x30
 [<ffffffff81527423>] stub_clone+0x13/0x20
 [<ffffffff81527152>] ? system_call_fastpath+0x16/0x1b
Code: 89 fc 89 75 cc 41 89 d6 4d 8b 04 24 65 4c 03 04 25 48 ae 00 00
49 8b 50 08 4d 8b 28 49 8b 40 10 4d 85 ed 74 12 41 83 fe ff 74 27 <48>
8b 00 48 c1 e8 3a 41 39 c6 74 1b 8b 75 cc 4c 89 c9 44 89 f2
RIP  [<ffffffff811573f1>] kmem_cache_alloc_node+0x51/0x180
 RSP <ffff880093bdbd70>
CR2: 0000000000000000
---[ end trace 0000000000000002 ]---
