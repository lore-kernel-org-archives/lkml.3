Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab3BLWlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:15 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18852 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3BLWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:14 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/9] revive the XD driver a bit
Date: Tue, 12 Feb 2013 23:40:50 +0100
Message-Id: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I use this driver. I have an old PC XT 8088, and the fact
that it was in the kernel tree SAVED MY DATA.

Of course I couldn't boot Linux on that old machine. But I
removed the disk and the controller card and put it into
a Pentium MMX. The ROM on the card has to be removed or it
will kill the boot by trying to patchextends the BIOS. Then
you have to configure out the IRQ and DMA manually in the
BIOS menu.

But then you pass the controller type to the driver with
xd=3 and it *WORKS*, well after the first two patches in
this series. I proceeded to do some rough cleanups to get
it more maintainable.

Linus Walleij (9):
  block: xd: introduce a delay before every outb operation
  block: xd: fix up request handler loop
  block: xd: raise timeouts
  block: xd: some whitespace and #if 0 removal
  block: xd: avoid using typedefs
  block: xd: avoid some forward declarations
  block: xd: merge header file into driver
  block: xd: remove custom DEBUG print system
  block: xd: replace all printks with pr_*

 drivers/block/xd.c | 1202 ++++++++++++++++++++++++++++++----------------------
 drivers/block/xd.h |  134 ------
 2 files changed, 686 insertions(+), 650 deletions(-)
 delete mode 100644 drivers/block/xd.h

-- 
1.8.1.2

