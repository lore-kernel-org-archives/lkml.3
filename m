Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaHEB2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaHEB2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:28:53 -0400
Date: Mon, 4 Aug 2014 21:28:45 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: btrfs extents related oops.
Message-ID: <20140805012845.GA7836@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Possibly related to some changes I've been making to my fuzz tester today
to operate on the same file from multiple threads.
This was on v3.16-829-g98959948a7ba, but probably exists on earlier trees too
given the lack of btrfs specific commits so far this merge window.

BTRFS: __set_extent_bit: ino 138120 isize 12041673 odd range [18446744069414584347,18446744069414588442]
BTRFS: clear_extent_bit: ino 138120 isize 12041673 odd range [18446744069414584347,18446744069414588442]
BTRFS: __set_extent_bit: ino 138120 isize 1297036692924383232 odd range [18446744073441116159,18446744073441120254]
BTRFS: clear_extent_bit: ino 138120 isize 1297036692924383232 odd range [18446744073441116159,18446744073441120254]
BTRFS: __set_extent_bit: ino 138122 isize 1044 odd range [18446744073575325309,18446744073575329404]
BTRFS: clear_extent_bit: ino 138122 isize 1044 odd range [18446744073575325309,18446744073575329404]
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3881 at fs/btrfs/extent_io.c:430 insert_state+0x131/0x150 [btrfs]()
BTRFS: end < start 4094 18446744073709551615
Modules linked in: llc2 af_key ipt_ULOG sctp libcrc32c can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth 6lowpan_iphc can_raw can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm btrfs xor crct10dif_pclmul snd_hda_codec_realtek crc32c_intel snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_controller ghash_clmulni_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm raid6_pq microcode snd_timer snd serio_raw usb_debug pcspkr soundcore shpchp e1000e ptp pps_core
CPU: 0 PID: 3881 Comm: trinity-c118 Not tainted 3.16.0+ #32
 0000000000000009 0000000011a27d09 ffff8800991c3c90 ffffffffa67e717a
 ffff8800991c3cd8 ffff8800991c3cc8 ffffffffa6078f4d 0000000000000ffe
 ffff88006ca6bd88 ffff8802252980c8 ffffffffffffffff ffff8800991c3dd8
Call Trace:
 [<ffffffffa67e717a>] dump_stack+0x4e/0x7a
 [<ffffffffa6078f4d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffffa6078fcc>] warn_slowpath_fmt+0x5c/0x80
 [<ffffffffc04c2b64>] ? __set_extent_bit+0xd4/0x670 [btrfs]
 [<ffffffffc04c28b1>] insert_state+0x131/0x150 [btrfs]
 [<ffffffffc04c2c22>] __set_extent_bit+0x192/0x670 [btrfs]
 [<ffffffffa60b8b7b>] ? preempt_count_sub+0xab/0x100
 [<ffffffffc04c3fc4>] lock_extent_bits+0x94/0x320 [btrfs]
 [<ffffffffc04b66ee>] ? btrfs_file_llseek+0x4e/0x2b0 [btrfs]
 [<ffffffffc04b678f>] btrfs_file_llseek+0xef/0x2b0 [btrfs]
 [<ffffffffa6207b14>] compat_SyS_lseek+0x94/0xc0
 [<ffffffffa67f5059>] ia32_do_call+0x13/0x13
---[ end trace f8236b601b8385e5 ]---


