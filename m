Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935150Ab3DHIgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:36:54 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:44986 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694Ab3DHIgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:36:52 -0400
X-Greylist: delayed 1258 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 04:36:51 EDT
Date: Mon, 8 Apr 2013 11:15:50 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org
Subject: WARNING: at mm/mmap.c:2702 exit_mmap+0x134/0x160() (SIGILL on
 sparc64)
Message-ID: <alpine.SOC.1.00.1304081109080.17009@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While compiling 3.9-5rc6 on sparc64 (Ultrasparc-II Netra X1), I got the 
following error:

[604143.245710] WARNING: at mm/mmap.c:2702 exit_mmap+0x134/0x160()
[604143.323469] Modules linked in: ipv6 loop ohci_hcd i2c_ali15x3 usbcore i2c_ali1535 usb_common i2c_core
[604143.445845] Call Trace:
[604143.479021]  [00000000004b7f54] exit_mmap+0x134/0x160
[604143.546570]  [00000000004516ec] mmput+0x2c/0xc0
[604143.607248]  [000000000045676c] exit_mm+0xec/0x120
[604143.671352]  [000000000045802c] do_exit+0xec/0x360
[604143.735468]  [00000000004583e4] do_group_exit+0x24/0xc0
[604143.805295]  [0000000000463424] get_signal_to_deliver+0x1a4/0x320
[604143.886545]  [0000000000443d34] do_signal32+0x14/0x220
[604143.955249]  [000000000042c640] do_signal+0x2c0/0x520
[604144.022774]  [000000000042d0a0] do_notify_resume+0x40/0x60
[604144.096054]  [0000000000404ac4] __handle_signal+0xc/0x2c
[604144.167063] ---[ end trace 485ee697b10175b2 ]---
[604144.228837] BUG: Bad rss-counter state mm:fffff8006e5123c0 idx:1 val:1

This is not reproducible. The machine has been stable for long and I 
have seen no other errors. Rerunning the same "make" produced no errors.


-- 
Meelis Roos (mroos@linux.ee)
