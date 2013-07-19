Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766Ab3GSRdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:33:02 -0400
Received: from smtp1.uu.se ([130.238.7.54]:47116 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3GSRdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:33:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20969.30581.961878.138915@pilspetsen.it.uu.se>
Date: Fri, 19 Jul 2013 19:29:25 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [3.11-rc1 regression] ext4_evict_inode triggers warn_slowpath_common on sparc64
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I keep getting the following warning with 3.11-rc1 on sparc64:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8174 at fs/ext4/inode.c:230 ext4_evict_inode+0x1f0/0x448()
Modules linked in: sunrpc af_packet ipv6 hid_generic snd_ali5451 snd_ac97_codec snd_seq snd_seq_device snd_pcm tg3 snd_timer flash ohci_pci hwmon snd soundcore ptp evdev sg i2c_ali1535 ohci_hcd pps_core snd_page_alloc i2c_core ac97_bus sr_mod cdrom pata_ali libata
CPU: 1 PID: 8174 Comm: xgcc Not tainted 3.11.0-rc1 #1
Call Trace:
 [00000000004537b0] warn_slowpath_common+0x4c/0x64
 [0000000000540d78] ext4_evict_inode+0x1f0/0x448
 [00000000004f3938] evict+0xb8/0x190
 [00000000004e99bc] do_unlinkat+0xf4/0x160
 [0000000000406174] linux_sparc_syscall32+0x34/0x40
---[ end trace cd72b9e3e68d89e4 ]---

The Comm varies, but the call trace always looks like that.  Happens a couple
of times per day, so far.  No other ill effects observed.  Didn't happen in 3.10
or older kernels.
