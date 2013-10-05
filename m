Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3JEAwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 20:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab3JEAwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 20:52:20 -0400
Date: Fri, 4 Oct 2013 20:52:10 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
Subject: fs/attr.c:notify_change locking warning.
Message-ID: <20131005005210.GA25773@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: CPU: 3 PID: 26128 at fs/attr.c:178 notify_change+0x34d/0x360()
Modules linked in: dlci 8021q garp sctp snd_seq_dummy bridge stp tun fuse rfcomm hidp ipt_ULOG nfc caif_socket caif af_802154 phonet af_rxrpc bnep bluetooth rfkill can_bcm can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds scsi_transport_iscsi nfnetlink af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm snd_hda_codec_hdmi xfs snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc libcrc32c snd_timer crct10dif_pclmul crc32c_intel snd ghash_clmulni_intel e1000e microcode usb_debug serio_raw pcspkr ptp soundcore pps_core shpchp
CPU: 3 PID: 26128 Comm: trinity-child57 Not tainted 3.12.0-rc3+ #93 
 ffffffff81a3e2ec ffff880071d71bb8 ffffffff8172a763 0000000000000000
 ffff880071d71bf0 ffffffff810552cd 0000000000000a00 ffff88023d6e8b90
 0000000000008ad0 ffff880071d71c50 ffff8802392882c8 ffff880071d71c00
Call Trace:
 [<ffffffff8172a763>] dump_stack+0x4e/0x82
 [<ffffffff810552cd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff810553aa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811e388d>] notify_change+0x34d/0x360
 [<ffffffff811e18e7>] file_remove_suid+0x87/0xa0
 [<ffffffff811e9019>] ? __mnt_drop_write+0x29/0x50
 [<ffffffff811e90a2>] ? __mnt_drop_write_file+0x12/0x20
 [<ffffffff811e1e6a>] ? file_update_time+0x8a/0xd0
 [<ffffffffa01a4e7a>] xfs_file_aio_write_checks+0xea/0xf0 [xfs]
 [<ffffffffa01a4f50>] xfs_file_dio_aio_write+0xd0/0x3e0 [xfs]
 [<ffffffffa01a5629>] xfs_file_aio_write+0x129/0x130 [xfs]
 [<ffffffff811c45dc>] do_sync_readv_writev+0x4c/0x80
 [<ffffffff811c5aab>] do_readv_writev+0xbb/0x240
 [<ffffffffa01a5500>] ? xfs_file_buffered_aio_write+0x2a0/0x2a0 [xfs]
 [<ffffffff811c4500>] ? do_sync_read+0x90/0x90
 [<ffffffff81734721>] ? _raw_spin_unlock+0x31/0x60
 [<ffffffff810c9a86>] ? trace_hardirqs_on_caller+0x16/0x1e0
 [<ffffffff811c5cc8>] vfs_writev+0x38/0x60
 [<ffffffff811c5e10>] SyS_writev+0x50/0xd0
 [<ffffffff8173d8e4>] tracesys+0xdd/0xe2
---[ end trace 201843ae71ab5a7c ]---


177 
178         WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
179 


