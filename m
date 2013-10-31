Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3JaPw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:52:26 -0400
Received: from nebula.mojo.cc ([46.4.89.19]:40959 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab3JaPwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:52:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 31 Oct 2013 16:52:54 +0100
From: emanoil.kotsev@fincom.at
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: kernel 3.11.6 general protection fault
In-Reply-To: <20131031143711.GA9818@pd.tnic>
References: <e09ad4cb88b923ec017a516e6778b6bd@fincom.at>
 <20131031143711.GA9818@pd.tnic>
Message-ID: <cfb4b5e820828e60ad24be359b6e574b@fincom.at>
User-Agent: Roundcube Webmail/0.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thanks for swift response.
Yes, without those modules loaded it hangs as well. Perhaps I did not 
understand you well - do you mean unloaded or not compiled/installed, or 
even blacklisted. I tried only with unloading them. The custom stuff is 
vmware nothing else, but if I remember issues popped up after 
compiling/patching vmware/player for 3.10
As I said I noticed this recently when I spent more time watching 
youtube videos, but it could be that this only reveals the problem which 
was persistent before (perhaps after vmplayer patch/modules).

I'm using the Notebook with a docking station - and I have a same 
notebook with different bios version. Does it make sense to try the 
kernel on a different bios version?

thanks and regards

На 2013-10-31 15:37, Borislav Petkov написа:
> Adding intel-gfx@ to CC.
> 
> On Thu, Oct 31, 2013 at 03:00:24PM +0100, emanoil.kotsev@fincom.at 
> wrote:
>> Hi again, just noticed that it happens also without starring at
>> youtube, but again in the drm
> 
> Right, I can see a bunch of #GPs happening at
> 
> drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60
> 
> (I'm looking also at your other mail) but also, there are other ones
> which are completely unrelated and happening at random places. The 
> whole
> thing looks like random corruption to me.
> 
> And you have out of tree, proprietary crap loaded so can you reproduce
> the same issue without those modules, i.e. vsock, vmci, vmmon... 
> loaded?
> 
> Leaving the rest for reference.
> 
>> Thanks in advance and kind regards
>> 
>> ------- cut --------
>> 
>> Oct 31 10:51:01 maistor kernel: [drm] Setting output timings on
>> SDVOB failed
>> Oct 31 10:51:01 maistor kernel: lp: driver loaded but no devices found
>> Oct 31 10:51:01 maistor kernel: ppdev: user-space parallel port driver
>> Oct 31 10:51:01 maistor kernel: ------------[ cut here ]------------
>> Oct 31 10:51:01 maistor kernel: WARNING: CPU: 1 PID: 6441 at
>> drivers/gpu/drm/i915/intel_display.c:8292
>> check_crtc_state+0x5cf/0xa60 [i915]()
>> Oct 31 10:51:01 maistor kernel: pipe state doesn't match!
>> Oct 31 10:51:01 maistor kernel: Modules linked in: ppdev lp bnep
>> rfcomm bluetooth crc16 vmnet(O) parport_pc parport vsock(O) vmci(O)
>> vmmon(O) cpufreq_ondemand cpufreq_powersave cpufreq_performance
>> cpufreq_stats cpufreq_conservative xt_state xt_tcpudp ipt_REJECT
>> xt_limit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
>> nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables x_tables
>> acpi_pad custom_method sbs sbshc fan acpi_ipmi ipmi_msghandler
>> snd_hrtimer binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2
>> usb_storage snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep
>> snd_pcm_oss snd_mixer_oss snd_pcm iTCO_wdt iTCO_vendor_support
>> snd_seq_dummy snd_page_alloc snd_seq_oss snd_seq_midi
>> snd_seq_midi_event snd_rawmidi yenta_socket snd_seq pcmcia_rsrc
>> lpc_ich acpi_cpufreq snd_seq_device snd_timer snd i2c_i801 arc4
>> mperf iwl3945 iwlegacy mac80211 cfg80211 rfkill soundcore irda
>> ehci_pci 8250 crc_ccitt joydev processor dcdbas dell_wmi
>> sparse_keymap rtc_cmos wmi evdev battery ac serial_core sha256_ssse3
>> s
>> Oct 31 10:51:01 maistor kernel: ha256_generic cbc hid_generic usbhid
>> hid loop dm_crypt dm_mod sg sr_mod cdrom sd_mod firewire_ohci
>> firewire_core thermal b44 ssb mmc_core mii pcmcia crc_itu_t
>> pcmcia_core i915 cfbfillrect cfbimgblt video button i2c_algo_bit
>> cfbcopyarea drm_kms_helper drm intel_agp uhci_hcd ehci_hcd intel_gtt
>> agpgart i2c_core thermal_sys freq_table usbcore usb_common
>> Oct 31 10:51:01 maistor kernel: CPU: 1 PID: 6441 Comm: Xorg Tainted:
>> P           O 3.11.6eko2 #1
>> Oct 31 10:51:01 maistor kernel: Hardware name: Dell Inc. Latitude
>> D520                   /0NF743, BIOS A04 12/18/2006
>> Oct 31 10:51:01 maistor kernel: 0000000000000000 0000000000000009
>> ffffffff813db19f ffff8800268b1888
>> Oct 31 10:51:01 maistor kernel: ffffffff8103f561 ffff880037fd96d8
>> ffff8800268b1900 ffff880037c01800
>> Oct 31 10:51:01 maistor kernel: 0000000000000001 ffff880037c01c88
>> ffffffff8103f645 ffffffffa0162ea2
>> Oct 31 10:51:01 maistor kernel: Call Trace:
>> Oct 31 10:51:01 maistor kernel: [<ffffffff813db19f>] ?
>> dump_stack+0x50/0x80
>> Oct 31 10:51:01 maistor kernel: [<ffffffff8103f561>] ?
>> warn_slowpath_common+0x81/0xb0
>> Oct 31 10:51:01 maistor kernel: [<ffffffff8103f645>] ?
>> warn_slowpath_fmt+0x45/0x50
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa01106ff>] ?
>> check_crtc_state+0x5cf/0xa60 [i915]
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa011aeed>] ?
>> intel_modeset_check_state+0x2bd/0x730 [i915]
>> Oct 31 10:51:01 maistor kernel: [<ffffffff811fa769>] ?
>> snprintf+0x39/0x40
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa011b3cd>] ?
>> intel_set_mode+0x1d/0x30 [i915]
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa011bb8a>] ?
>> intel_crtc_set_config+0x7aa/0x980 [i915]
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa00a8505>] ?
>> drm_mode_set_config_internal+0x55/0xd0 [drm]
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa00aa378>] ?
>> drm_mode_setcrtc+0x118/0x640 [drm]
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa009b1ad>] ?
>> drm_ioctl+0x4ed/0x5f0 [drm]
>> Oct 31 10:51:01 maistor kernel: [<ffffffffa00aa260>] ?
>> drm_mode_setplane+0x3a0/0x3a0 [drm]
>> Oct 31 10:51:01 maistor kernel: [<ffffffff8111d97b>] ?
>> do_vfs_ioctl+0x8b/0x530
>> Oct 31 10:51:01 maistor kernel: [<ffffffff8111de6d>] ?
>> SyS_ioctl+0x4d/0xa0
>> Oct 31 10:51:01 maistor kernel: [<ffffffff813e1e56>] ?
>> system_call_fastpath+0x1a/0x1f
>> Oct 31 10:51:01 maistor kernel: ---[ end trace 65327d016e6b6847 ]---
>> Oct 31 10:51:08 maistor kernel: [drm] Setting output timings on
>> SDVOB failed
>> Oct 31 10:51:08 maistor kernel: ------------[ cut here ]------------
>> Oct 31 10:51:08 maistor kernel: WARNING: CPU: 1 PID: 6441 at
>> drivers/gpu/drm/i915/intel_display.c:8292
>> check_crtc_state+0x5cf/0xa60 [i915]()
>> Oct 31 10:51:08 maistor kernel: pipe state doesn't match!
>> Oct 31 10:51:08 maistor kernel: Modules linked in: ppdev lp bnep
>> rfcomm bluetooth crc16 vmnet(O) parport_pc parport vsock(O) vmci(O)
>> vmmon(O) cpufreq_ondemand cpufreq_powersave cpufreq_performance
>> cpufreq_stats cpufreq_conservative xt_state xt_tcpudp ipt_REJECT
>> xt_limit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
>> nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables x_tables
>> acpi_pad custom_method sbs sbshc fan acpi_ipmi ipmi_msghandler
>> snd_hrtimer binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2
>> usb_storage snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep
>> snd_pcm_oss snd_mixer_oss snd_pcm iTCO_wdt iTCO_vendor_support
>> snd_seq_dummy snd_page_alloc snd_seq_oss snd_seq_midi
>> snd_seq_midi_event snd_rawmidi yenta_socket snd_seq pcmcia_rsrc
>> lpc_ich acpi_cpufreq snd_seq_device snd_timer snd i2c_i801 arc4
>> mperf iwl3945 iwlegacy mac80211 cfg80211 rfkill soundcore irda
>> ehci_pci 8250 crc_ccitt joydev processor dcdbas dell_wmi
>> sparse_keymap rtc_cmos wmi evdev battery ac serial_core sha256_ssse3
>> s
>> Oct 31 10:51:08 maistor kernel: ha256_generic cbc hid_generic usbhid
>> hid loop dm_crypt dm_mod sg sr_mod cdrom sd_mod firewire_ohci
>> firewire_core thermal b44 ssb mmc_core mii pcmcia crc_itu_t
>> pcmcia_core i915 cfbfillrect cfbimgblt video button i2c_algo_bit
>> cfbcopyarea drm_kms_helper drm intel_agp uhci_hcd ehci_hcd intel_gtt
>> agpgart i2c_core thermal_sys freq_table usbcore usb_common
>> Oct 31 10:51:08 maistor kernel: CPU: 1 PID: 6441 Comm: Xorg Tainted:
>> P        W  O 3.11.6eko2 #1
>> Oct 31 10:51:08 maistor kernel: Hardware name: Dell Inc. Latitude
>> D520                   /0NF743, BIOS A04 12/18/2006
>> Oct 31 10:51:08 maistor kernel: 0000000000000000 0000000000000009
>> ffffffff813db19f ffff8800268b1888
>> Oct 31 10:51:08 maistor kernel: ffffffff8103f561 ffff880037fd96d8
>> ffff8800268b1900 ffff880037c01800
>> Oct 31 10:51:08 maistor kernel: 0000000000000001 ffff880037c01c88
>> ffffffff8103f645 ffffffffa0162ea2
>> Oct 31 10:51:08 maistor kernel: Call Trace:
>> Oct 31 10:51:08 maistor kernel: [<ffffffff813db19f>] ?
>> dump_stack+0x50/0x80
>> Oct 31 10:51:08 maistor kernel: [<ffffffff8103f561>] ?
>> warn_slowpath_common+0x81/0xb0
>> Oct 31 10:51:08 maistor kernel: [<ffffffff8103f645>] ?
>> warn_slowpath_fmt+0x45/0x50
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa01106ff>] ?
>> check_crtc_state+0x5cf/0xa60 [i915]
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa011aeed>] ?
>> intel_modeset_check_state+0x2bd/0x730 [i915]
>> Oct 31 10:51:08 maistor kernel: [<ffffffff811fa769>] ?
>> snprintf+0x39/0x40
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa011b3cd>] ?
>> intel_set_mode+0x1d/0x30 [i915]
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa011bb8a>] ?
>> intel_crtc_set_config+0x7aa/0x980 [i915]
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa00a8505>] ?
>> drm_mode_set_config_internal+0x55/0xd0 [drm]
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa00aa378>] ?
>> drm_mode_setcrtc+0x118/0x640 [drm]
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa009b1ad>] ?
>> drm_ioctl+0x4ed/0x5f0 [drm]
>> Oct 31 10:51:08 maistor kernel: [<ffffffffa00aa260>] ?
>> drm_mode_setplane+0x3a0/0x3a0 [drm]
>> Oct 31 10:51:08 maistor kernel: [<ffffffff8111d97b>] ?
>> do_vfs_ioctl+0x8b/0x530
>> Oct 31 10:51:08 maistor kernel: [<ffffffff810424d5>] ?
>> do_setitimer+0x1b5/0x1e0
>> Oct 31 10:51:08 maistor kernel: [<ffffffff8111de6d>] ?
>> SyS_ioctl+0x4d/0xa0
>> Oct 31 10:51:08 maistor kernel: [<ffffffff813e1e56>] ?
>> system_call_fastpath+0x1a/0x1f
>> Oct 31 10:51:08 maistor kernel: ---[ end trace 65327d016e6b6848 ]---
>> Oct 31 10:51:49 maistor kernel: [drm] Setting output timings on
>> SDVOB failed
>> Oct 31 10:55:06 maistor kernel: perf samples too long (2512 > 2500),
>> lowering kernel.perf_event_max_sample_rate to 50000
>> Oct 31 11:22:11 maistor kernel: perf samples too long (5003 > 5000),
>> lowering kernel.perf_event_max_sample_rate to 25000
>> 
>> ------- cut --------
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
