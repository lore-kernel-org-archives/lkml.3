Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaJGVOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:14:46 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55570 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaJGVOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:14:44 -0400
Date: Tue, 7 Oct 2014 16:14:39 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Meelis Roos <mroos@ut.ee>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.17
Message-ID: <20141007161439.4b5818e7@as>
In-Reply-To: <alpine.LRH.2.11.1410072337230.7472@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410072337230.7472@adalberg.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014 23:45:20 +0300 (EEST)
Meelis Roos <mroos@ut.ee> wrote:

> > Anyway, back to 3.17. Nothing major happened during the last week, as
> > you can see from the appended shortlog. Mostly drivers (i915, nouveau,
> > ethernet, scsi, sound) and some networking fixes.  With some misc
> > noise all over.
> > 
> > Go out and test,
> 
> Unfortunately my computer still livelocks with watchdog timeouts. The
> previous reports are here: https://lkml.org/lkml/2014/9/28/40 and
> https://lkml.org/lkml/2014/9/30/217 and this time the dmesg is like that 
> (config is also below):
> 

Unforunately the fixes for this did not make 3.17, even though they
were available Sept. 25th:

http://marc.info/?t=141165576100004&r=1&w=2

> [87785.429264] ------------[ cut here ]------------
> [87785.429276] WARNING: CPU: 2 PID: 19638 at kernel/watchdog.c:267 watchdog_overflow_callback+0x90/0xc0()
> [87785.429278] Watchdog detected hard LOCKUP on cpu 2
> [87785.429280] Modules linked in:
> [87785.429282]  ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat dm_mod nfsv2 cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative snd_hrtimer snd_seq_dummy snd_seq_midi snd_seq_oss snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd sunrpc bridge stp llc tun joydev hid_generic usbhid hid x86_pkg_temp_thermal kvm_intel kvm crc32c_intel aesni_intel i915 aes_x86_64 glue_helper lrw gf128mul snd_hda_codec_realtek snd_hda_codec_generic ablk_helper cryptd i2c_algo_bit video drm_kms_helper iTCO_wdt psmouse pcspkr iTCO_vendor_support drm snd_hda_intel evdev snd_hda_controller microcode snd_hda_codec e1000e sr_mod cdrom snd_hwdep snd_pcm_oss ehci_pci snd_mixer_oss parport_pc snd_pcm ehci_hcd parport snd_timer snd usbcore sg soundcore
> [87785.429341]  tpm_tis nuvoton_cir i2c_i801 rc_core floppy tpm ptp pps_core lpc_ich button mfd_core processor usb_common thermal_sys msr w83627ehf hwmon_vid coretemp hwmon eeprom i2c_core loop fuse autofs4
> [87785.429359] CPU: 2 PID: 19638 Comm: less Not tainted 3.17.0 #130
> [87785.429361] Hardware name:                  /DQ67OW, BIOS SWQ6710H.86A.0066.2012.1105.1504 11/05/2012
> [87785.429363]  0000000000000009 ffffffff814636f3 ffff88023e306cd0 ffffffff8104494d
> [87785.429366]  ffff880232e24000 ffff88023e306d20 ffff88023e306db8 ffff88023e306ef8
> [87785.429369]  0000000000000000 ffffffff810449b7 ffffffff816e7fc0 0000000000000020
> [87785.429373] Call Trace:
> [87785.429375]  <NMI>  [<ffffffff814636f3>] ? dump_stack+0x41/0x51
> [87785.429385]  [<ffffffff8104494d>] ? warn_slowpath_common+0x6d/0x90
> [87785.429388]  [<ffffffff810449b7>] ? warn_slowpath_fmt+0x47/0x50
> [87785.429392]  [<ffffffff810c60e0>] ? watchdog_overflow_callback+0x90/0xc0
> [87785.429397]  [<ffffffff810d1a47>] ? __perf_event_overflow+0x87/0x2c0
> [87785.429401]  [<ffffffff8101d0b5>] ? intel_pmu_handle_irq+0x1d5/0x390
> [87785.429406]  [<ffffffff81015c86>] ? perf_event_nmi_handler+0x26/0x40
> [87785.429410]  [<ffffffff810068e1>] ? nmi_handle+0x61/0xc0
> [87785.429413]  [<ffffffff81006a03>] ? do_nmi+0xc3/0x340
> [87785.429418]  [<ffffffff8146a91a>] ? end_repeat_nmi+0x1e/0x2e
> [87785.429423]  [<ffffffff81093f7b>] ? lock_hrtimer_base.isra.29+0x1b/0x40
> [87785.429427]  [<ffffffff81093f7b>] ? lock_hrtimer_base.isra.29+0x1b/0x40
> [87785.429430]  [<ffffffff81093f7b>] ? lock_hrtimer_base.isra.29+0x1b/0x40
> [87785.429432]  <<EOE>>  <IRQ>  [<ffffffff810944ba>] ? hrtimer_try_to_cancel+0x1a/0x80
> [87785.429439]  [<ffffffff8109453a>] ? hrtimer_cancel+0x1a/0x20
> [87785.429442]  [<ffffffff810a1a1d>] ? tick_nohz_restart+0xd/0x80
> [87785.429445]  [<ffffffff810a1e3c>] ? __tick_nohz_full_check+0x9c/0xa0
> [87785.429448]  [<ffffffff810c891c>] ? irq_work_run_list+0x3c/0x70
> [87785.429451]  [<ffffffff810c8965>] ? irq_work_run+0x15/0x40
> [87785.429454]  [<ffffffff81093aff>] ? update_process_times+0x4f/0x60
> [87785.429457]  [<ffffffff810a1957>] ? tick_sched_timer+0x37/0x60
> [87785.429461]  [<ffffffff810943f1>] ? __run_hrtimer.isra.32+0x41/0xf0
> [87785.429464]  [<ffffffff8109478f>] ? hrtimer_interrupt+0xef/0x240
> [87785.429468]  [<ffffffff8102cce6>] ? smp_apic_timer_interrupt+0x36/0x50
> [87785.429472]  [<ffffffff81469e8a>] ? apic_timer_interrupt+0x6a/0x70
> [87785.429473]  <EOI> 
> [87785.429476] ---[ end trace c05bae025e1c336d ]---
