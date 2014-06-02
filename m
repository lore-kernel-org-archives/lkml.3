Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaFBNR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:17:28 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38902 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaFBNRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:17:25 -0400
Message-ID: <1401715040.5757.7.camel@marge.simpson.net>
Subject: nouveau + rt = boom
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 02 Jun 2014 15:17:20 +0200
In-Reply-To: <1401714764.5757.3.camel@marge.simpson.net>
References: <1401714764.5757.3.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TODO++: Rummage around in this nouveau -rt explosion.

[  178.647978] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  178.648010] IP: [<ffffffffa02ad6c2>] nouveau_fence_signal+0x52/0xd0 [nouveau]
[  178.648012] PGD 21fa60067 PUD 221b78067 PMD 0
[  178.648014] Oops: 0002 [#1] PREEMPT SMP
[  178.648018] Dumping ftrace buffer:
[  178.648021]    (ftrace buffer empty)
[  178.648045] Modules linked in: nfsd nfs_acl auth_rpcgss snd_pcm_oss snd_mixer_oss snd_seq oid_registry snd_seq_device edd nfs fscache lockd sunrpc af_packet bridge stp llc cpufreq_conservative cpufreq_ondemand cpufreq_userspace microcode cpufreq_powersave nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd nouveau ttm drm_kms_helper e1000e drm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm i2c_algo_bit snd_timer iTCO_wdt usb_storage mxm_wmi video sr_mod cdrom sg iTCO_vendor_support snd wmi lpc_ich ptp acpi_cpufreq button mfd_core pps_core i2c_i801 pcspkr soundcore thermal fan processor thermal_sys
[  178.648047] CPU: 1 PID: 4298 Comm: Xorg Not tainted 3.14.4-rt5 #26
[  178.648048] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[  178.648049] task: ffff8802201f0000 ti: ffff8802217a8000 task.ti: ffff8802217a8000
[  178.648072] RIP: 0010:[<ffffffffa02ad6c2>]  [<ffffffffa02ad6c2>] nouveau_fence_signal+0x52/0xd0 [nouveau]
[  178.648073] RSP: 0018:ffff8802217a9c88  EFLAGS: 00010202
[  178.648074] RAX: 0000000000000000 RBX: ffff8800ca64df60 RCX: 0000000000000000
[  178.648075] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[  178.648075] RBP: ffff8802217a9ca8 R08: 0000000000000000 R09: 0000000000000000
[  178.648076] R10: ffff8802201f0000 R11: 0000000000000001 R12: ffff8800ca64dea0
[  178.648077] R13: ffff880204497c50 R14: ffff880204497c40 R15: ffff88021f903048
[  178.648078] FS:  00007f9be9f2d880(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
[  178.648079] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  178.648080] CR2: 0000000000000008 CR3: 000000021f5dd000 CR4: 00000000000007e0
[  178.648081] Stack:
[  178.648083]  ffff880204497c40 ffff8802044973c0 ffff88021f903000 ffff880037a7a840
[  178.648085]  ffff8802217a9ce0 ffffffffa02ad7f8 ffff880037a7a840 ffff8800b9de6200
[  178.648087]  ffff880204497f80 ffffffffa02b2e50 ffff88021f755000 ffff8802217a9d18
[  178.648087] Call Trace:
[  178.648111]  [<ffffffffa02ad7f8>] nouveau_fence_update+0x48/0xa0 [nouveau]
[  178.648133]  [<ffffffffa02b2e50>] ? nouveau_gem_info+0xc0/0xc0 [nouveau]
[  178.648156]  [<ffffffffa02adfb0>] nouveau_fence_work+0x30/0x150 [nouveau]
[  178.648178]  [<ffffffffa02b3647>] nouveau_gem_object_close+0x137/0x1d0 [nouveau]
[  178.648190]  [<ffffffffa01628b2>] drm_gem_handle_delete+0xc2/0x120 [drm]
[  178.648199]  [<ffffffffa0162ff8>] drm_gem_close_ioctl+0x28/0x30 [drm]
[  178.648208]  [<ffffffffa0160cd2>] drm_ioctl+0x4d2/0x610 [drm]
[  178.648213]  [<ffffffff8139d4a5>] ? __pm_runtime_resume+0x35/0x60
[  178.648216]  [<ffffffff8107c84d>] ? get_parent_ip+0xd/0x50
[  178.648219]  [<ffffffff81588da9>] ? preempt_count_sub+0x49/0x50
[  178.648221]  [<ffffffff8107cd60>] ? migrate_enable+0xe0/0x1e0
[  178.648243]  [<ffffffffa02aaece>] nouveau_drm_ioctl+0x4e/0x90 [nouveau]
[  178.648245]  [<ffffffff81185ff0>] do_vfs_ioctl+0x300/0x530
[  178.648248]  [<ffffffff8158d33b>] ? sysret_check+0x1b/0x56
[  178.648250]  [<ffffffff81094996>] ? trace_hardirqs_on_caller+0x16/0x1d0
[  178.648252]  [<ffffffff81186261>] SyS_ioctl+0x41/0x80
[  178.648254]  [<ffffffff8158d316>] system_call_fastpath+0x1a/0x1f
[  178.648273] Code: 61 c0 75 0b eb 5b 0f 1f 00 4c 89 e3 49 89 d4 48 8b 35 b3 f3 81 e1 48 89 da bf 08 00 00 00 e8 d6 70 db e0 48 8b 53 40 48 8b 43 48 <48> 89 42 08 48 89 10 48 b8 00 01 10 00 00 00 ad de 48 89 43 40
[  178.648295] RIP  [<ffffffffa02ad6c2>] nouveau_fence_signal+0x52/0xd0 [nouveau]
[  178.648295]  RSP <ffff8802217a9c88>
[  178.648296] CR2: 0000000000000008


