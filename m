Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbaDKUEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:04:45 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63652 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaDKUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:04:42 -0400
Date: Fri, 11 Apr 2014 16:04:39 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-Z230
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Parag Warudkar <parag.lkml@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: BAR 14: can't assign mem (size 0x200000)
In-Reply-To: <CAErSpo6XjtrzSJE6n5aCMzketKv+rPt5eVvrzOQgUnviiRTWnA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1404111424070.4432@parag-Z230>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com> <CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com> <CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com> <CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
 <CA+55aFx_zAO0iJVi==4X-bYFTopgaOCopCdUBbqUwKfOrXRYqw@mail.gmail.com> <20140329171903.GA10551@google.com> <CAOULuOaUke-W1W0o=1rhhk43Fy_RAYLdfhXQjdhy2xjHxP0oWA@mail.gmail.com> <CAErSpo6XjtrzSJE6n5aCMzketKv+rPt5eVvrzOQgUnviiRTWnA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2014, Bjorn Helgaas wrote:

> On Sat, Mar 29, 2014 at 6:14 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> >> On Sat, Mar 29, 2014 at 09:41:20AM -0700, Linus Torvalds wrote:
> >
> >>> Parag, can you add a WARN_ON_ONCE() to that message, so that we see
> >>> what the call chain is for it.
> 
> Parag, did you ever try this?
> 

Below is the output of WARN_ON_ONCE(1) in drivers/pci/setup-res.c. 

Parag

[  339.142257] ACPI: \_SB_.PCI0.RP01: Bus check in hotplug_event()
[  339.142293] ACPI: \_SB_.PCI0.RP04: Bus check in hotplug_event()
[  339.142420] pci_bus 0000:03: Allocating resources
[  339.142437] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to [bus 
03] add_size 1000
[  339.142443] pci 0000:02:00.0: bridge window [mem 0x00100000-0x000fffff 
64bit pref] to [bus 03] add_size 200000
[  339.142448] pci 0000:02:00.0: bridge window [mem 0x00100000-0x000fffff] 
to [bus 03] add_size 200000
[  339.142454] pci 0000:02:00.0: res[14]=[mem 0x00100000-0x000fffff] 
get_res_add_size add_size 200000
[  339.142456] pci 0000:02:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit 
pref] get_res_add_size add_size 200000
[  339.142457] pci 0000:02:00.0: res[13]=[io  0x1000-0x0fff] 
get_res_add_size add_size 1000
[  339.142459] ------------[ cut here ]------------
[  339.142467] WARNING: CPU: 7 PID: 4071 at drivers/pci/setup-res.c:255 
_pci_assign_resource+0x1a0/0x1c0()
[  339.142471] Modules linked in: xt_TCPMSS cuse ipt_MASQUERADE 
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp 
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables 
x_tables bridge stp llc snd_hda_codec_realtek snd_hda_codec_hdmi 
snd_hda_codec_generic rfcomm bnep bluetooth binfmt_misc i915 joydev 
x86_pkg_temp_thermal intel_powerclamp kvm_intel snd_hda_intel kvm 
snd_hda_controller snd_hda_codec hid_logitech_dj usbhid snd_hwdep hid 
nls_iso8859_1 snd_pcm video drm_kms_helper snd_seq_midi snd_seq_midi_event 
drm snd_rawmidi crct10dif_pclmul crc32_pclmul hp_wmi sparse_keymap 
ghash_clmulni_intel ppdev snd_seq aesni_intel aes_x86_64 lrw gf128mul 
glue_helper ablk_helper cryptd snd_seq_device psmouse snd_timer snd 
microcode mei_me serio_raw wmi mei lpc_ich parport_pc soundcore 
i2c_algo_bit tpm_infineon mac_hid coretemp lp parport e1000e ptp ahci 
pps_core libahci
[  339.142976] CPU: 7 PID: 4071 Comm: kworker/u16:2 Tainted: G        W     
3.14.0+ #4
[  339.142978] Hardware name: Hewlett-Packard HP Z230 Tower 
Workstation/1905, BIOS L51 v01.18 01/23/2014
[  339.142981] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  339.142983]  0000000000000009 ffff88044378bac0 ffffffff81717fb4 
0000000000000000
[  339.142985]  ffff88044378baf8 ffffffff8106534d ffff8804451a8658 
000000009f200000
[  339.142987]  ffff8804451a8000 ffff880445553400 0000000000001000 
ffff88044378bb08
[  339.142989] Call Trace:
[  339.142994]  [<ffffffff81717fb4>] dump_stack+0x45/0x56
[  339.142997]  [<ffffffff8106534d>] warn_slowpath_common+0x7d/0xa0
[  339.142999]  [<ffffffff8106542a>] warn_slowpath_null+0x1a/0x20
[  339.143002]  [<ffffffff813a1280>] _pci_assign_resource+0x1a0/0x1c0
[  339.143005]  [<ffffffff815fa1d0>] ? powercap_register_zone+0x650/0x650
[  339.143007]  [<ffffffff813a15ec>] pci_assign_resource+0xac/0x240
[  339.143012]  [<ffffffff814810fd>] ? dev_printk+0x4d/0x50
[  339.143014]  [<ffffffff813a251c>] 
assign_requested_resources_sorted+0x6c/0xd0
[  339.143017]  [<ffffffff813a27f2>] __assign_resources_sorted+0x272/0x450
[  339.143019]  [<ffffffff813a2bc5>] ? __dev_sort_resources+0x1f5/0x270
[  339.143023]  [<ffffffff8170c0e1>] __pci_bus_assign_resources+0x61/0x110
[  339.143025]  [<ffffffff8170c5c4>] enable_slot+0x164/0x300
[  339.143030]  [<ffffffff8148e67c>] ? __pm_runtime_resume+0x5c/0x80
[  339.143033]  [<ffffffff813b55e8>] acpiphp_check_bridge.part.7+0xc8/0xf0
[  339.143035]  [<ffffffff813b5ec0>] acpiphp_hotplug_notify+0x170/0x1f0
[  339.143037]  [<ffffffff813b5d50>] ? acpiphp_post_dock_fixup+0xc0/0xc0
[  339.143040]  [<ffffffff813e1a09>] acpi_device_hotplug+0x3a0/0x3ed
[  339.143042]  [<ffffffff813dbbb0>] acpi_hotplug_work_fn+0x1e/0x29
[  339.143047]  [<ffffffff81080cf2>] process_one_work+0x182/0x450
[  339.143049]  [<ffffffff81081ab1>] worker_thread+0x121/0x410
[  339.143051]  [<ffffffff81081990>] ? rescuer_thread+0x3e0/0x3e0
[  339.143053]  [<ffffffff81088372>] kthread+0xd2/0xf0
[  339.143055]  [<ffffffff810882a0>] ? kthread_create_on_node+0x190/0x190
[  339.143058]  [<ffffffff8172903c>] ret_from_fork+0x7c/0xb0
[  339.143060]  [<ffffffff810882a0>] ? kthread_create_on_node+0x190/0x190
[  339.143061] ---[ end trace d0c4e4d8d8734d92 ]---
[  339.143064] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
[  339.143066] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 
0x200000)
[  339.143068] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
[  339.143070] pci 0000:02:00.0: BAR 14: can't assign mem (size 0x200000)
[  339.143072] pci 0000:02:00.0: BAR 15: can't assign mem pref (size 
0x200000)
[  339.143073] pci 0000:02:00.0: BAR 13: can't assign io (size 0x1000)
[  339.143075] pci 0000:02:00.0: PCI bridge to [bus 03]
[  339.143104] pci 0000:02:00.0: no hotplug settings from platform
[  339.143105] pci 0000:02:00.0: using default PCI settings
[  339.143128] ACPI: \_SB_.PCI0.RP05: Bus check in hotplug_event()
[  339.143300] done.

