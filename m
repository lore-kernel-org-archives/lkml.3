Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaHXSZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 14:25:11 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:34606 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaHXSZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 14:25:09 -0400
Date: Sun, 24 Aug 2014 20:25:06 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: WARNING: CPU: 0 PID: 197 at fs/proc/generic.c:521
 remove_proc_entry+0x142/0x159()
Message-ID: <20140824182506.GC24125@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Trond Myklebust <trond.myklebust@primarydata.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20140822195440.GD12398@glanzmann.de>
 <CAHQdGtQOypEzD=72Q9ynC8x1bQKh6KM5aJFc1ghRhQihxcxnoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAHQdGtQOypEzD=72Q9ynC8x1bQKh6KM5aJFc1ghRhQihxcxnoA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Trond,

> > [  227.620134] ------------[ cut here ]------------
> > [  227.620152] WARNING: CPU: 0 PID: 197 at fs/proc/generic.c:510 remove_proc_entry+0xde/0x159()
> > [  227.620163] name 'fs/nfsfs'
> > [  227.620170] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport autofs4 ecb btusb bluetooth uinput hid_generic usbhid hid deflate ctr twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common blowfish_generic blowfish_x86_64 blowfish_common des_generic cbc xcbc rmd160 sha512_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop snd_hda_codec_realtek snd_hda_codec_generic arc4 b43 rng_core bcma mac80211 cfg80211 rfkill evdev coretemp kvm_intel ssb applesmc pcspkr input_polldev kvm pcmcia pcmcia_core mmc_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore ohci_pci ohci_hcd ehci_pci ehci_hcd shpchp usbcore usb_common i2c_nforce2 acpi_cpufreq button processor thermal_sys ext4 crc16 jbd2 mbcache xor raid6_pq dm_mod netconsole configfs sg sd_mod crc_t10dif crct10dif_common sr_mod cdrom ata_generic firewire_ohci ahci libahci libata microcode firewire_core crc_itu_t scsi_mod forcedeth
> > [  227.620691] CPU: 0 PID: 197 Comm: kworker/u4:4 Tainted: G        W      3.17.0-rc1+ #182
> > [  227.620697] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
> > [  227.620706] Workqueue: netns cleanup_net
> > [  227.620712]  0000000000000000 0000000000000009 ffffffff81398aee ffff8800b92cbcf8
> > [  227.620731]  ffffffff8103d10f 0000000000000246 ffffffff81162299 ffff8800a7ccd240
> > [  227.620743]  0000000000000000 ffffffffa0679108 ffff88013b298b70 ffffffffa067910b
> > [  227.620760] Call Trace:
> > [  227.620771]  [<ffffffff81398aee>] ? dump_stack+0x41/0x51
> > [  227.620780]  [<ffffffff8103d10f>] ? warn_slowpath_common+0x78/0x90
> > [  227.620787]  [<ffffffff81162299>] ? remove_proc_entry+0xde/0x159
> > [  227.620800]  [<ffffffff8103d1bf>] ? warn_slowpath_fmt+0x45/0x4a
> > [  227.620806]  [<ffffffff81162299>] ? remove_proc_entry+0xde/0x159
> > [  227.620823]  [<ffffffffa06681d6>] ? nfs_net_exit+0x9/0x12 [nfs]
> > [  227.620828]  [<ffffffff812dcc39>] ? ops_exit_list+0x27/0x48
> > [  227.620837]  [<ffffffff812dd450>] ? cleanup_net+0xe5/0x182
> > [  227.620843]  [<ffffffff8104e683>] ? process_one_work+0x168/0x26a
> > [  227.620850]  [<ffffffff8104e96a>] ? worker_thread+0x1c0/0x28d
> > [  227.620856]  [<ffffffff8104e7aa>] ? process_scheduled_works+0x25/0x25
> > [  227.620863]  [<ffffffff810520ee>] ? kthread+0x99/0xa1
> > [  227.620870]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> > [  227.620878]  [<ffffffff8139cdec>] ? ret_from_fork+0x7c/0xb0
> > [  227.620884]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> > [  227.620890] ---[ end trace 8bd56692dd859f1c ]---
> > [  227.788111] ------------[ cut here ]------------

> See the thread on
> http://lkml.kernel.org/r/1408217806-25877-1-git-send-email-xiyou.wangcong@gmail.com

Thank you. I'll keep an eye on it and see if it is fixed in the next RC.

Cheers,
        Thomas
