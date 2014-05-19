Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064AbaESWAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:00:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:54961 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbaESWAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:00:07 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Jan Kara <jack@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 1/1] fanotify: handling of errors when reading events
Date: Mon, 19 May 2014 23:59:54 +0200
Message-Id: <1400536794-6132-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <20140519155308.GB3427@quack.suse.cz>
References: <20140519155308.GB3427@quack.suse.cz>
X-Provags-ID: V03:K0:aDNRwXCJQW7CJVEqyBkrrTqkc2GFb3NDNrwTRMRwHPutxOrshb+
 uGIi3C8AoyMiC8JaQwfYkVBQcgnaQsvQWLyRjo+3JldhDbvBV416Kblk4eY2IadQgObqVgR
 MgwxHD7nnr5oiJ7nRXc53CQB4OuGt/t5sokqW2z1QRxfj76YHvsyOsOn+An4r2SWfn3++vS
 ZNV4aJov6akvXTraKmvQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

with LOCKDEP enabled different test codes with the patch ran fine.

What I have seen once, when stoping an application, it gave the appened
general protection fault. According to the call trace it is not related
to the patch. But still this is disturbing.

Best regards

Heinrich


May 19 23:07:47 Debian kernel: [  972.520825] general protection fault: 0000 [#1] SMP 
May 19 23:07:47 Debian kernel: [  972.520939] Modules linked in: snd_hrtimer binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd fscache sunrpc ecb btusb bluetooth rfkill iptable_filter ip_tables nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_tcpudp
ip6table_filter ip6_tables x_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack configfs fuse loop ppdev lp
hid_generic snd_usb_audio usbhid snd_usbmidi_lib hid ata_generic snd_hda_codec_via snd_hda_codec_generic sp5100_tco kvm_amd kvm
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi pcspkr snd_seq_midi_event
radeon edac_mce_amd snd_rawmidi evdev edac_core snd_seq sg snd_seq_device snd_timer k10temp ttm pata_atiixp snd drm_kms_helper
i2c_piix4 sr_mod drm soundcore cdrom i2c_algo_bit ohci_pci ehci_pci ohci_hcd ehci_hcd i2c_core parport_pc parport floppy asus_atk0110
tpm_infineon xhci_hcd tpm_tis usbcore button tpm usb_common acpi_cpufreq r8169 processor shpchp mii thermal_sys ext4 crc16 mbcache
jbd2 xts gf128mul dm_crypt dm_mod sd_mod crc_t10dif crct10dif_common ahci libahci libata scsi_mod
May 19 23:07:47 Debian kernel: [  972.523144] CPU: 1 PID: 4454 Comm: skyldav Not tainted 3.15.0-rc5+ #14
May 19 23:07:47 Debian kernel: [  972.523258] Hardware name: System manufacturer System Product Name/M3A78-VM, BIOS 2301    09/14/2010
May 19 23:07:47 Debian kernel: [  972.523413] task: ffff8801fd916750 ti: ffff8800cdef6000 task.ti: ffff8800cdef6000
May 19 23:07:47 Debian kernel: [  972.523540] RIP: 0010:[<ffffffff810ae608>]  [<ffffffff810ae608>] __lock_acquire+0x158/0x19b0
May 19 23:07:47 Debian kernel: [  972.523697] RSP: 0018:ffff8800cdef7cd0  EFLAGS: 00010002
May 19 23:07:47 Debian kernel: [  972.523789] RAX: 0000000000000001 RBX: 0000000000000246 RCX: 0000000000000000
May 19 23:07:47 Debian kernel: [  972.523910] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
May 19 23:07:47 Debian kernel: [  972.524030] RBP: ffff8800cdef7d78 R08: 0000000000000001 R09: 0000000000000000
May 19 23:07:47 Debian kernel: [  972.524150] R10: 0000000000000001 R11: 0000000225c17d03 R12: 0000000000000000
May 19 23:07:47 Debian kernel: [  972.524270] R13: ffff8801fd916750 R14: ff000000ff000098 R15: 0000000000000000
May 19 23:07:47 Debian kernel: [  972.524391] FS:  00007f1eac505880(0000) GS:ffff88020fc40000(0000) knlGS:0000000000000000
May 19 23:07:47 Debian kernel: [  972.524527] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 19 23:07:47 Debian kernel: [  972.524624] CR2: 00007f13c8c15000 CR3: 00000000ccded000 CR4: 00000000000007e0
May 19 23:07:47 Debian kernel: [  972.524744] Stack:
May 19 23:07:47 Debian kernel: [  972.524782]  0000000000000001 0000000000000000 ffff8800cdef7d48 0000000000000046
May 19 23:07:47 Debian kernel: [  972.524927]  ffffffff820310f0 ffffffff81526997 ffff8801fd916750 ffffffff81529ea7
May 19 23:07:47 Debian kernel: [  972.525070]  ffff8800cdef7de0 ffff8801fd916750 ffff8800cdef7d40 ffffffff810ae085
May 19 23:07:47 Debian kernel: [  972.525213] Call Trace:
May 19 23:07:47 Debian kernel: [  972.525268]  [<ffffffff81526997>] ? wait_for_completion+0xa7/0x100
May 19 23:07:47 Debian kernel: [  972.525379]  [<ffffffff81529ea7>] ? _raw_spin_unlock_irq+0x27/0x40
May 19 23:07:47 Debian kernel: [  972.525489]  [<ffffffff810ae085>] ? trace_hardirqs_on_caller+0x105/0x1d0
May 19 23:07:47 Debian kernel: [  972.525606]  [<ffffffff810b0642>] lock_acquire+0xa2/0x120
May 19 23:07:47 Debian kernel: [  972.525703]  [<ffffffff812bb71d>] ? lockref_put_or_lock+0xd/0x30
May 19 23:07:47 Debian kernel: [  972.525810]  [<ffffffff81529c7c>] _raw_spin_lock+0x2c/0x40
May 19 23:07:47 Debian kernel: [  972.525908]  [<ffffffff812bb71d>] ? lockref_put_or_lock+0xd/0x30
May 19 23:07:47 Debian kernel: [  972.526014]  [<ffffffff812bb71d>] lockref_put_or_lock+0xd/0x30
May 19 23:07:47 Debian kernel: [  972.526120]  [<ffffffff811ba05e>] dput+0x1e/0x110
May 19 23:07:47 Debian kernel: [  972.526204]  [<ffffffff811ac921>] path_put+0x11/0x20
May 19 23:07:47 Debian kernel: [  972.526294]  [<ffffffff811e8a11>] fanotify_free_event+0x11/0x50
May 19 23:07:47 Debian kernel: [  972.526398]  [<ffffffff811e5b34>] fsnotify_destroy_group+0x34/0x40
May 19 23:07:47 Debian kernel: [  972.526507]  [<ffffffff811e8e12>] fanotify_release+0x92/0xa0
May 19 23:07:47 Debian kernel: [  972.526608]  [<ffffffff811a4c17>] __fput+0xd7/0x1e0
May 19 23:07:47 Debian kernel: [  972.526695]  [<ffffffff811a4d59>] ____fput+0x9/0x10
May 19 23:07:47 Debian kernel: [  972.526784]  [<ffffffff81082317>] task_work_run+0x97/0xd0
May 19 23:07:47 Debian kernel: [  972.526882]  [<ffffffff81012a31>] do_notify_resume+0x61/0xa0
May 19 23:07:47 Debian kernel: [  972.526984]  [<ffffffff81533132>] int_signal+0x12/0x17
May 19 23:07:47 Debian kernel: [  972.527073] Code: 28 0f 85 52 14 00 00 48 85 db 75 4a 0f 1f 80 00 00 00 00 31 db 48 8d 65 d8 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 <49> 81 3e 00 63 c2 81 b8 00 00 00 00 44 0f 44 c0 41 83 fc 01 44 
May 19 23:07:47 Debian kernel: [  972.527754] RIP  [<ffffffff810ae608>] __lock_acquire+0x158/0x19b0
May 19 23:07:47 Debian kernel: [  972.527866]  RSP <ffff8800cdef7cd0>
May 19 23:07:47 Debian kernel: [  972.564730] ---[ end trace f93d0aa07d22b3f0 ]---
