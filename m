Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3KASI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:08:57 -0400
Received: from nebula.mojo.cc ([46.4.89.19]:42179 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab3KASIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:08:55 -0400
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
To: Borislav Petkov <bp@alien8.de>
Subject: Re: kernel 3.11.6 general protection fault
Date: Fri, 1 Nov 2013 19:08:44 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <e09ad4cb88b923ec017a516e6778b6bd@fincom.at> <201311011018.49670.Emanoil.Kotsev@fincom.at> <20131101112755.GA7518@pd.tnic>
In-Reply-To: <20131101112755.GA7518@pd.tnic>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201311011908.45113.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 01 November 2013 12:27:55 Borislav Petkov wrote:
> On Fri, Nov 01, 2013 at 10:18:49AM +0100, MPhil. Emanoil Kotsev wrote:
> > On Thursday 31 October 2013 17:44:03 you wrote:
> > > Please do not top-post.
> >
> > Sorry for top posting
>
> No probs :). Btw, one more thing: when you reply, make sure you hit
> reply-to-all so that CC list remains intact.

yes, I didn't notice this

>
> > I tried with no success. I remember that I also tested this with an
> > older version 3.3.8 which was working fine before, but now it dies (it
> > was not locked however, so I could reboot) If you notice this kernel
> > was not tainted.
>
> Right, the fact that you're triggering it with different kernels could
> point at a hardware issue, maybe DIMMs going bad.

I already checked this (before bothering people like you)

>
> You could try taking out DIMMs one by one and see whether it still
> happens. Somewhere it said the BIOS version is from 2006 so it is kinda
> of an older box so I can imagine stuff going kaputtski :)
>
> And the #GP below doesn't point at DRM anywhere which strengthens the
> suspicion of a hw issue.
>
> > Oct 17 14:40:36 maistor kernel: general protection fault: 0000 [#1]
> > PREEMPT SMP
> > Oct 17 14:40:36 maistor kernel: CPU 0
> > Oct 17 14:40:36 maistor kernel: Modules linked in: snd_hrtimer nfs lockd
> > nfs_acl sunrpc iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> > nf_defrag_ipv4 acpi
> > _cpufreq mperf iptable_mangle iptable_filter ip_tables x_tables
> > cpufreq_ondemand cpufreq_powersave cpufreq_performance cpufreq_stats
> > freq_table cpufreq_conse
> > rvative parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_ipmi
> > ipmi_msghandler acpi_pad sbs sbshc pci_slot fan binfmt_misc uinput fuse
> > af_packet i
> > pv6 firewire_sbp2 uvcvideo videobuf2_core snd_usb_audio videodev
> > snd_usbmidi_lib v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops
> > snd_hda_codec_idt snd
> > _hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
> > snd_seq_dummy snd_seq_oss snd_seq_midi yenta_socket snd_rawmidi
> > snd_seq_midi_event snd_s
> > eq snd_timer snd_seq_device snd pcmcia_rsrc iTCO_wdt iTCO_vendor_support
> > arc4 iwl3945 iwlegacy mac80211 soundcore cfg80211 rfkill i2c_i801
> > 8250_pnp dell_wmi
> > sparse_keymap processor snd_page_alloc wmi dcdbas rtc_cmos 8250 evdev
> > joydev battery a
> > Oct 17 14:40:36 maistor kernel: c serial_core sha256_generic cryptd
> > aes_x86_64 aes_generic cbc usbhid hid loop dm_crypt dm_mod usb_storage
> > usb_libusual uas i
> > 915 cfbfillrect cfbimgblt thermal sd_mod sg sr_mod cdrom firewire_ohci
> > firewire_core crc_itu_t b44 ssb mmc_core mii video uhci_hcd pcmcia
> > pcmcia_core ehci_hc
> > d button cfbcopyarea i2c_algo_bit drm_kms_helper usbcore intel_agp
> > intel_gtt drm usb_common agpgart i2c_core thermal_sys hwmon [last
> > unloaded: scsi_wait_scan
> > ]
> > Oct 17 14:40:36 maistor kernel:
> > Oct 17 14:40:36 maistor kernel: Pid: 6082, comm: firefox Not tainted
> > 3.3.8eko2 #4 Dell Inc. Latitude D520                   /0NF743
> > Oct 17 14:40:36 maistor kernel: RIP: 0010:[<ffffffff8117076f>]
> > [<ffffffff8117076f>] plist_del+0x3b/0x66
> > Oct 17 14:40:36 maistor kernel: RSP: 0018:ffff880032025ce0  EFLAGS:
> > 00010246 Oct 17 14:40:36 maistor kernel: RAX: ffff880032131cf0 RBX:
> > ffff8800322212f0 RCX: fcff880032131cf0
> > Oct 17 14:40:36 maistor kernel: RDX: ffff880032131cf0 RSI:
> > ffffffff8150f338 RDI: ffff880032131ce8
> > Oct 17 14:40:36 maistor kernel: RBP: ffff880032131ce8 R08:
> > fcff880032131cf0 R09: ffff880032025f08
> > Oct 17 14:40:36 maistor kernel: R10: 000000007fffffff R11:
> > 0000000000000283 R12: ffffffff8150f330
> > Oct 17 14:40:36 maistor kernel: R13: ffffffff8150fdf8 R14:
> > 0000000000000000 R15: 0000000000000000
> > Oct 17 14:40:36 maistor kernel: FS:  00007fc2ec3e4740(0000)
> > GS:ffff88007f400000(0000) knlGS:0000000000000000
> > Oct 17 14:40:36 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > Oct 17 14:40:36 maistor kernel: CR2: 00002ac4fd23b000 CR3:
> > 000000003221e000 CR4: 00000000000006f0
> > Oct 17 14:40:36 maistor kernel: DR0: 0000000000000000 DR1:
> > 0000000000000000 DR2: 0000000000000000
> > Oct 17 14:40:36 maistor kernel: DR3: 0000000000000000 DR6:
> > 00000000ffff0ff0 DR7: 0000000000000400
> > Oct 17 14:40:36 maistor kernel: Process firefox (pid: 6082, threadinfo
> > ffff880032024000, task ffff8800320cb2b0)
> > Oct 17 14:40:36 maistor kernel: Stack:
> > Oct 17 14:40:36 maistor kernel: ffffffff8105f7cd 0000000000000000
> > 0000000000000000 ffff880032131ce8
> > Oct 17 14:40:36 maistor kernel: ffffffff81060d51 00000000525fdac4
> > ffff880032025d58 ffff880000000001
> > Oct 17 14:40:36 maistor kernel: 0000000055aa3e58 ffffffff8150f320
> > 0000000100000001 ffffffff8150f338
> > Oct 17 14:40:36 maistor kernel: Call Trace:
> > Oct 17 14:40:36 maistor kernel: [<ffffffff8105f7cd>] ?
> > wake_futex+0x16/0x45 Oct 17 14:40:36 maistor kernel: [<ffffffff81060d51>]
> > ?
> > futex_requeue+0x4a2/0x690
> > Oct 17 14:40:36 maistor kernel: [<ffffffff81061042>] ?
> > do_futex+0x103/0x8be Oct 17 14:40:36 maistor kernel: [<ffffffff810c303e>]
> > ? do_sync_read+0xb1/0xea Oct 17 14:40:36 maistor kernel:
> > [<ffffffff81253289>] ?
> > sys_recvfrom+0x113/0x12b
> > Oct 17 14:40:36 maistor kernel: [<ffffffff81061927>] ?
> > sys_futex+0x12a/0x142 Oct 17 14:40:36 maistor kernel:
> > [<ffffffff810c3b56>] ? sys_read+0x62/0x6e Oct 17 14:40:36 maistor kernel:
> > [<ffffffff812eafa2>] ?
> > system_call_fastpath+0x16/0x1b
> > Oct 17 14:40:36 maistor kernel: Code: 18 48 39 f0 74 1d 48 8b 48 f0 48 8d
> > 70 f0 48 39 f1 75 10 49 89 48 08 4c 89 40 f0 48 89 50 f8 48 89 4f 08 48
> > 8b 4f 08 48 8b 47 10 <48> 89 41 08 48 89 08 48 89 57 08 48 89 57 10 48 8b
> > 4f 18 48 8b Oct 17 14:40:36 maistor kernel: RSP <ffff880032025ce0>
> > Oct 17 14:40:36 maistor kernel: ---[ end trace a3d22cd9bf0e297f ]---
> > Oct 17 14:40:36 maistor kernel: note: firefox[6082] exited with
> > preempt_count 2
> > Oct 17 14:40:50 maistor shutdown[18878]: shutting down for system reboot
>
> [ … ]
>
> > I did system upgrade recently. The thing is I never had time to watch
> > youtube
>
> what exactly do you mean by "system upgrade"? Hardware, distro upgrade?
I'm using debian with kde-trinity. I upgraded from squeeze to wheeze.
I looked yesterday into the package list and found few packages remainded 
still configured, so I cleaned all up.
>
> > I'm wondering if this matters
>
> Nah.
>
> > [*] Detect Hard and Soft Lockups
>
> That's just the watchdog which checks whether your machine is doing any
> progress.

OK thanks.
I revisited the .config and removed/added some options which were 
(not)recommended, compiled and rebooted. For now it was working fine all day 
long without an issue. If it keeps working it would be great. However I don't 
think it's worth to track it further down. It might have been some unlucky 
combination of events.

regards
