Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbaJ3LFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:05:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758417AbaJ3LFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:05:49 -0400
Date: Thu, 30 Oct 2014 12:05:47 +0100
From: Jan Kara <jack@suse.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: John Johansen <john.johansen@canonical.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        jack@suse.com
Subject: Re: numerous kernel warnings from XFS with rc2
Message-ID: <20141030110547.GD28444@quack.suse.cz>
References: <1414665830.2343.4.camel@linux-0dmf.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414665830.2343.4.camel@linux-0dmf.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Thu 30-10-14 11:43:50, Oliver Neukum wrote:
> I am running XFS on top of bcache. Apparmor
> is enabled on my system. I am seeing tons of warnings like this:
  Yes, that's a bug in my patch. Dave has a fix queued in his tree. Thanks
for report.

								Honza
> 
> 2014-10-30T11:39:38.774440+01:00 linux-0dmf kernel: [  650.901837]
> WARNING: CPU: 2 PID: 2378 at mm/truncate.c:758 pagecache_isize_extended
> +0xfd/0x110()
> 2014-10-30T11:39:38.774441+01:00 linux-0dmf kernel: [  650.901838]
> Modules linked in: tun ctr ccm fuse bnep bluetooth crc16 af_packet
> ebtable_nat ebtables xt_limit xt_conntrack iptable_raw xt_CT
> iptable_filter nf_conntrack_netbios_ns nf_conntrack_broadcast
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables raid0
> tpm_infineon snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic
> intel_rapl snd_hda_intel x86_pkg_temp_thermal snd_hda_controller
> snd_hda_codec kvm_intel kvm sr_mod crct10dif_pclmul snd_hwdep
> crc32c_intel snd_pcm ghash_clmulni_intel aesni_intel ppdev ablk_helper
> arc4 parport_pc parport cryptd tpm_tis snd_seq lrw gf128mul glue_helper
> iwldvm nouveau aes_x86_64 tpm mac80211 iTCO_wdt hp_wmi
> iTCO_vendor_support sparse_keymap mxm_wmi iwlwifi cfg80211 ttm pcspkr
> serio_raw microcode rfkill drm_kms_helper cdrom drm i2c_i801 snd_timer
> snd_seq_device e1000e i2c_algo_bit snd soundcore lpc_ich mfd_core ptp
> shpchp pps_core wmi sg dm_mod autofs4 sd_mod ahci libahci libata
> scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh scsi_mod
> 2014-10-30T11:39:38.774442+01:00 linux-0dmf kernel: [  650.901877] CPU:
> 2 PID: 2378 Comm: dconf-service Tainted: P        W
> 3.18.0-rc2-12-desktop #3
> 2014-10-30T11:39:38.774443+01:00 linux-0dmf kernel: [  650.901878]
> Hardware name: Hewlett-Packard HP EliteBook 8780w/190A, BIOS L70 Ver.
> 93.01 05/17/2013
> 2014-10-30T11:39:38.774444+01:00 linux-0dmf kernel: [  650.901879]
> 0000000000000009 ffff8800498f7d38 ffffffff81674e33 0000000000000000
> 2014-10-30T11:39:38.774447+01:00 linux-0dmf kernel: [  650.901881]
> 0000000000000000 ffff8800498f7d78 ffffffff8104842c ffffea0014c50c00
> 2014-10-30T11:39:38.774448+01:00 linux-0dmf kernel: [  650.901882]
> 0000000000001000 ffff8805ff7575a8 0000000000000000 0000000000001cb6
> 2014-10-30T11:39:38.774449+01:00 linux-0dmf kernel: [  650.901884] Call
> Trace:
> 2014-10-30T11:39:38.774449+01:00 linux-0dmf kernel: [  650.901888]
> [<ffffffff81674e33>] dump_stack+0x4e/0x71
> 2014-10-30T11:39:38.774450+01:00 linux-0dmf kernel: [  650.901890]
> [<ffffffff8104842c>] warn_slowpath_common+0x7c/0xa0
> 2014-10-30T11:39:38.774450+01:00 linux-0dmf kernel: [  650.901892]
> [<ffffffff810484f5>] warn_slowpath_null+0x15/0x20
> 2014-10-30T11:39:38.774450+01:00 linux-0dmf kernel: [  650.901893]
> [<ffffffff8111b98d>] pagecache_isize_extended+0xfd/0x110
> 2014-10-30T11:39:38.774451+01:00 linux-0dmf kernel: [  650.901896]
> [<ffffffff81251ee0>] ? __xfs_get_blocks+0x550/0x550
> 2014-10-30T11:39:38.774451+01:00 linux-0dmf kernel: [  650.901897]
> [<ffffffff8111c5f2>] truncate_setsize+0x22/0x40
> 2014-10-30T11:39:38.774452+01:00 linux-0dmf kernel: [  650.901899]
> [<ffffffff81267c0b>] xfs_setattr_size+0x10b/0x3e0
> 2014-10-30T11:39:38.774452+01:00 linux-0dmf kernel: [  650.901901]
> [<ffffffff812756ce>] ? xfs_trans_commit+0x13e/0x220
> 2014-10-30T11:39:38.774453+01:00 linux-0dmf kernel: [  650.901904]
> [<ffffffff8125ccd7>] xfs_file_fallocate+0x2e7/0x300
> 2014-10-30T11:39:38.774453+01:00 linux-0dmf kernel: [  650.901907]
> [<ffffffff81165aa4>] ? __sb_start_write+0x44/0xd0
> 2014-10-30T11:39:38.774454+01:00 linux-0dmf kernel: [  650.901910]
> [<ffffffff81374ac3>] ? apparmor_file_permission+0x13/0x20
> 2014-10-30T11:39:38.774454+01:00 linux-0dmf kernel: [  650.901911]
> [<ffffffff811617aa>] do_fallocate+0x12a/0x1d0
> 2014-10-30T11:39:38.774455+01:00 linux-0dmf kernel: [  650.901912]
> [<ffffffff81161893>] SyS_fallocate+0x43/0x70
> 2014-10-30T11:39:38.774455+01:00 linux-0dmf kernel: [  650.901915]
> [<ffffffff8167b252>] system_call_fastpath+0x12/0x17
> 2014-10-30T11:39:38.774456+01:00 linux-0dmf kernel: [  650.901916]
> ---[ end trace 584b070525fc4efe ]---
> 2014-10-30T11:39:39.871450+01:00 linux-0dmf kernel: [  651.997869]
> ------------[ cut here ]------------
> 
> 	Regards
> 		Oliver
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
