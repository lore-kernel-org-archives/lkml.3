Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3EIM3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:29:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3EIM3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:29:20 -0400
Date: Thu, 9 May 2013 14:29:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got the warning below when resuming from hibernation with kernel 
that has NO_HZ_FULL_ALL=y. This is with topmost commit e0fd9affeb640.


[ ... snip ... ]
 PM: Hibernation mode set to 'shutdown'
 PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
 PM: Marking nosave pages: [mem 0x7c4a1000-0x7c4a6fff]
 PM: Marking nosave pages: [mem 0x7c5b7000-0x7c60efff]
 PM: Marking nosave pages: [mem 0x7c6c6000-0x7c9fefff]
 PM: Basic memory bitmaps created
 PM: Syncing filesystems ... done.
 Freezing user space processes ... (elapsed 0.01 seconds) done.
 PM: Preallocating image memory... done (allocated 194411 pages)
 PM: Allocated 777644 kbytes in 0.29 seconds (2681.53 MB/s)
 Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
 Suspending console(s) (use no_console_suspend to debug)
 mei_me 0000:00:03.0: suspend
 mei_me 0000:00:03.0: wait hw ready failed. status = 0x0
 PM: freeze of devices complete after 406.995 msecs
 PM: late freeze of devices complete after 0.543 msecs
 PM: noirq freeze of devices complete after 1.379 msecs
 Disabling non-boot CPUs ...
 smpboot: CPU 1 is now offline
 PM: Creating hibernation image:
 PM: Need to copy 193377 pages
 PM: Normal pages needed: 193377 + 1024, available pages: 316026
 microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60f
 Enabling non-boot CPUs ...
 smpboot: Booting Node 0 Processor 1 APIC 0x1
 CPU1 microcode updated early to revision 0x60f, date = 2010-09-29
 Disabled fast string operations
 ------------[ cut here ]------------
 WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x59/0x60()
 Modules linked in: af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant snd_hda_intel snd_hda_codec acpi_cpufreq mperf snd_hwdep kvm_intel kvm snd_pcm iwldvm thinkpad_acpi mac80211 snd_seq sg microcode iwlwifi snd_timer snd_seq_device cfg80211 i2c_i801 pcspkr rfkill lpc_ich e1000e mfd_core snd mei_me mei ptp snd_page_alloc ehci_pci pps_core wmi soundcore ac battery tpm_tis tpm tpm_bios autofs4 uhci_hcd i915 ehci_hcd drm_kms_helper drm i2c_algo_bit video usbcore button usb_common edd fan processor ata_generic thermal thermal_sys
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.9.0-11789-ge0fd9af #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  000000000000007b ffff880079851da8 ffffffff81547dde ffff880079851de8
  ffffffff8104212b ffff880079851dd8 0000000000000001 ffff88007c28cca0
  ffff880079878000 000000010003fb57 0000000000000096 ffff880079851df8
 Call Trace:
  [<ffffffff81547dde>] dump_stack+0x19/0x1b
  [<ffffffff8104212b>] warn_slowpath_common+0x6b/0xa0
  [<ffffffff81042175>] warn_slowpath_null+0x15/0x20
  [<ffffffff81026b09>] native_smp_send_reschedule+0x59/0x60
  [<ffffffff810774dc>] wake_up_nohz_cpu+0x9c/0xa0
  [<ffffffff810529db>] add_timer_on+0xdb/0x110
  [<ffffffff8101e4f4>] mce_start_timer+0x64/0x70
  [<ffffffff8101e552>] __mcheck_cpu_init_timer+0x52/0x60
  [<ffffffff8153dc8e>] mcheck_cpu_init+0x6f/0x111
  [<ffffffff8153b3ae>] identify_cpu+0x3cc/0x3f9
  [<ffffffff8153b3ed>] identify_secondary_cpu+0x12/0x1d
  [<ffffffff8153f836>] smp_store_cpu_info+0x3a/0x3c
  [<ffffffff8153f922>] smp_callin+0xea/0x1c1
  [<ffffffff8153fa1d>] start_secondary+0x24/0x97
 ---[ end trace 2c2f8914d9cd6bb0 ]---
 microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60f
 CPU1 is up
 i915 0000:00:02.0: power state changed by ACPI to D0
[ ... snip ... ]

-- 
Jiri Kosina
SUSE Labs
