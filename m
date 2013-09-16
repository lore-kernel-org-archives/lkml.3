Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab3IPUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:16:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab3IPUQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:16:55 -0400
Date: Mon, 16 Sep 2013 16:16:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: koverstreet@google.com, bcrl@kvack.org
Subject: AIO free_ioctx WARN_ON triggered by fuzz-testing.
Message-ID: <20130916201644.GA21963@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, koverstreet@google.com,
	bcrl@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this while running trinity for a few hours.

	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr_events - 1);

WARNING: CPU: 1 PID: 20990 at fs/aio.c:451 free_ioctx+0x25d/0x260()
Modules linked in: tun fuse snd_seq_dummy bridge stp hidp rfcomm bnep scsi_transport_iscsi ipt_ULOG nfnetlink can_bcm can_raw nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec e1000e snd_hwdep libcrc32c snd_seq coretemp hwmon x86_pkg_temp_thermal snd_seq_device kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel usb_debug snd_pcm serio_raw pcspkr microcode snd_page_alloc ptp snd_timer snd shpchp pps_core soundcore
CPU: 1 PID: 20990 Comm: kworker/1:1 Not tainted 3.11.0+ #78 
Hardware name: Intel Corporation Shark Bay Client platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0109.R03.1301282055 01/28/2013
Workqueue: events free_ioctx
 ffffffff81a405bf ffff8801be28bcb0 ffffffff81729187 0000000000000000
 ffff8801be28bce8 ffffffff8105528d ffff8802242b6ec8 ffff8802242b6f40
 ffff8801aa6c9000 ffff8802242b70a8 ffff8801be28bfd8 ffff8801be28bcf8
Call Trace:
 [<ffffffff81729187>] dump_stack+0x4e/0x82
 [<ffffffff8105528d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8105536a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81217fed>] free_ioctx+0x25d/0x260
 [<ffffffff81084aa0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffff81077c01>] process_one_work+0x211/0x710
 [<ffffffff81077b95>] ? process_one_work+0x1a5/0x710
 [<ffffffff8107821d>] worker_thread+0x11d/0x3a0
 [<ffffffff81078100>] ? process_one_work+0x710/0x710
 [<ffffffff8108379d>] kthread+0xed/0x100
 [<ffffffff810836b0>] ? insert_kthread_work+0x80/0x80
 [<ffffffff8173c05c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810836b0>] ? insert_kthread_work+0x80/0x80
---[ end trace cd0b6492eb84e062 ]---

