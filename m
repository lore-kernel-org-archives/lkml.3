Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3ATMYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:24:52 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:49923 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3ATMYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:24:51 -0500
X-Nat-Received: from [202.181.97.72]:58569 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1358684666.7966
To: linus.walleij@linaro.org, rob.herring@calxeda.com
Cc: grant.likely@secretlab.ca, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 20 Jan 2013 21:24:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20012013 #9113552, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm experiencing two regressions in 3.8-rcX.

Regression:

  (1) Console shows nothing, which makes it impossible to determine whether
      the system is working or not.

  (2) SCSI_SYM53C8XX_2 cannot register IRQ, showing below messages upon load.

      PCI: enabling device 0000:00:0c.0 (0100 -> 0103)
      sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 27
      sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
      sym0: request irq 27 failure
      sym0: giving up ...

While (1) was fixed by now, I can't bisect (2) since (1) is preventing (2) from
printing messages.

Bisection result:

  No problem until commit b1112249 "OMAPDSS: DISPC: cleanup lcd/digit enable/disable".

  (1) was introduced by commit 07c9249f "ARM: 7554/1: VIC: use irq_domain_add_simple()".

  (2) was introduced between commit 07c9249f "ARM: 7554/1: VIC: use irq_domain_add_simple()"
  and commit 5c49985c "Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm".

  (1) was fixed by commit 5c49985c "Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm".

  (2) is not yet fixed as of commit 5da1f88b "Merge tag 'usb-3.8-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb".

Environment:

  Host is Ubuntu 12.04 on x86_32.
  Cross compiling with ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- using
  gcc-arm-linux-gnueabi 4:4.6.2-7 and booting with arch/arm/boot/zImage using
  qemu-system 1.0.50-2012.03-0ubuntu2.1 .

Command line:

  $ qemu-system-arm -M versatilepb -hda hda.img -kernel arch/arm/boot/zImage -append "root=/dev/sda1"

Kernel config:

  http://I-love.SAKURA.ne.jp/tmp/config-3.8-rc1-arm

Regards.
