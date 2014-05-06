Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbaEFB5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:57:12 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51968 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbaEFB5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:57:10 -0400
Message-ID: <53684172.6090402@gmail.com>
Date: Tue, 06 May 2014 03:57:06 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Dave Jones <davej@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Wei Liu <wei.liu2@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: debug_dma_assert_idle - snd_hda_intel - cpu touching an active
 dma mapped cacheline
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de> <53500CDB.8050802@gmail.com> <53570F1F.1000709@gmail.com> <53575099.1030501@gmail.com> <5361D69E.1060802@gmail.com>
In-Reply-To: <5361D69E.1060802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The truth is that sometimes it takes more than a few reboot for the bug to occur.

3.15.0-0.rc4.git0.1.fc21.i686+debug  FAILED
http://koji.fedoraproject.org/koji/buildinfo?buildID=515111
...
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
snd_hda_intel 0000:00:07.0: Disabling MSI
snd_hda_intel 0000:00:07.0: position_fix set to 1 for device 1458:a022
...
------------[ cut here ]------------
WARNING: CPU: 1 PID: 496 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03012000]
Modules linked in: ip6t_rpfilter ip6t_REJECT xt_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller kvm_amd snd_hda_codec kvm snd_hwdep nouveau snd_seq mxm_wmi video snd_seq_device snd_pcm i2c_algo_bit ttm drm_kms_helper ppdev microcode parport_serial parport_pc snd_timer k10temp drm serio_raw i2c_nforce2 parport snd i2c_core soundcore wmi acpi_cpufreq sunrpc ata_generic pata_acpi r8169 mii skge pata_amd uas usb_storage
------------[ cut here ]------------

CPU: 1 PID: 496 Comm: firewalld Not tainted 3.15.0-0.rc4.git0.1.fc21.i686+debug #1
Hardware name: Gigabyte Technology Co., Ltd. M720-US3/M720-US3, BIOS F7n 09/07/2010
WARNING: CPU: 2 PID: 852 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
 00000000 252e7679 00000000
snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03012000]
 eed99df0 c0ae6f0d eed99e34
Modules linked in:
 eed99e24 c0454432
 ip6t_rpfilter ip6t_REJECT
 c0ceddd8
 xt_conntrack cfg80211 rfkill
 eed99e54
 ebtable_nat ebtable_broute bridge
 000001f0
 stp llc
 c0cebc97
 ebtable_filter
 00000251
 ebtables ip6table_nat nf_conntrack_ipv6
 c0754c39
 nf_defrag_ipv6
 00000251
 nf_nat_ipv6 ip6table_mangle ip6table_security
 c0754c39
 ip6table_raw ip6table_filter ip6_tables

 iptable_nat nf_conntrack_ipv4
 f3721700
 nf_defrag_ipv4 nf_nat_ipv4
 f2cfc480
 nf_nat
 03012000
 eed99e40 c045448e 00000009 eed99e34 c0ceddd8
Call Trace:
 [<c0ae6f0d>] dump_stack+0x48/0x60
 nf_conntrack iptable_mangle

 iptable_security iptable_raw
 [<c0454432>] warn_slowpath_common+0x82/0xa0
 snd_hda_codec_realtek snd_hda_codec_generic

 snd_hda_intel snd_hda_controller
 [<c0754c39>] ? debug_dma_assert_idle+0x159/0x1d0
 kvm_amd

 [<c0754c39>] ? debug_dma_assert_idle+0x159/0x1d0
 snd_hda_codec

 kvm snd_hwdep nouveau snd_seq
 [<c045448e>] warn_slowpath_fmt+0x3e/0x60

 [<c0754c39>] debug_dma_assert_idle+0x159/0x1d0

 mxm_wmi video
 [<c0589d69>] ? anon_vma_prepare+0x29/0x140

 [<c057e18e>] do_wp_page+0xce/0x890
 snd_seq_device snd_pcm

 [<c0480065>] ? __hrtimer_start_range_ns+0x35/0x550
 i2c_algo_bit
 [<c0580792>] handle_mm_fault+0x662/0xb70

 ttm drm_kms_helper
 [<c0480065>] ? __hrtimer_start_range_ns+0x35/0x550
 ppdev microcode parport_serial

 parport_pc snd_timer
 [<c0af31f7>] __do_page_fault+0x1a7/0x5d0
 k10temp drm serio_raw i2c_nforce2

 [<c05031fc>] ? __audit_syscall_entry+0x8c/0xe0

 parport snd
 [<c04b17ab>] ? trace_hardirqs_on+0xb/0x10

 i2c_core soundcore
 [<c04b16fc>] ? trace_hardirqs_on_caller+0x13c/0x1e0
 wmi acpi_cpufreq

 [<c0af3620>] ? __do_page_fault+0x5d0/0x5d0

 [<c0af363a>] do_page_fault+0x1a/0x20

 sunrpc ata_generic pata_acpi
 [<c0af0014>] error_code+0x6c/0x74
 r8169 mii
---[ end trace 08b99da35a4e0d8c ]---
Mapped at:
 
[<c0752ce2>] debug_dma_alloc_coherent+0x22/0x70
 
[<f80f8e90>] snd_dma_alloc_pages+0x170/0x260 [snd_pcm]
 
[<f80f8fe2>] snd_dma_alloc_pages_fallback+0x62/0x90 [snd_pcm]
 skge
 
[<f80f93b0>] snd_malloc_sgbuf_pages+0xf0/0x211 [snd_pcm]
 
[<f80f8f23>] snd_dma_alloc_pages+0x203/0x260 [snd_pcm]
 pata_amd
 uas usb_storage
CPU: 2 PID: 852 Comm: firewalld Tainted: G        W     3.15.0-0.rc4.git0.1.fc21.i686+debug #1
Hardware name: Gigabyte Technology Co., Ltd. M720-US3/M720-US3, BIOS F7n 09/07/2010
 00000000 cef7cf31 00000000 ecf2ddf0 c0ae6f0d ecf2de34 ecf2de24 c0454432
 c0ceddd8 ecf2de54 00000354 c0cebc97 00000251 c0754c39 00000251 c0754c39
 f3721700 f2cfc480 03012000 ecf2de40 c045448e 00000009 ecf2de34 c0ceddd8
Call Trace:
 [<c0ae6f0d>] dump_stack+0x48/0x60
 [<c0454432>] warn_slowpath_common+0x82/0xa0
 [<c0754c39>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c0754c39>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c045448e>] warn_slowpath_fmt+0x3e/0x60
 [<c0754c39>] debug_dma_assert_idle+0x159/0x1d0
 [<c0589d69>] ? anon_vma_prepare+0x29/0x140
 [<c057e18e>] do_wp_page+0xce/0x890
 [<c0480065>] ? __hrtimer_start_range_ns+0x35/0x550
 [<c0580792>] handle_mm_fault+0x662/0xb70
 [<c0480065>] ? __hrtimer_start_range_ns+0x35/0x550
 [<c0af31f7>] __do_page_fault+0x1a7/0x5d0
 [<c04b16fc>] ? trace_hardirqs_on_caller+0x13c/0x1e0
 [<c05031fc>] ? __audit_syscall_entry+0x8c/0xe0
 [<c04b17ab>] ? trace_hardirqs_on+0xb/0x10
 [<c04b16fc>] ? trace_hardirqs_on_caller+0x13c/0x1e0
 [<c0af3620>] ? __do_page_fault+0x5d0/0x5d0
 [<c0af363a>] do_page_fault+0x1a/0x20
 [<c0af0014>] error_code+0x6c/0x74
---[ end trace 08b99da35a4e0d8d ]---
Mapped at:
 [<c0752ce2>] debug_dma_alloc_coherent+0x22/0x70
 [<f80f8e90>] snd_dma_alloc_pages+0x170/0x260 [snd_pcm]
 [<f80f8fe2>] snd_dma_alloc_pages_fallback+0x62/0x90 [snd_pcm]
 [<f80f93b0>] snd_malloc_sgbuf_pages+0xf0/0x211 [snd_pcm]
 [<f80f8f23>] snd_dma_alloc_pages+0x203/0x260 [snd_pcm]
...

However with the 'cachelines-revert.patch', 
related to https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/lib/dma-debug.c?id=3b7a641, 
after rebooting 12 times sequentially, everything is OK!
i.e.
kernel-3.15.0-0.rc4.git0.3.fc21.i686 PASSED


poma


