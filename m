Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3JCKNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:13:11 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50618 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3JCKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:13:09 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <alpine.LNX.2.00.1310031141260.29701@pobox.suse.cz>
References: <alpine.LNX.2.00.1310031141260.29701@pobox.suse.cz>
Date: Thu, 3 Oct 2013 12:13:08 +0200
Message-ID: <CAKMK7uEbGZ3_tHTCqOT7H4eViBnYmkPTS210jOvfweSf3gQ_fg@mail.gmail.com>
Subject: Re: HPD flood warning since b8f102e8b
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Egbert Eich <eich@suse.de>, Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please attach full dmesg from boot up to the first WARN with
drm.debug=0xe? This really shouldn't happen and indicates a bug
somewhere ...

Cheers, Daniel

On Thu, Oct 3, 2013 at 11:46 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> During resume from hibernation, I started to see the warning below since
>
>         commit b8f102e8bf71cacf33326360fdf9dcfd1a63925b
>         Author: Egbert Eich <eich@suse.de>
>         Date:   Fri Jul 26 14:14:24 2013 +0200
>
>             drm/i915: Add messages useful for HPD storm detection debugging (v2)
>
> the system is otherwise working properly, and so far it seems to happen
> only during hibernation resume.
>
>   [13766.703229] WARNING: CPU: 1 PID: 0 at drivers/gpu/drm/i915/i915_irq.c:1001 i965_irq_handler+0x492/0x680 [i915]()
>   [13766.703230] Received HPD interrupt although disabled
>   [13766.703335] Modules linked in: af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables rfcomm bn
>   ep btusb bluetooth cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant snd_hda_intel snd_hda_codec kvm_intel snd_hwdep kvm snd_pcm thinkpad_acpi snd_seq iwldvm mac80211 sg snd_timer
>   iwlwifi snd_seq_device cfg80211 snd i2c_i801 pcspkr rfkill lpc_ich mfd_core e1000e ehci_pci snd_page_alloc ptp pps_core tpm_tis tpm soundcore battery ac wmi tpm_bios acpi_cpufreq autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_he
>   lper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
>   [13766.703339] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.12.0-rc3 #1
>   [13766.703341] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>   [13766.703350]  00000000000003e9 ffff88007c283d18 ffffffff81583013 ffff88007c283d58
>   [13766.703357]  ffffffff8104d297 ffff88007c283d98 000000000000000c 0000000000000002
>   [13766.703365]  ffff880037158000 0000000000000004 ffff880037158000 ffff88007c283db8
>   [13766.703367] Call Trace:
>   [13766.703375]  <IRQ>  [<ffffffff81583013>] dump_stack+0x7a/0x97
>   [13766.703382]  [<ffffffff8104d297>] warn_slowpath_common+0x87/0xb0
>   [13766.703388]  [<ffffffff8104d361>] warn_slowpath_fmt+0x41/0x50
>   [13766.703425]  [<ffffffffa00c7be2>] i965_irq_handler+0x492/0x680 [i915]
>   [13766.703436]  [<ffffffff810a40fc>] handle_irq_event_percpu+0xac/0x220
>   [13766.703442]  [<ffffffff810a42b9>] handle_irq_event+0x49/0x70
>   [13766.703449]  [<ffffffff810a7b2f>] handle_edge_irq+0x7f/0x150
>   [13766.703454]  [<ffffffff81004a89>] handle_irq+0x59/0x150
>   [13766.703461]  [<ffffffff8158d371>] ? atomic_notifier_call_chain+0x11/0x20
>   [13766.703466]  [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
>   [13766.703474]  [<ffffffff815895af>] common_interrupt+0x6f/0x6f
>   [13766.703482]  <EOI>  [<ffffffff8146cf74>] ? cpuidle_enter_state+0x54/0xd0
>   [13766.703488]  [<ffffffff8146cf70>] ? cpuidle_enter_state+0x50/0xd0
>   [13766.703496]  [<ffffffff8146d37a>] cpuidle_idle_call+0x10a/0x160
>   [13766.703503]  [<ffffffff8100b7b9>] arch_cpu_idle+0x9/0x30
>   [13766.703509]  [<ffffffff810a35cb>] cpu_idle_loop+0x8b/0x270
>   [13766.703515]  [<ffffffff810a37ce>] cpu_startup_entry+0x1e/0x20
>   [13766.703522]  [<ffffffff8103115e>] start_secondary+0x8e/0x90
>
>
> It's not a single occurence, it's quite a flood within the same second,
> ending with
>
>   [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
>   [drm] HPD interrupt storm detected on connector HDMI-A-1: switching from hotplug detection to pollin
>
> If this really needs to be enabled unconditionally by default (?), having
> it to warn only once would be nice.
>
> If there is anything else I could do to make this go away, please let me
> know. I don't want to be running Tainted: W kernel from now forever on :)
>
> This is a standard x200s thinkpad, no fancy development HW.
>
> --
> Jiri Kosina
> SUSE Labs



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
