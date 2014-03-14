Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaCNFsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:48:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53833 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbaCNFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:48:44 -0400
X-Sasl-enc: TYUc4HkDefM7uu2BjIuWOYM4Kf7+Gj9qNxHh114C0zfT 1394776123
Message-ID: <53229836.60406@fastmail.fm>
Date: Fri, 14 Mar 2014 13:48:38 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131204 Thunderbird/17.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops in follow_page_mask when running 3.14.0-rc6-next-20140312-smp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

last night I ran into an oops on -next-20140312. Hasn't occurred again since and I don't have a clue on how to reproduce it either. Anyway, here it goes:

===================================================================================
Mar 13 21:07:00 darkstar kernel: [10579.371582] BUG: unable to handle kernel NULL pointer dereference at 00000010
Mar 13 21:07:00 darkstar kernel: [10579.371651] IP: [<c111b057>] follow_page_mask+0x27/0x440
Mar 13 21:07:00 darkstar kernel: [10579.371701] *pdpt = 0000000034a06001 *pde = 0000000000000000 
Mar 13 21:07:00 darkstar kernel: [10579.371747] Oops: 0000 [#1] SMP 
Mar 13 21:07:00 darkstar kernel: [10579.371778] Modules linked in: ipv6 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables cpufreq_ondemand speedstep_lib lp ppdev parport_pc parport fuse usb_storage btusb bluetooth uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev joydev i915 coretemp iwldvm drm_kms_helper drm sdhci_pci acer_wmi sparse_keymap video thermal mac80211 acpi_cpufreq processor i2c_i801 intel_agp thermal_sys r8169 mii sdhci iwlwifi snd_hda_codec_realtek snd_hda_codec_generic hwmon intel_gtt mxm_wmi lpc_ich jmb38x_ms mmc_core cfg80211 memstick i2c_algo_bit i2c_core snd_hda_intel snd_hda_controller snd_hda_codec wmi agpgart ehci_pci uhci_hcd ehci_hcd rfkill snd_hwdep psmouse snd_pcm snd_timer snd soundcore serio_raw microcode evdev button battery ac loop
Mar 13 21:07:00 darkstar kernel: [10579.372004] CPU: 1 PID: 3976 Comm: ps Not tainted 3.14.0-rc6-next-20140312-smp #8
Mar 13 21:07:00 darkstar kernel: [10579.372004] Hardware name: Acer       Aspire 2930     /Aspire 2930     , BIOS V1.14 11/11/2008
Mar 13 21:07:00 darkstar kernel: [10579.372004] task: eb7d4440 ti: efdc8000 task.ti: efdc8000
Mar 13 21:07:00 darkstar kernel: [10579.372004] EIP: 0060:[<c111b057>] EFLAGS: 00010213 CPU: 1
Mar 13 21:07:00 darkstar kernel: [10579.372004] EIP is at follow_page_mask+0x27/0x440
Mar 13 21:07:00 darkstar kernel: [10579.372004] EAX: 00000000 EBX: f330b060 ECX: 00000016 EDX: 00000002
Mar 13 21:07:00 darkstar kernel: [10579.372004] ESI: bfdfc3cc EDI: f3c0c380 EBP: efdc9e0c ESP: efdc9dd4
Mar 13 21:07:00 darkstar kernel: [10579.372004]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Mar 13 21:07:00 darkstar kernel: [10579.372004] CR0: 8005003b CR2: 00000010 CR3: 338a8000 CR4: 000007f0
Mar 13 21:07:00 darkstar kernel: [10579.372004] Stack:
Mar 13 21:07:00 darkstar kernel: [10579.372004]  c1b114a9 00000016 71d3e7e3 00000780 80000001 261b0067 efdc9e54 fffa3fe0
Mar 13 21:07:00 darkstar kernel: [10579.372004]  f330b060 00000016 bfdfc3cc 00000016 f330b060 eb7d4440 efdc9e54 c111c9ff
Mar 13 21:07:00 darkstar kernel: [10579.372004]  efdc9e44 f76b5374 00000000 ffffffff 00000000 c114a1f8 f76b5d0c eb7d4440
Mar 13 21:07:00 darkstar kernel: [10579.372004] Call Trace:
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c1b114a9>] ? apic_timer_interrupt+0x2d/0x34
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c111c9ff>] __get_user_pages.part.89+0xcf/0x470
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c114a1f8>] ? __inode_permission+0x48/0xb0
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c111cddc>] __get_user_pages+0x3c/0x60
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c111ce5c>] get_user_pages+0x5c/0x70
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c111cf2e>] __access_remote_vm+0xbe/0x170
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c111df75>] access_process_vm+0x45/0x80
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c110fc05>] get_cmdline+0x75/0x100
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c1194872>] proc_pid_cmdline+0x12/0x20
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c1195157>] proc_info_read+0x87/0xd0
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c11950d0>] ? pid_getattr+0xe0/0xe0
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c1140c15>] vfs_read+0x85/0x160
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c1140e6c>] SyS_read+0x4c/0x90
Mar 13 21:07:00 darkstar kernel: [10579.372004]  [<c1b11122>] syscall_call+0x7/0xb
Mar 13 21:07:00 darkstar kernel: [10579.372004] Code: 00 00 00 00 55 89 e5 57 56 53 83 ec 2c 66 66 66 66 90 8b 78 20 89 c3 8b 45 08 89 d6 c1 ea 1e 89 4d ec c7 00 00 00 00 00 8b 47 20 <8b> 0c d0 8b 44 d0 04 89 c2 09 ca 0f 84 12 01 00 00 89 ca 25 00
Mar 13 21:07:00 darkstar kernel: [10579.372004] EIP: [<c111b057>] follow_page_mask+0x27/0x440 SS:ESP 0068:efdc9dd4
Mar 13 21:07:00 darkstar kernel: [10579.372004] CR2: 0000000000000010
Mar 13 21:07:00 darkstar kernel: [10579.382958] ---[ end trace 1c7459dcda289e35 ]---
===================================================================================

Hopefully it will be useful to someone. Let me know if any further information is needed.

Michalis
