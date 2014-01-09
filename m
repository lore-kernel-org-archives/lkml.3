Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaAIIaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:30:14 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61803 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaAIIaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:30:05 -0500
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 00:30:04 -0800
Message-ID: <CAFWViek=Ck6_VFhfi9_TKdHT79YAueNacyGNFoWAkR=roK2fAQ@mail.gmail.com>
Subject: PROBLEM: System hangs after resuming from standby on 3.13
From: Tigran Gabrielyan <tigrangab@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 3.13 (from https://aur.archlinux.org/packages/linux-mainline/)
is causing my laptop to hang when resuming from standby (does not
happen always). I get a black screen that is not responsive and I have
to do a hard reset.

>From rc1 through 4 or 5, the problem occurred every time on second
resume (first resume worked fine). From rc 6-7 its not as easily
reproducible but it still happens. I did not have this issue in
previous kernel versions.

I am running Arch on a Samsung RV515 laptop using open-source radeon driver.

# boot params
radeon.dpm=1

# System log
Jan 08 20:40:26 tigran-laptop.local kernel: ACPI: Preparing to enter
system sleep state S3
Jan 08 20:40:26 tigran-laptop.local kernel: [Firmware Bug]: ACPI: BIOS
_OSI(Linux) query ignored
Jan 08 20:40:26 tigran-laptop.local kernel: PM: Saving platform NVS memory
Jan 08 20:40:26 tigran-laptop.local kernel: Disabling non-boot CPUs ...
Jan 08 20:40:26 tigran-laptop.local kernel: kvm: disabling
virtualization on CPU1
Jan 08 20:40:26 tigran-laptop.local kernel: smpboot: CPU 1 is now offline
Jan 08 20:40:26 tigran-laptop.local kernel: ACPI: Low-level resume complete
Jan 08 20:40:26 tigran-laptop.local kernel: PM: Restoring platform NVS memory
Jan 08 20:40:26 tigran-laptop.local kernel: microcode: CPU0: new
patch_level=0x05000029
Jan 08 20:40:26 tigran-laptop.local kernel: Enabling non-boot CPUs ...
Jan 08 20:40:26 tigran-laptop.local kernel: x86: Booting SMP configuration:
Jan 08 20:40:26 tigran-laptop.local kernel: smpboot: Booting Node 0
Processor 1 APIC 0x1
Jan 08 20:40:26 tigran-laptop.local kernel: LVT offset 0 assigned for
vector 0x400
Jan 08 20:40:26 tigran-laptop.local kernel: kvm: enabling virtualization on CPU1
Jan 08 20:40:26 tigran-laptop.local kernel: microcode: CPU1: new
patch_level=0x05000029
Jan 08 20:40:26 tigran-laptop.local kernel: CPU1 is up
Jan 08 20:40:26 tigran-laptop.local kernel: ACPI: Waking up from
system sleep state S3
Jan 08 20:40:26 tigran-laptop.local kernel: PM: noirq resume of
devices complete after 91.212 msecs
Jan 08 20:40:26 tigran-laptop.local kernel: PM: early resume of
devices complete after 0.417 msecs
Jan 08 20:40:26 tigran-laptop.local kernel: snd_hda_intel
0000:00:01.1: irq 42 for MSI/MSI-X
Jan 08 20:40:26 tigran-laptop.local kernel: pcieport 0000:00:15.2:
System wakeup disabled by ACPI
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] PCIE GART of 1024M
enabled (table at 0x0000000000273000).
Jan 08 20:40:26 tigran-laptop.local kernel: radeon 0000:00:01.0: WB enabled
Jan 08 20:40:26 tigran-laptop.local kernel: radeon 0000:00:01.0: fence
driver on ring 0 use gpu addr 0x0000000010000c00 and cpu addr
0xffff880037fe9c00
Jan 08 20:40:26 tigran-laptop.local kernel: radeon 0000:00:01.0: fence
driver on ring 3 use gpu addr 0x0000000010000c0c and cpu addr
0xffff880037fe9c0c
Jan 08 20:40:26 tigran-laptop.local kernel: radeon 0000:00:01.0: fence
driver on ring 5 use gpu addr 0x0000000000072118 and cpu addr
0xffffc90011db2118
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] ring test on 0
succeeded in 1 usecs
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] ring test on 3
succeeded in 1 usecs
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] ring test on 5
succeeded in 1 usecs
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] UVD initialized successfully.
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] Enabling audio 0 support
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] ib test on ring 0
succeeded in 0 usecs
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] ib test on ring 3
succeeded in 1 usecs
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] ib test on ring 5 succeeded
Jan 08 20:40:26 tigran-laptop.local kernel: [drm] Found smc ucode
version: 0x00010200
Jan 08 20:40:26 tigran-laptop.local kernel: usb 2-4: reset high-speed
USB device number 2 using ehci-pci
Jan 08 20:40:26 tigran-laptop.local kernel: ata4: SATA link down
(SStatus 0 SControl 300)
Jan 08 20:40:26 tigran-laptop.local kernel: ata6: SATA link down
(SStatus 0 SControl 300)
Jan 08 20:40:26 tigran-laptop.local kernel: ata5: SATA link down
(SStatus 0 SControl 300)
Jan 08 20:40:26 tigran-laptop.local kernel: ata3: SATA link down
(SStatus 0 SControl 300)
Jan 08 20:40:26 tigran-laptop.local kernel: switching from power state:
Jan 08 20:40:26 tigran-laptop.local kernel:         ui class: none
Jan 08 20:40:26 tigran-laptop.local kernel:         internal class: boot
Jan 08 20:40:26 tigran-laptop.local kernel:         caps:
Jan 08 20:40:26 tigran-laptop.local kernel:         uvd    vclk: 0 dclk: 0
Jan 08 20:40:26 tigran-laptop.local kernel:                 power
level 0    sclk: 20000 vddc: 963
Jan 08 20:40:26 tigran-laptop.local kernel:         status: c b
Jan 08 20:40:26 tigran-laptop.local kernel: switching to power state:
Jan 08 20:40:26 tigran-laptop.local kernel:         ui class: performance
Jan 08 20:40:26 tigran-laptop.local kernel:         internal class: none
Jan 08 20:40:26 tigran-laptop.local kernel:         caps:
Jan 08 20:40:26 tigran-laptop.local kernel:         uvd    vclk: 0 dclk: 0
Jan 08 20:40:26 tigran-laptop.local kernel:                 power
level 0    sclk: 27827 vddc: 888
Jan 08 20:40:26 tigran-laptop.local kernel:                 power
level 1    sclk: 49231 vddc: 963
Jan 08 20:40:26 tigran-laptop.local kernel:         status: r
Jan 08 20:40:26 tigran-laptop.local kernel: ata2: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Jan 08 20:40:26 tigran-laptop.local kernel: ata2.00: configured for UDMA/100
Jan 08 20:40:26 tigran-laptop.local kernel: ata1: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Jan 08 20:40:26 tigran-laptop.local kernel: ata1.00: configured for UDMA/133
Jan 08 20:40:26 tigran-laptop.local kernel: sd 0:0:0:0: [sda] Starting disk
Jan 08 20:40:26 tigran-laptop.local kernel: PM: resume of devices
complete after 2960.285 msecs
Jan 08 20:40:26 tigran-laptop.local kernel: PM: Finishing wakeup.
Jan 08 20:40:26 tigran-laptop.local kernel: Restarting tasks ... done.
Jan 08 20:40:26 tigran-laptop.local kernel: video LNXVIDEO:01:
Restoring backlight state
Jan 08 20:40:26 tigran-laptop.local kernel: IPv6: ADDRCONF(NETDEV_UP):
wifi0: link is not ready
Jan 08 20:40:26 tigran-laptop.local kernel: r8169 0000:05:00.0 net0: link down
Jan 08 20:40:26 tigran-laptop.local kernel: IPv6: ADDRCONF(NETDEV_UP):
net0: link is not ready
Jan 08 20:40:28 tigran-laptop.local kernel: wifi0: authenticate with
14:35:8b:0f:b9:c0
Jan 08 20:40:28 tigran-laptop.local kernel: wifi0: send auth to
14:35:8b:0f:b9:c0 (try 1/3)
Jan 08 20:40:28 tigran-laptop.local kernel: wifi0: authenticated
Jan 08 20:40:28 tigran-laptop.local kernel: wifi0: associate with
14:35:8b:0f:b9:c0 (try 1/3)
Jan 08 20:40:28 tigran-laptop.local kernel: wifi0: RX AssocResp from
14:35:8b:0f:b9:c0 (capab=0x411 status=0 aid=2)
Jan 08 20:40:28 tigran-laptop.local kernel: wifi0: associated
Jan 08 20:40:28 tigran-laptop.local kernel: IPv6:
ADDRCONF(NETDEV_CHANGE): wifi0: link becomes ready
Jan 08 20:42:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:42:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:42:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:42:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:42:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:42:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:42:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:42:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:42:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:42:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:44:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:44:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:44:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:44:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:44:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:44:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:44:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:44:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:44:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:44:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:45:59 tigran-laptop.local kernel: wifi0: deauthenticating
from 14:35:8b:0f:b9:c0 by local choice (reason=3)
Jan 08 20:46:00 tigran-laptop.local kernel: cfg80211: Calling CRDA to
update world regulatory domain
Jan 08 20:46:01 tigran-laptop.local kernel: wifi0: authenticate with
Jan 08 20:46:01 tigran-laptop.local kernel: wifi0: send auth to  (try 1/3)
Jan 08 20:46:01 tigran-laptop.local kernel: wifi0: authenticated
Jan 08 20:46:01 tigran-laptop.local kernel: wifi0: associate with e (try 1/3)
Jan 08 20:46:01 tigran-laptop.local kernel: wifi0: RX AssocResp from
(capab=0x431 status=0 aid=9)
Jan 08 20:46:01 tigran-laptop.local kernel: wifi0: associated
Jan 08 20:46:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:46:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:46:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:46:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:46:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:46:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:46:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:46:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:46:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:46:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:48:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:48:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:48:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:48:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:48:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:48:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:48:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:48:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:48:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:48:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:50:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:50:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:50:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:50:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:50:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:50:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:50:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:50:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:50:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:50:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:52:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:52:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:52:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:52:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:52:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:52:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:52:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:52:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:52:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:52:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:54:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:54:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:54:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:54:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:54:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:54:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:54:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:54:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:54:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:54:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:56:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:56:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:56:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:56:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:56:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:56:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:56:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:56:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:56:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:56:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:58:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 20:58:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 20:58:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 20:58:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 20:58:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 20:58:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 20:58:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 20:58:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 20:58:59 tigran-laptop.local kernel: Call Trace:
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 20:58:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 21:00:59 tigran-laptop.local kernel: INFO: task
kworker/u4:45:4273 blocked for more than 120 seconds.
Jan 08 21:00:59 tigran-laptop.local kernel:       Not tainted
3.13.0-1-mainline #1
Jan 08 21:00:59 tigran-laptop.local kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 08 21:00:59 tigran-laptop.local kernel: kworker/u4:45   D
0000000000000246     0  4273      2 0x00000000
Jan 08 21:00:59 tigran-laptop.local kernel: Workqueue: hd-audio0
hdmi_repoll_eld [snd_hda_codec_hdmi]
Jan 08 21:00:59 tigran-laptop.local kernel:  ffff880079619b68
0000000000000046 ffff88020dcb4800 ffff880079619fd8
Jan 08 21:00:59 tigran-laptop.local kernel:  0000000000014400
0000000000014400 ffff88020dcb4800 ffff880079619ac0
Jan 08 21:00:59 tigran-laptop.local kernel:  ffffffff8129bf04
ffff880231d6b800 0000000000000000 ffff880233bba600
Jan 08 21:00:59 tigran-laptop.local kernel: Call Trace:
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff8129bf04>] ?
delay_tsc+0x64/0xc0
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff8129bddf>] ?
__delay+0xf/0x20
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff8129be1e>] ?
__const_udelay+0x2e/0x30
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa06c3031>] ?
snd_hda_power_save+0x71/0x2f0 [snd_hda_codec]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa06c3381>] ?
codec_exec_verb+0xd1/0x290 [snd_hda_codec]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff814f6cf9>]
schedule+0x29/0x70
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff814f70f6>]
schedule_preempt_disabled+0x16/0x20
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff814f954d>]
__mutex_lock_slowpath+0x13d/0x390
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff814f97b2>]
mutex_lock+0x12/0x22
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3a9>]
hdmi_present_sense+0x49/0x360 [snd_hda_codec_hdmi]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff814f936e>] ?
mutex_unlock+0xe/0x10
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa0a6e7fa>]
generic_hdmi_resume+0x5a/0x70 [snd_hda_codec_hdmi]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa06c2f19>]
hda_call_codec_resume+0x179/0x1e0 [snd_hda_codec]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa06c31d8>]
snd_hda_power_save+0x218/0x2f0 [snd_hda_codec]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa06c3317>]
codec_exec_verb+0x67/0x290 [snd_hda_codec]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa06c359f>]
snd_hda_codec_read+0x5f/0x90 [snd_hda_codec]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa0a6ff29>]
snd_hdmi_get_eld_ati+0x39/0x46b [snd_hda_codec_hdmi]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa0a6d5cc>]
atihdmi_pin_get_eld+0x3c/0x40 [snd_hda_codec_hdmi]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa0a6e3ea>]
hdmi_present_sense+0x8a/0x360 [snd_hda_codec_hdmi]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffffa0a6e6ed>]
hdmi_repoll_eld+0x2d/0x50 [snd_hda_codec_hdmi]
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff8107c5d7>]
process_one_work+0x167/0x420
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff8107cfa1>]
worker_thread+0x121/0x3a0
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff8107ce80>] ?
manage_workers.isra.23+0x2a0/0x2a0
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff81083662>]
kthread+0xd2/0xf0
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff8150253c>]
ret_from_fork+0x7c/0xb0
Jan 08 21:00:59 tigran-laptop.local kernel:  [<ffffffff81083590>] ?
kthread_create_on_node+0x180/0x180
Jan 08 21:32:57 tigran-laptop.local kernel: psmouse serio1: Touchpad
at isa0060/serio1/input0 lost sync at byte 6
Jan 08 21:32:57 tigran-laptop.local kernel: psmouse serio1: Touchpad
at isa0060/serio1/input0 - driver resynced.
Jan 08 21:34:28 tigran-laptop.local kernel: psmouse serio1: Touchpad
at isa0060/serio1/input0 lost sync at byte 6
Jan 08 21:34:28 tigran-laptop.local kernel: psmouse serio1: Touchpad
at isa0060/serio1/input0 - driver resynced.
Jan 08 21:44:50 tigran-laptop.local kernel: psmouse serio1: Touchpad
at isa0060/serio1/input0 lost sync at byte 6
Jan 08 21:44:50 tigran-laptop.local kernel: psmouse serio1: Touchpad
at isa0060/serio1/input0 - driver resynced.

# lscpi
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 14h
Processor Root Complex
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32

00:01.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Wrestler [Radeon HD 6310] (prog-if 00 [VGA controller])
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 41
Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
Region 1: I/O ports at f000 [size=256]
Region 2: Memory at feb00000 (32-bit, non-prefetchable) [size=256K]
Expansion ROM at <unassigned> [disabled]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0100c  Data: 4191
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: radeon
Kernel modules: radeon

00:01.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Wrestler HDMI Audio
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 42
Region 0: Memory at feb44000 (32-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0300c  Data: 41c1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: snd_hda_intel
Kernel modules: snd_hda_intel

00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 14h
Processor Root Port (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 00001000-00001fff
Memory behind bridge: d0100000-d02fffff
Prefetchable memory behind bridge: 00000000d0300000-00000000d04fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #247, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] Device 1234
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport
Kernel modules: shpchp

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32
Interrupt: pin A routed to IRQ 19
Region 0: I/O ports at f140 [size=8]
Region 1: I/O ports at f130 [size=4]
Region 2: I/O ports at f120 [size=8]
Region 3: I/O ports at f110 [size=4]
Region 4: I/O ports at f100 [size=16]
Region 5: Memory at feb4d000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [70] SATA HBA v1.0 InCfgSpace
Capabilities: [a4] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ahci
Kernel modules: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at feb4c000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at feb4b000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci
Kernel modules: ehci_pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at feb4a000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at feb49000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci
Kernel modules: ehci_pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller (rev 42)
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Kernel driver in use: piix4_smbus
Kernel modules: i2c_piix4, sp5100_tco

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
Azalia (Intel HDA) (rev 40)
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at feb40000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: snd_hda_intel
Kernel modules: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI
to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64
Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: fff00000-000fffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin C routed to IRQ 18
Region 0: Memory at feb48000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:15.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal
decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
I/O behind bridge: 00002000-00002fff
Memory behind bridge: fea00000-feafffff
Prefetchable memory behind bridge: 00000000d0500000-00000000d06fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0000
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport
Kernel modules: shpchp

00:15.1 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1) (prog-if 00 [Normal
decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
I/O behind bridge: 00003000-00003fff
Memory behind bridge: d0700000-d08fffff
Prefetchable memory behind bridge: 00000000d0900000-00000000d0afffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #247, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0000
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport
Kernel modules: shpchp

00:15.2 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI
to PCI bridge (PCIE port 2) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: d0b00000-d0efffff
Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0000
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport
Kernel modules: shpchp

00:15.3 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI
to PCI bridge (PCIE port 3) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
I/O behind bridge: 00004000-00004fff
Memory behind bridge: d0f00000-d10fffff
Prefetchable memory behind bridge: 00000000d1100000-00000000d12fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #247, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0000
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport
Kernel modules: shpchp

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 0 (rev 43)
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 1
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 2
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 3
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [f0] Secure device <?>
Kernel driver in use: k10temp
Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 4
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 6
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 5
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h
Processor Function 7
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

03:00.0 Network controller: Qualcomm Atheros AR9285 Wireless Network
Adapter (PCI-Express) (rev 01)
Subsystem: Foxconn International, Inc. Device e025
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
Capabilities: [170 v1] Power Budgeting <?>
Kernel driver in use: ath9k
Kernel modules: ath9k

05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
Subsystem: Samsung Electronics Co Ltd Device c589
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 40
Region 0: I/O ports at e000 [size=256]
Region 2: Memory at d0004000 (64-bit, prefetchable) [size=4K]
Region 4: Memory at d0000000 (64-bit, prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0300c  Data: 4181
Capabilities: [70] Express (v2) Endpoint, MSI 01
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 4096 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
Vector table: BAR=4 offset=00000000
PBA: BAR=4 offset=00000800
Capabilities: [d0] Vital Product Data
No end tag found
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
Kernel driver in use: r8169
Kernel modules: r8169

# Modules
fuse 76910 3 - Live 0xffffffffa0a8c000
ctr 3831 1 - Live 0xffffffffa0a88000
ccm 7894 1 - Live 0xffffffffa0a83000
uvcvideo 72836 0 - Live 0xffffffffa0a6b000
videobuf2_vmalloc 3304 1 uvcvideo, Live 0xffffffffa0a67000
videobuf2_memops 2335 1 videobuf2_vmalloc, Live 0xffffffffa0a63000
videobuf2_core 28243 1 uvcvideo, Live 0xffffffffa0a57000
videodev 111936 2 uvcvideo,videobuf2_core, Live 0xffffffffa0a2e000
media 11719 2 uvcvideo,videodev, Live 0xffffffffa0a26000
snd_hda_codec_realtek 44676 1 - Live 0xffffffffa0a15000
arc4 2000 2 - Live 0xffffffffa0a11000
snd_hda_codec_hdmi 36187 1 - Live 0xffffffffa0a03000
ath9k 97400 0 - Live 0xffffffffa09e1000
ath9k_common 1874 1 ath9k, Live 0xffffffffa09dd000
ath9k_hw 397620 2 ath9k,ath9k_common, Live 0xffffffffa096b000
joydev 9631 0 - Live 0xffffffffa0964000
ath 18909 3 ath9k,ath9k_common,ath9k_hw, Live 0xffffffffa095b000
mac80211 475321 1 ath9k, Live 0xffffffffa08be000
samsung_laptop 8561 0 - Live 0xffffffffa08b5000
cfg80211 408071 3 ath9k,ath,mac80211, Live 0xffffffffa0823000
rfkill 15651 5 samsung_laptop,cfg80211, Live 0xffffffffa081a000
kvm_amd 52215 0 - Live 0xffffffffa07f4000
kvm 396285 1 kvm_amd, Live 0xffffffffa06ec000
microcode 15216 0 - Live 0xffffffffa06dc000
snd_hda_intel 37352 5 - Live 0xffffffffa06ba000
snd_hda_codec 150145 3
snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_intel, Live
0xffffffffa064a000
psmouse 87437 0 - Live 0xffffffffa062b000
pcspkr 2027 0 - Live 0xffffffffa0627000
evdev 11045 13 - Live 0xffffffffa0620000
r8169 58423 0 - Live 0xffffffffa060a000
mii 4027 1 r8169, Live 0xffffffffa0606000
snd_hwdep 6332 1 snd_hda_codec, Live 0xffffffffa05fa000
snd_pcm 77822 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0xffffffffa05be000
serio_raw 5009 0 - Live 0xffffffffa05b9000
radeon 1303151 3 - Live 0xffffffffa0447000
k10temp 3050 0 - Live 0xffffffffa0443000
snd_page_alloc 7298 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0437000
snd_timer 18718 1 snd_pcm, Live 0xffffffffa0423000
snd 59093 17 snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa03f1000
soundcore 5418 1 snd, Live 0xffffffffa03e5000
ttm 65027 1 radeon, Live 0xffffffffa03ca000
drm_kms_helper 35710 1 radeon, Live 0xffffffffa03ba000
shpchp 25425 0 - Live 0xffffffffa03ae000
thermal 8556 0 - Live 0xffffffffa03a7000
ac 3334 0 - Live 0xffffffffa03a3000
sp5100_tco 5816 0 - Live 0xffffffffa039d000
i2c_piix4 10584 0 - Live 0xffffffffa0396000
battery 6829 0 - Live 0xffffffffa0390000
video 11425 1 samsung_laptop, Live 0xffffffffa0388000
button 4605 0 - Live 0xffffffffa0376000
drm 239294 5 radeon,ttm,drm_kms_helper, Live 0xffffffffa031f000
i2c_algo_bit 5391 1 radeon, Live 0xffffffffa031a000
i2c_core 24324 6
videodev,radeon,drm_kms_helper,i2c_piix4,drm,i2c_algo_bit, Live
0xffffffffa030d000
acpi_cpufreq 10215 0 - Live 0xffffffffa0306000
processor 24620 3 acpi_cpufreq, Live 0xffffffffa02f9000
ext4 473451 2 - Live 0xffffffffa0261000
crc16 1359 1 ext4, Live 0xffffffffa025d000
mbcache 6074 1 ext4, Live 0xffffffffa0257000
jbd2 81040 1 ext4, Live 0xffffffffa0237000
sr_mod 14962 0 - Live 0xffffffffa022f000
cdrom 34880 1 sr_mod, Live 0xffffffffa0221000
sd_mod 31361 4 - Live 0xffffffffa0214000
ahci 23016 3 - Live 0xffffffffa0208000
libahci 21666 1 ahci, Live 0xffffffffa01fc000
libata 171688 2 ahci,libahci, Live 0xffffffffa01b7000
ohci_pci 4000 0 - Live 0xffffffffa01af000
ohci_hcd 23897 1 ohci_pci, Live 0xffffffffa01a5000
ehci_pci 3928 0 - Live 0xffffffffa019d000
ehci_hcd 62987 1 ehci_pci, Live 0xffffffffa0187000
scsi_mod 132250 3 sr_mod,sd_mod,libata, Live 0xffffffffa0110000
usbcore 180845 5 uvcvideo,ohci_pci,ohci_hcd,ehci_pci,ehci_hcd, Live
0xffffffffa0008000
usb_common 1648 1 usbcore, Live 0xffffffffa0000000
