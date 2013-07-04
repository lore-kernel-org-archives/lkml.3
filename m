Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab3GDBzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab3GDBzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:55:36 -0400
Date: Wed, 3 Jul 2013 21:55:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: scheduling while atomic & hang.
Message-ID: <20130704015525.GA8486@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pretty context free trace. What the hell happened here?


BUG: scheduling while atomic: trinity-child0/13280/0xefffffff
INFO: lockdep is turned off.
Modules linked in: dlci dccp_ipv6 dccp_ipv4 dccp sctp bridge 8021q garp stp snd_seq_dummy tun fuse hidp rfcomm bnep can_raw can_bcm nfnetlink phonet llc2 pppoe pppox ppp_generic slhc appletalk af_rxrpc ipt_ULOG irda af_key
 can atm scsi_transport_iscsi rds rose x25 af_802154 caif_socket ipx caif p8023 psnap crc_ccitt p8022 llc bluetooth nfc rfkill netrom ax25 snd_hda_codec_realtek microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep sn
d_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
CPU: 0 PID: 13280 Comm: trinity-child0 Not tainted 3.10.0+ #40
 0000000000000000 ffff880228533ee0 ffffffff816ec1a2 ffff880228533ef8
 ffffffff816e782e 0000000000000db5 ffff880228533f60 ffffffff816f42bf
 ffff88023bdeca40 ffff880228533fd8 ffff880228533fd8 ffff880228533fd8
Call Trace:
 [<ffffffff816ec1a2>] dump_stack+0x19/0x1b
 [<ffffffff816e782e>] __schedule_bug+0x61/0x70
 [<ffffffff816f42bf>] __schedule+0x94f/0x9c0
 [<ffffffff816f487e>] schedule_user+0x2e/0x70
 [<ffffffff816f6de4>] retint_careful+0x12/0x2e
BUG: scheduling while atomic: trinity-child0/13280/0xefffffff
INFO: lockdep is turned off.
Modules linked in: dlci dccp_ipv6 dccp_ipv4 dccp sctp bridge 8021q garp stp snd_seq_dummy tun fuse hidp rfcomm bnep can_raw can_bcm nfnetlink phonet llc2 pppoe pppox ppp_generic slhc appletalk af_rxrpc ipt_ULOG irda af_key can atm scsi_transport_iscsi rds rose x25 af_802154 caif_socket ipx caif p8023 psnap crc_ccitt p8022 llc bluetooth nfc rfkill netrom ax25 snd_hda_codec_realtek microcode snd_hda_codec_hdmi pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore xfs libcrc32c
CPU: 0 PID: 13280 Comm: trinity-child0 Tainted: G        W    3.10.0+ #40
 0000000000000000 ffff880228533e80 ffffffff816ec1a2 ffff880228533e98
 ffffffff816e782e ffff880228533fd8 ffff880228533f00 ffffffff816f42bf
 ffff88023bdeca40 ffff880228533fd8 ffff880228533fd8 ffff880228533fd8
Call Trace:
 [<ffffffff816ec1a2>] dump_stack+0x19/0x1b
 [<ffffffff816e782e>] __schedule_bug+0x61/0x70
 [<ffffffff816f42bf>] __schedule+0x94f/0x9c0
 [<ffffffff816f487e>] schedule_user+0x2e/0x70
 [<ffffffff816ff169>] int_careful+0x12/0x1e
 [<ffffffff816f487e>] ? schedule_user+0x2e/0x70
 [<ffffffff816f6de4>] ? retint_careful+0x12/0x2e
Kernel panic - not syncing: Aiee, killing interrupt handler!


Box is wedged, and I won't be able to get to it until Friday to poke it.

	Dave

