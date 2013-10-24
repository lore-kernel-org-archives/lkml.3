Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3JXMgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:36:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3JXMgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:36:53 -0400
Date: Thu, 24 Oct 2013 13:36:47 +0100 (BST)
From: Jiri Kosina <jkosina@suse.cz>
To: Egbert Eich <eich@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Egbert Eich <eich@suse.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: HPD flood warning since b8f102e8b
In-Reply-To: <alpine.LNX.2.00.1310240806370.30926@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1310241334000.30926@pobox.suse.cz>
References: <alpine.LNX.2.00.1310031141260.29701@pobox.suse.cz> <CAKMK7uEbGZ3_tHTCqOT7H4eViBnYmkPTS210jOvfweSf3gQ_fg@mail.gmail.com> <alpine.LNX.2.00.1310031632320.29701@pobox.suse.cz> <21093.23168.424554.698941@linux-qknr.site>
 <alpine.LNX.2.00.1310240806370.30926@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct 2013, Jiri Kosina wrote:

> I have this:
> 
> [357128.184113] [drm] HPD interrupt storm detected on connector DP-3: switching from hotplug detection to polling
> 
> It appeared in the log approximately 5 seconds after resume has been 
> completed.

Okay, and it just happened during resume from RAM (it was a very long 
series of repeating the same trace, I am putting here just the last 
portion):

[362634.813953] ------------[ cut here ]------------
[362634.813980] WARNING: CPU: 0 PID: 666 at drivers/gpu/drm/i915/i915_irq.c:1001 i965_irq_handler+0x492/0x680 [i915]()
[362634.813981] Received HPD interrupt although disabled
[362634.814021] Modules linked in: sr_mod cdrom dm_mod fuse af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables nls_cp1250 nls_cp437 vfat fat rfcomm bnep cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant kvm_intel kvm usb_storage snd_hda_intel iwldvm snd_hda_codec mac80211 snd_hwdep iwlwifi sg snd_pcm cfg80211 snd_seq btusb bluetooth snd_timer pcspkr snd_seq_device thinkpad_acpi lpc_ich rfkill mfd_core i2c_i801 tpm_tis ac tpm battery snd tpm_bios e1000e soundcore snd_page_alloc wmi acpi_cpufreq ehci_pci ptp pps_core autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
[362634.814028] CPU: 0 PID: 666 Comm: rs:main Q:Reg Tainted: G        W    3.12.0-rc4-00006-g162bdaf-dirty #1
[362634.814029] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[362634.814033]  00000000000003e9 ffff88007c203d18 ffffffff81583863 ffff88007c203d58
[362634.814035]  ffffffff8104d297 ffff88007c203d98 0000000000000010 0000000000000002
[362634.814038]  ffff880037180000 0000000000000005 ffff880037180000 ffff88007c203db8
[362634.814039] Call Trace:
[362634.814044]  <IRQ>  [<ffffffff81583863>] dump_stack+0x7a/0x97
[362634.814048]  [<ffffffff8104d297>] warn_slowpath_common+0x87/0xb0
[362634.814051]  [<ffffffff8104d361>] warn_slowpath_fmt+0x41/0x50
[362634.814067]  [<ffffffffa00c7be2>] i965_irq_handler+0x492/0x680 [i915]
[362634.814072]  [<ffffffff810a41bc>] handle_irq_event_percpu+0xac/0x220
[362634.814074]  [<ffffffff810a4379>] handle_irq_event+0x49/0x70
[362634.814077]  [<ffffffff810a7bef>] handle_edge_irq+0x7f/0x150
[362634.814080]  [<ffffffff81004a89>] handle_irq+0x59/0x150
[362634.814083]  [<ffffffff81052b06>] ? irq_enter+0x16/0x90
[362634.814085]  [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
[362634.814089]  [<ffffffff81589def>] common_interrupt+0x6f/0x6f
[362634.814093]  <EOI>  [<ffffffff810bc850>] ? lock_acquire+0x110/0x130
[362634.814096]  [<ffffffff8158dae0>] ? notifier_call_chain+0xa0/0xa0
[362634.814098]  [<ffffffff8158db4a>] __atomic_notifier_call_chain+0x6a/0xc0
[362634.814101]  [<ffffffff8158dae0>] ? notifier_call_chain+0xa0/0xa0
[362634.814103]  [<ffffffff8158dbb1>] atomic_notifier_call_chain+0x11/0x20
[362634.814106]  [<ffffffff813b607f>] do_con_write+0x22f/0xa10
[362634.814109]  [<ffffffff81585e6f>] ? mutex_lock_nested+0x2ef/0x370
[362634.814111]  [<ffffffff810bb2bd>] ? trace_hardirqs_on_caller+0x13d/0x1e0
[362634.814115]  [<ffffffff8139df7d>] ? process_output_block+0x3d/0x1e0
[362634.814118]  [<ffffffff813b68b9>] con_write+0x19/0x30
[362634.814120]  [<ffffffff8139e010>] process_output_block+0xd0/0x1e0
[362634.814123]  [<ffffffff8139ee0b>] n_tty_write+0x18b/0x370
[362634.814126]  [<ffffffff810834a0>] ? try_to_wake_up+0x240/0x240
[362634.814129]  [<ffffffff8139c67c>] do_tty_write+0xbc/0x200
[362634.814131]  [<ffffffff8139ec80>] ? n_tty_ioctl+0x110/0x110
[362634.814134]  [<ffffffff8139c884>] tty_write+0xc4/0xf0
[362634.814137]  [<ffffffff81190bf7>] vfs_write+0xe7/0x190
[362634.814139]  [<ffffffff81191560>] SyS_write+0x60/0xb0
[362634.814142]  [<ffffffff81591fa2>] system_call_fastpath+0x16/0x1b
[362634.814144] ---[ end trace f54ed427593b8ca0 ]---
[362634.894446] ------------[ cut here ]------------
[362634.894476] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/i915/i915_irq.c:1001 i965_irq_handler+0x492/0x680 [i915]()
[362634.894479] Received HPD interrupt although disabled
[362634.894481] Modules linked in: sr_mod cdrom dm_mod fuse af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables nls_cp1250 nls_cp437 vfat fat rfcomm bnep cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant kvm_intel kvm usb_storage snd_hda_intel iwldvm snd_hda_codec mac80211 snd_hwdep iwlwifi sg snd_pcm cfg80211 snd_seq btusb bluetooth snd_timer pcspkr snd_seq_device thinkpad_acpi lpc_ich rfkill mfd_core i2c_i801 tpm_tis ac tpm battery snd tpm_bios e1000e soundcore snd_page_alloc wmi acpi_cpufreq ehci_pci ptp pps_core autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
[362634.894562] CPU: 1 PID: 1 Comm: systemd Tainted: G        W    3.12.0-rc4-00006-g162bdaf-dirty #1
[362634.894564] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[362634.894567]  00000000000003e9 ffff88007c283d18 ffffffff81583863 ffff88007c283d58
[362634.894572]  ffffffff8104d297 ffff88007c283d98 0000000000000010 0000000000000002
[362634.894577]  ffff880037180000 0000000000000005 ffff880037180000 ffff88007c283db8
[362634.894582] Call Trace:
[362634.894585]  <IRQ>  [<ffffffff81583863>] dump_stack+0x7a/0x97
[362634.894595]  [<ffffffff8104d297>] warn_slowpath_common+0x87/0xb0
[362634.894599]  [<ffffffff8104d361>] warn_slowpath_fmt+0x41/0x50
[362634.894618]  [<ffffffffa00c7be2>] i965_irq_handler+0x492/0x680 [i915]
[362634.894623]  [<ffffffff810bb1f2>] ? trace_hardirqs_on_caller+0x72/0x1e0
[362634.894630]  [<ffffffff810a41bc>] handle_irq_event_percpu+0xac/0x220
[362634.894634]  [<ffffffff810a4379>] handle_irq_event+0x49/0x70
[362634.894639]  [<ffffffff810a7bef>] handle_edge_irq+0x7f/0x150
[362634.894643]  [<ffffffff81004a89>] handle_irq+0x59/0x150
[362634.894648]  [<ffffffff81052b06>] ? irq_enter+0x16/0x90
[362634.894652]  [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
[362634.894657]  [<ffffffff81589def>] common_interrupt+0x6f/0x6f
[362634.894659]  <EOI>  [<ffffffff812fad67>] ? do_raw_spin_lock+0x47/0x160
[362634.894668]  [<ffffffff81588f44>] _raw_spin_lock+0x44/0x50
[362634.894673]  [<ffffffff812f3001>] ? lockref_put_or_lock+0x11/0x40
[362634.894677]  [<ffffffff812f3001>] lockref_put_or_lock+0x11/0x40
[362634.894682]  [<ffffffff811a97df>] dput+0x1f/0x120
[362634.894686]  [<ffffffff811a0275>] link_path_walk+0x625/0x980
[362634.894690]  [<ffffffff811a09ef>] path_lookupat+0x41f/0x8b0
[362634.894695]  [<ffffffff8119d641>] ? getname_flags+0x51/0x1b0
[362634.894699]  [<ffffffff811a0eb3>] filename_lookup+0x33/0xd0
[362634.894703]  [<ffffffff811a202b>] user_path_at_empty+0x7b/0xb0
[362634.894708]  [<ffffffff8119d7d4>] ? putname+0x24/0x40
[362634.894711]  [<ffffffff811a2036>] ? user_path_at_empty+0x86/0xb0
[362634.894716]  [<ffffffff810f863f>] ? __call_rcu+0xaf/0x140
[362634.894720]  [<ffffffff811a206c>] user_path_at+0xc/0x10
[362634.894724]  [<ffffffff81196c01>] vfs_fstatat+0x51/0xb0
[362634.894729]  [<ffffffff81079681>] ? prepare_creds+0x21/0xf0
[362634.894733]  [<ffffffff81196d86>] vfs_stat+0x16/0x20
[362634.894737]  [<ffffffff81196daf>] SyS_newstat+0x1f/0x50
[362634.894741]  [<ffffffff810bb2bd>] ? trace_hardirqs_on_caller+0x13d/0x1e0
[362634.894746]  [<ffffffff812f2b6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[362634.894751]  [<ffffffff81591fa2>] system_call_fastpath+0x16/0x1b
[362634.894754] ---[ end trace f54ed427593b8ca1 ]---
[362635.236558] ------------[ cut here ]------------
[362635.236588] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/i915/i915_irq.c:1001 i965_irq_handler+0x492/0x680 [i915]()
[362635.236591] Received HPD interrupt although disabled
[362635.236592] Modules linked in: sr_mod cdrom dm_mod fuse af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables nls_cp1250 nls_cp437 vfat fat rfcomm bnep cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant kvm_intel kvm usb_storage snd_hda_intel iwldvm snd_hda_codec mac80211 snd_hwdep iwlwifi sg snd_pcm cfg80211 snd_seq btusb bluetooth snd_timer pcspkr snd_seq_device thinkpad_acpi lpc_ich rfkill mfd_core i2c_i801 tpm_tis ac tpm battery snd tpm_bios e1000e soundcore snd_page_alloc wmi acpi_cpufreq ehci_pci ptp pps_core autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
[362635.236665] CPU: 1 PID: 1 Comm: systemd Tainted: G        W    3.12.0-rc4-00006-g162bdaf-dirty #1
[362635.236667] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[362635.236670]  00000000000003e9 ffff88007c283d18 ffffffff81583863 ffff88007c283d58
[362635.236675]  ffffffff8104d297 ffff88007c283d98 0000000000000010 0000000000000002
[362635.236680]  ffff880037180000 0000000000000005 ffff880037180000 ffff88007c283db8
[362635.236684] Call Trace:
[362635.236687]  <IRQ>  [<ffffffff81583863>] dump_stack+0x7a/0x97
[362635.236698]  [<ffffffff8104d297>] warn_slowpath_common+0x87/0xb0
[362635.236702]  [<ffffffff8104d361>] warn_slowpath_fmt+0x41/0x50
[362635.236718]  [<ffffffffa00c7be2>] i965_irq_handler+0x492/0x680 [i915]
[362635.236723]  [<ffffffff810bb1f2>] ? trace_hardirqs_on_caller+0x72/0x1e0
[362635.236729]  [<ffffffff810a41bc>] handle_irq_event_percpu+0xac/0x220
[362635.236733]  [<ffffffff810a4379>] handle_irq_event+0x49/0x70
[362635.236737]  [<ffffffff810a7bef>] handle_edge_irq+0x7f/0x150
[362635.236741]  [<ffffffff81004a89>] handle_irq+0x59/0x150
[362635.236745]  [<ffffffff81052b06>] ? irq_enter+0x16/0x90
[362635.236749]  [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
[362635.236753]  [<ffffffff81589def>] common_interrupt+0x6f/0x6f
[362635.236755]  <EOI>  [<ffffffff81591fc7>] ? sysret_check+0x1b/0x56
[362635.236761] ---[ end trace f54ed427593b8ca2 ]---
[362635.296933] ------------[ cut here ]------------
[362635.296956] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/i915/i915_irq.c:1001 i965_irq_handler+0x492/0x680 [i915]()
[362635.296958] Received HPD interrupt although disabled
[362635.296960] Modules linked in: sr_mod cdrom dm_mod fuse af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables nls_cp1250 nls_cp437 vfat fat rfcomm bnep cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant kvm_intel kvm usb_storage snd_hda_intel iwldvm snd_hda_codec mac80211 snd_hwdep iwlwifi sg snd_pcm cfg80211 snd_seq btusb bluetooth snd_timer pcspkr snd_seq_device thinkpad_acpi lpc_ich rfkill mfd_core i2c_i801 tpm_tis ac tpm battery snd tpm_bios e1000e soundcore snd_page_alloc wmi acpi_cpufreq ehci_pci ptp pps_core autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
[362635.297030] CPU: 1 PID: 1 Comm: systemd Tainted: G        W    3.12.0-rc4-00006-g162bdaf-dirty #1
[362635.297033] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[362635.297035]  00000000000003e9 ffff88007c283d18 ffffffff81583863 ffff88007c283d58
[362635.297040]  ffffffff8104d297 ffff88007c283d98 0000000000000010 0000000000000002
[362635.297044]  ffff880037180000 0000000000000005 ffff880037180000 ffff88007c283db8
[362635.297049] Call Trace:
[362635.297051]  <IRQ>  [<ffffffff81583863>] dump_stack+0x7a/0x97
[362635.297060]  [<ffffffff8104d297>] warn_slowpath_common+0x87/0xb0
[362635.297064]  [<ffffffff8104d361>] warn_slowpath_fmt+0x41/0x50
[362635.297080]  [<ffffffffa00c7be2>] i965_irq_handler+0x492/0x680 [i915]
[362635.297085]  [<ffffffff810a41bc>] handle_irq_event_percpu+0xac/0x220
[362635.297089]  [<ffffffff810a4379>] handle_irq_event+0x49/0x70
[362635.297093]  [<ffffffff810a7bef>] handle_edge_irq+0x7f/0x150
[362635.297097]  [<ffffffff81004a89>] handle_irq+0x59/0x150
[362635.297101]  [<ffffffff81052b06>] ? irq_enter+0x16/0x90
[362635.297104]  [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
[362635.297109]  [<ffffffff81589def>] common_interrupt+0x6f/0x6f
[362635.297110]  <EOI>  [<ffffffff810bc78a>] ? lock_acquire+0x4a/0x130
[362635.297118]  [<ffffffff81588f3c>] _raw_spin_lock+0x3c/0x50
[362635.297123]  [<ffffffff812f3001>] ? lockref_put_or_lock+0x11/0x40
[362635.297126]  [<ffffffff812f3001>] lockref_put_or_lock+0x11/0x40
[362635.297131]  [<ffffffff811a97df>] dput+0x1f/0x120
[362635.297134]  [<ffffffff811a0b65>] path_lookupat+0x595/0x8b0
[362635.297139]  [<ffffffff8119d641>] ? getname_flags+0x51/0x1b0
[362635.297143]  [<ffffffff811a0eb3>] filename_lookup+0x33/0xd0
[362635.297146]  [<ffffffff811a202b>] user_path_at_empty+0x7b/0xb0
[362635.297150]  [<ffffffff810bb36d>] ? trace_hardirqs_on+0xd/0x10
[362635.297155]  [<ffffffff811b23cc>] ? mntput_no_expire+0x4c/0x180
[362635.297158]  [<ffffffff811a206c>] user_path_at+0xc/0x10
[362635.297162]  [<ffffffff81196c01>] vfs_fstatat+0x51/0xb0
[362635.297165]  [<ffffffff81196cc9>] vfs_lstat+0x19/0x20
[362635.297169]  [<ffffffff81196cef>] SyS_newlstat+0x1f/0x50
[362635.297172]  [<ffffffff810bb2bd>] ? trace_hardirqs_on_caller+0x13d/0x1e0
[362635.297176]  [<ffffffff812f2b6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[362635.297181]  [<ffffffff81591fa2>] system_call_fastpath+0x16/0x1b
[362635.297183] ---[ end trace f54ed427593b8ca3 ]---
[362636.061672] ------------[ cut here ]------------
[362636.061699] WARNING: CPU: 1 PID: 0 at drivers/gpu/drm/i915/i915_irq.c:1001 i965_irq_handler+0x492/0x680 [i915]()
[362636.061702] Received HPD interrupt although disabled
[362636.061704] Modules linked in: sr_mod cdrom dm_mod fuse af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables nls_cp1250 nls_cp437 vfat fat rfcomm bnep cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant kvm_intel kvm usb_storage snd_hda_intel iwldvm snd_hda_codec mac80211 snd_hwdep iwlwifi sg snd_pcm cfg80211 snd_seq btusb bluetooth snd_timer pcspkr snd_seq_device thinkpad_acpi lpc_ich rfkill mfd_core i2c_i801 tpm_tis ac tpm battery snd tpm_bios e1000e soundcore snd_page_alloc wmi acpi_cpufreq ehci_pci ptp pps_core autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
[362636.061787] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.12.0-rc4-00006-g162bdaf-dirty #1
[362636.061789] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[362636.061792]  00000000000003e9 ffff88007c283d18 ffffffff81583863 ffff88007c283d58
[362636.061798]  ffffffff8104d297 ffff88007c283d98 0000000000000010 0000000000000002
[362636.061803]  ffff880037180000 0000000000000005 ffff880037180000 ffff88007c283db8
[362636.061809] Call Trace:
[362636.061811]  <IRQ>  [<ffffffff81583863>] dump_stack+0x7a/0x97
[362636.061822]  [<ffffffff8104d297>] warn_slowpath_common+0x87/0xb0
[362636.061826]  [<ffffffff8104d361>] warn_slowpath_fmt+0x41/0x50
[362636.061845]  [<ffffffffa00c7be2>] i965_irq_handler+0x492/0x680 [i915]
[362636.061852]  [<ffffffff810a41bc>] handle_irq_event_percpu+0xac/0x220
[362636.061856]  [<ffffffff810a4379>] handle_irq_event+0x49/0x70
[362636.061860]  [<ffffffff810a7bef>] handle_edge_irq+0x7f/0x150
[362636.061865]  [<ffffffff81004a89>] handle_irq+0x59/0x150
[362636.061870]  [<ffffffff8158dbb1>] ? atomic_notifier_call_chain+0x11/0x20
[362636.061873]  [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
[362636.061878]  [<ffffffff81589def>] common_interrupt+0x6f/0x6f
[362636.061880]  <EOI>  [<ffffffff8146d3e4>] ? cpuidle_enter_state+0x54/0xd0
[362636.061889]  [<ffffffff8146d3e0>] ? cpuidle_enter_state+0x50/0xd0
[362636.061894]  [<ffffffff8146d7ea>] cpuidle_idle_call+0x10a/0x160
[362636.061899]  [<ffffffff8100b7b9>] arch_cpu_idle+0x9/0x30
[362636.061903]  [<ffffffff810a368b>] cpu_idle_loop+0x8b/0x270
[362636.061908]  [<ffffffff810a388e>] cpu_startup_entry+0x1e/0x20
[362636.061913]  [<ffffffff8103115e>] start_secondary+0x8e/0x90
[362636.061916] ---[ end trace f54ed427593b8ca4 ]---
[362636.256047] [drm] HPD interrupt storm detected on connector HDMI-A-1: switching from hotplug detection to polling
[362636.899720] [drm] HPD interrupt storm detected on connector DP-3: switching from hotplug detection to polling

-- 
Jiri Kosina
SUSE Labs
