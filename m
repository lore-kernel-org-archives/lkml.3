Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3A0QOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 11:14:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:37920 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3A0QOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 11:14:17 -0500
Message-ID: <51055256.6030602@linutronix.de>
Date: Sun, 27 Jan 2013 17:14:14 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: jlmales@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel Failure - 3.4.24
References: <20130116184221.aaa9e2aa.jlmales@gmail.com>
In-Reply-To: <20130116184221.aaa9e2aa.jlmales@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 12:42 AM, John L. Males wrote:
> Hello,

Hi,

> I copied Sebastian in on the post my review of Changelogs suggests
> Sebastian is the one who will want to know about this kernel
> failure or will know who should be.

I did what? I reviewed patches since they went in this problem occurs?

> I am not on the LKML so it would be appreciated if I was CC on any
> related replies to this kernel failure which appeared to occur when
> a USB MP3 player was inserted or removed from the HP NC6400
> laptop.

Next time you post logs try to format them like this (or people might
ignore it because it is too hard to read):

> The kernel failure trace information was:
> 
> Kernel failure message 1: [327619.690505] ------------[ cut here
> ]------------ [327619.690518] WARNING: at fs/buffer.c:1106
> mark_buffer_dirty +0x8b/0xb0() [327619.690523]
Hardware name: HP Compaq nc6400 (RM100AW#ABA)
[327619.690526] Modules linked in: nls_utf8
> nls_cp437 vfat fat usb_storage option usb_wwan usbserial 
> snd_hrtimer ip6table_filter ip6_tables iptable_filter ip_tables 
> kvm_intel kvm ebtable_nat ebtables x_tables cpufreq_userspace 
> cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp 
> bnep rfcomm bluetooth crc16 ppdev lp binfmt_misc i915 
> drm_kms_helper drm i2c_algo_bit i2c_core uinput fuse loop 
> snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel 
> snd_hda_codec tpm_infineon arc4 snd_hwdep snd_pcm_oss snd_mixer_oss
> snd_pcm iwl3945 snd_seq_dummy iwlegacy snd_seq_oss usbhid
> snd_seq_midi snd_rawmidi coretemp hid snd_seq_midi_event snd_seq
> mac80211 pcmcia snd_timer irda snd_seq_device microcode snd
> cfg80211 yenta_socket psmouse joydev parport_pc tifm_7xx1 tpm_tis
> soundcore pcmcia_rsrc tifm_core pcspkr evdev snd_page_alloc
> pcmcia_core parport tpm crc_ccitt hp_wmi hp_accel lis3lv02d
> sparse_keymap serio_raw acpi_cpufreq tpm_bios rng_core rfkill mperf
> input_polldev wmi battery ac container power_supply processor video
> button ext2 mbcache dm_mod btrfs zlib_deflate crc32c libcrc32c sg
> sr_mod cdrom sd_mod crc_t10dif ata_generic pata_acpi uhci_hcd
> ata_piix libata ehci_hcd sdhci_pci scsi_mod ide_pci_generic tg3
> ide_core sdhci mmc_core libphy usbcore thermal usb_common fan 
> thermal_sys

[last unloaded: scsi_wait_scan]

[327619.690737] Pid: 31574, comm: sync Tainted: G  W
3.4.24-kernel.org-jlm-010-amd64 #1

This line looks like you have custom patches on your tree.

[327619.690741] Call Trace:
[327619.690751] [<ffffffff8105177f>] warn_slowpath_common +0x7f/0xc0
[327619.690757] [<ffffffff810517da>] warn_slowpath_null+0x1a/0x20
[327619.690762] [<ffffffff811b67fb>] mark_buffer_dirty+0x8b/0xb0
[327619.690774] [<ffffffffa028b734>] ext2_sync_super +0x94/0x100 [ext2]
[327619.690784] [<ffffffffa028b809>] ext2_sync_fs+0x69/0x80 [ext2]
[327619.690790] [<ffffffff811b4480>] ? __sync_filesystem+0x90/0x90
[327619.690795] [<ffffffff811b4453>] __sync_filesystem+0x63/0x90
[327619.690801] [<ffffffff811b449f>] sync_one_sb+0x1f/0x30
[327619.690807] [<ffffffff81188c77>] iterate_supers+0xb7/0xf0
[327619.690812] [<ffffffff811b44fa>] sys_sync+0x4a/0x70
[327619.690819] [<ffffffff814c51a9>] system_call_fastpath+0x16/0x1b
[327619.690942] ---[ end trace 7e4761e5ee97ad0c ]---

> If you need additional information please advise.

This looks like https://bugzilla.redhat.com/show_bug.cgi?id=468794

I think that I am innocent here. You probably unpluged the device
before the content was written back to the media. Could it be?

> 
> Regards,
> 
> John L. Males Toronto, Ontario Canada 16 January 2013 18:42

Sebastian
