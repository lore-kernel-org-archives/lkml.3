Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaHQPu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:50:57 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63368 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaHQPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:50:56 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21488.53083.883671.418873@gargle.gargle.HOWL>
Date: Sun, 17 Aug 2014 17:50:51 +0200
To: linux-kernel@vger.kernel.org
Subject: [BUG] 3.17-rc1 radeon screen corruption and hang
X-Mailer: VM 8.1.2 under 24.3.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one of my machines, an Ivy Bridge desktop with a Radeon X550 (RV370)
graphics card, 3.17-rc1 causes random screen corruption with X running.
Eventually X stopped honoring mouse or keyboard clicks, and when I tried
to reboot it via an ssh login from another machine, it hanged hard.
3.16 and earlier kernels work perfectly.

After rebooting there was nothing interesting in /var/log/messages, but
Xorg.0.log.old showed the following:

(EE) [mi] EQ overflowing.  Additional events will be discarded until existing events are processed.
(EE) 
(EE) Backtrace:
(EE) 0: X (mieqEnqueue+0x22b) [0x57728b]
(EE) 1: X (QueuePointerEvents+0x52) [0x44db12]
(EE) 2: /usr/lib64/xorg/modules/input/evdev_drv.so (_init+0x2c4d) [0x7f287fbf7b1d]
(EE) 3: X (DPMSSupported+0xe8) [0x486498]
(EE) 4: X (xf86SerialModemClearBits+0x230) [0x4aea80]
(EE) 5: /lib64/libpthread.so.0 (__restore_rt+0x0) [0x7f28859f2f8f]
(EE) 6: /lib64/libc.so.6 (ioctl+0x7) [0x7f28846f5eb7]
(EE) 7: /lib64/libdrm.so.2 (drmIoctl+0x34) [0x7f28857db6c4]
(EE) 8: /lib64/libdrm.so.2 (drmCommandWrite+0x1e) [0x7f28857dd84e]
(EE) 9: /lib64/libdrm_radeon.so.1 (_init+0x4c1) [0x7f288032e511]
(EE) 10: /lib64/libdrm_radeon.so.1 (_init+0x6c4) [0x7f288032e924]
(EE) 11: /usr/lib64/xorg/modules/drivers/radeon_drv.so (_init+0x1af29) [0x7f2880577f09]
(EE) 12: /usr/lib64/xorg/modules/libexa.so (exaMoveOutPixmap+0x1287) [0x7f287f8fe9a7]
(EE) 13: /usr/lib64/xorg/modules/libexa.so (exaMoveOutPixmap+0x3a12) [0x7f287f903852]
(EE) 14: /usr/lib64/xorg/modules/libexa.so (exaEnableDisableFBAccess+0x481a) [0x7f287f90deda]
(EE) 15: /usr/lib64/xorg/modules/libexa.so (exaEnableDisableFBAccess+0x15b4) [0x7f287f907cb4]
(EE) 16: X (DamageRegionAppend+0x592) [0x521a92]
(EE) 17: X (AddTraps+0x3b8a) [0x51e99a]
(EE) 18: X (SendErrorToClient+0x3f7) [0x437217]
(EE) 19: X (_init+0x3aa2) [0x429db2]
(EE) 20: /lib64/libc.so.6 (__libc_start_main+0xf5) [0x7f288462ab45]
(EE) 21: X (_start+0x29) [0x426a21]
(EE) 22: ? (?+0x29) [0x29]

This repeated a number of times, and the last entry was prefixed by:

(EE) [mi] EQ overflow continuing.  1000 events have been dropped.
(EE) [mi] No further overflow reports will be reported until the clog is cleared.

User-space is Fedora 19 / x86_64 with latest updates.  No non-Fedora X drivers.

/Mikael
