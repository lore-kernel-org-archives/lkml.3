Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3HGFwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab3HGFwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:52:07 -0400
Date: Wed, 7 Aug 2013 01:51:57 -0400
From: Dave Jones <davej@redhat.com>
To: linux-mm@kvack.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: unused swap offset / bad page map.
Message-ID: <20130807055157.GA32278@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen while fuzzing with lots of child processes.

swap_free: Unused swap offset entry 001263f5
BUG: Bad page map in process trinity-child29  pte:24c7ea00 pmd:09fec067
addr:00007f9db958d000 vm_flags:00100073 anon_vma:ffff88022c004ba0 mapping:          (null) index:f99
Modules linked in: fuse ipt_ULOG snd_seq_dummy tun sctp scsi_transport_iscsi can_raw can_bcm rfcomm bnep nfnetlink hidp appletalk bluetooth rose can af_802154 phonet x25 af_rxrpc llc2 nfc rfkill af_key pppoe rds pppox ppp_generic slhc caif_socket caif irda crc_ccitt atm netrom ax25 ipx p8023 psnap p8022 llc snd_hda_codec_realtek pcspkr usb_debug snd_seq snd_seq_device snd_hda_intel snd_hda_codec snd_hwdep e1000e snd_pcm ptp pps_core snd_page_alloc snd_timer snd soundcore xfs libcrc32c
CPU: 1 PID: 2624 Comm: trinity-child29 Not tainted 3.11.0-rc4+ #1
 0000000000000000 ffff8801fd7ddc90 ffffffff81700f2c 00007f9db958d000
 ffff8801fd7ddcd8 ffffffff8117cba7 0000000024c7ea00 0000000000000f99
 00007f9db9600000 ffff880009fecc68 0000000024c7ea00 ffff8801fd7dde00
Call Trace:
 [<ffffffff81700f2c>] dump_stack+0x4e/0x82
 [<ffffffff8117cba7>] print_bad_pte+0x187/0x220
 [<ffffffff8117e415>] unmap_single_vma+0x535/0x890
 [<ffffffff8117f719>] unmap_vmas+0x49/0x90
 [<ffffffff81187ef1>] exit_mmap+0xc1/0x170
 [<ffffffff810510ef>] mmput+0x6f/0x100
 [<ffffffff81055818>] do_exit+0x288/0xcd0
 [<ffffffff810c1da5>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810c1e7d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810575dc>] do_group_exit+0x4c/0xc0
 [<ffffffff81057664>] SyS_exit_group+0x14/0x20
 [<ffffffff81713dd4>] tracesys+0xdd/0xe2

There were a slew of these. same trace, different addr/anon_vma/index.
mapping always null.

	Dave
