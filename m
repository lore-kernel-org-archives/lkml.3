Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3ANJVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:21:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab3ANJVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:21:44 -0500
Message-ID: <1358155290.5631.19.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 14 Jan 2013 10:21:30 +0100
In-Reply-To: <1357985943.6796.55.camel@marge.simpson.net>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:U2SdAwJYLI6xV99zZjzuW6vEvJE8QyQRKpNF1cTabEF
 GayG56KJ0v5HcskxpyJJPqTI4qYQFSpOsrYEF/y/ZgH8fUzhCS
 +PJf49CNCbz+NI/BjeOCu1zitqfu/QOy5oS1JxIHJWM3NtpSMB
 6tEsF+FlFxgjRqzfa2RO9NEdCEait5mgeevB3/Zi9i4V/kdjQB
 6o3PLIHNLmz1buTIWnkNMc2kvpajieEqee30o+u1wh/Nmhoj6E
 2PEeR7HNYu6xbILk6flYxqKyH66wWAZ/zK5DdEOzu1dToni5sT
 ljdphbnOouAm1lC0b8uMak62+yXzYXLvN17PpSWIUON8xl51sH
 2vIvm06JNiczl3lAe9TrfSwxQYFqpwZ4UoR+Yp6VNnxF7QCnbl
 AWutckyuG+OLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-12 at 11:19 +0100, Mike Galbraith wrote:

> Hm, low end takes a big hit.

Bah, that's perturbations and knobs.

aim7 compute, three individual runs + average

Stock scheduler knobs..

3.8-wang                                    avg     3.8-virgin                          avg    vs wang
Tasks    jobs/min                      jobs/min                                    jobs/min
    1      435.97    433.48    433.48    434.31        436.91    436.60    434.41    435.97      1.003
    5     2108.56   2120.36   2153.52   2127.48       2239.47   2257.82   2285.07   2260.78      1.062
   10     4205.41   4167.81   4294.83   4222.68       4223.00   4199.58   4252.63   4225.07      1.000
   20     8511.24   8434.24   8614.07   8519.85       8523.21   8505.26   8931.47   8653.31      1.015
   40    13209.81   6389.04   5308.80   8302.55      13011.27  13131.09  13788.40  13310.25      1.603
   80    12239.33  17797.36  20438.45  16825.04      15380.71  14372.96  14080.74  13921.31       .827
  160    52638.44  52609.88  37364.16  47537.49      26644.68  44826.63  41703.23  37724.84       .793
  320   105162.69 111512.36 105909.34 107528.13     102386.48 106141.22 103424.00 103983.90       .967
  640   207290.22 207623.13 204556.96 206490.10     196673.43 193243.65 190210.89 193375.99       .936
 1280   329795.92 326739.68 328399.66 328311.75     305867.51 307931.72 305988.17 306595.80       .933
 2560   414580.44 418156.33 413035.14 415257.30     404000.00 403894.82 402428.02 403440.94       .971

Twiddled knobs..
sched_latency_ns = 24ms
sched_min_granularity_ns = 8ms
sched_wakeup_granularity_ns = 10ms

3.8-wang                                    avg     3.8-virgin                          avg    vs wang
Tasks    jobs/min                      jobs/min                                    jobs/min
    1      437.23    437.23    436.91    437.12        437.86    439.45    438.18    438.49      1.003
    5     2102.71   2121.85   2130.80   2118.45       2223.04   2165.83   2314.74   2234.53      1.054
   10     4282.69   4252.63   4378.61   4304.64       4310.10   4303.98   4310.10   4308.06      1.000
   20     8675.73   8650.96   8725.70   8684.13       8595.74   8638.63   8725.70   8653.35       .996
   40    16546.08  16512.26  16546.08  16534.80      17022.47  16798.34  16717.24  16846.01      1.018
   80    32712.55  32602.56  32493.30  32602.80      33137.39  33137.39  32890.09  33054.95      1.013
  160    63372.55  63125.00  63663.82  63387.12      64510.98  64382.47  64084.60  64326.01      1.014
  320   121885.61 122656.55 121503.76 122015.30     121124.30 121885.61 121732.58 121580.83       .996
  640   218010.12 216066.85 217034.14 217037.03     213450.74 212864.98 212282.43 212866.05       .980
 1280   332339.33 332197.00 332624.36 332386.89     325915.97 325505.67 325232.70 325551.44       .979
 2560   426901.49 426666.67 427254.20 426940.78     424448.70 425263.16 424564.86 424758.90       .994

Much better, ~no difference between kernels for this load.

Except patched 3.8-rc3 kernel crashes on reboot. 

Please stand by while rebooting the system...
[  123.104064] kvm: exiting hardware virtualization
[  123.302908] Disabling[  124.729877] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[  124.758804] IP: [<ffffffff810821f6>] wake_affine+0x26/0x2f0
[  124.785634] PGD e7089b067 PUD e736f7067 PMD 0 
[  124.810176] Oops: 0000 [#1] SMP 
[  124.829767] Modules linked in: iptable_filter ip_tables x_tables nfsv3 nfs_acl nfs fscache lockd sunrpc autofs4 edd af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod coretemp kvm_intel iTCO_wdt kvm iTCO_vendor_support i7core_edac igb ioatdma lpc_ich tpm_tis ptp crc32c_intel ipv6 joydev edac_core mfd_core pps_core dca microcode tpm hid_generic i2c_i801 tpm_bios ehci_pci acpi_memhotplug sr_mod container pcspkr sg cdrom button rtc_cmos ext3 jbd mbcache mgag200 ttm drm_kms_helper drm i2c_algo_bit sysimgblt sysfillrect i2c_core syscopyarea usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh ata_generic ata_piix libata megaraid_sas scsi_mod
[  125.093116] CPU 36 
[  125.097498] Pid: 0, comm: swapper/36 Not tainted 3.8.0-wang #58 QCI QSSC-S4R/QSSC-S4R
[  125.148934] RIP: 0010:[<ffffffff810821f6>]  [<ffffffff810821f6>] wake_affine+0x26/0x2f0
[  125.183856] RSP: 0018:ffff88046d9dfc70  EFLAGS: 00010082
[  125.213390] RAX: 0000000000000001 RBX: 0000000000000024 RCX: 0000000000000046
[  125.247203] RDX: 0000000000000000 RSI: ffff88046d946280 RDI: 0000000000000000
[  125.280734] RBP: ffff88046d9dfce8 R08: 0000000000000000 R09: 0000000000000000
[  125.317137] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88046fa53980
[  125.354487] R13: 0000000000000024 R14: 0000000000000006 R15: ffff88046d946280
[  125.391549] FS:  0000000000000000(0000) GS:ffff88046fa40000(0000) knlGS:0000000000000000
[  125.431203] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  125.465018] CR2: 0000000000000040 CR3: 0000000e712a1000 CR4: 00000000000007e0
[  125.501827] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  125.536604] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  125.570415] Process swapper/36 (pid: 0, threadinfo ffff88046d9de000, task ffff88046d9dc580)
[  125.606630] Stack:
[  125.629700]  ffffffff810895d9 ffff88046d9dfc88 ffff88046fc52f70 000000006d9462c8
[  125.664431]  0000000000000000 ffff88046d9dfcc8 ffffffff8108a004 ffff88046d9dfce8
[  125.699339]  ffffffff81086134 000000246d9dfcd8 0000000000000024 ffff88046fa53980
[  125.734981] Call Trace:
[  125.758061]  [<ffffffff810895d9>] ? enqueue_entity+0x229/0xa40
[  125.790423]  [<ffffffff8108a004>] ? enqueue_task_fair+0x214/0x560
[  125.823023]  [<ffffffff81086134>] ? select_idle_sibling+0xf4/0x120
[  125.856434]  [<ffffffff810863a9>] select_task_rq_fair+0x249/0x280
[  125.892564]  [<ffffffff8102d056>] ? native_apic_msr_write+0x36/0x40
[  125.925262]  [<ffffffff8107fbbb>] try_to_wake_up+0x12b/0x2b0
[  125.956939]  [<ffffffff8107fd4d>] default_wake_function+0xd/0x10
[  125.989521]  [<ffffffff8106d031>] autoremove_wake_function+0x11/0x40
[  126.022899]  [<ffffffff81075e1a>] __wake_up_common+0x5a/0x90
[  126.054874]  [<ffffffff810794a3>] __wake_up+0x43/0x70
[  126.085086]  [<ffffffff810e2869>] force_quiescent_state+0xe9/0x130
[  126.117469]  [<ffffffff810e420e>] rcu_prepare_for_idle+0x27e/0x480
[  126.150317]  [<ffffffff810e444d>] rcu_eqs_enter_common+0x3d/0x100
[  126.182428]  [<ffffffff810e4642>] rcu_idle_enter+0x92/0xe0
[  126.213041]  [<ffffffff8100abd8>] cpu_idle+0x78/0xd0
[  126.242939]  [<ffffffff8149bcce>] start_secondary+0x7a/0x7c
[  126.273874] Code: 00 00 00 00 00 55 48 89 e5 48 83 ec 78 4c 89 7d f8 89 55 a4 49 89 f7 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 48 89 7d a8 <8b> 47 40 65 44 8b 04 25 20 b0 00 00 89 45 c8 48 8b 46 08 48 c7 
[  126.358480] RIP  [<ffffine+0x26/0x2f0[  126.392023]  RSP <ffff88046d9dfc70>
[  126.422108] CR2: 0000000000000040


