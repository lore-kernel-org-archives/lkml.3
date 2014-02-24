Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaBXRaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:30:03 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60809 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaBXRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:30:00 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH 0/2] mtd: nand: add manafacturer specific handling
Date: Mon, 24 Feb 2014 18:29:51 +0100
Message-Id: <1393262993-22040-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a proposal to add support for manufacturer specific handling of
NAND chips.

Currently the only ones allowed to modify how NAND chips are accessed are
NAND controllers (by modifying the nand_chip callbacks) and NAND core code
(by setting default callbacks when these are not specified by the NAND
controller).

This series adds support for manufacturer/vendor specific handling, which is
particularly useful for read retry implementation that are (at least for
the moment) manufacturer specific.

I know there was a debate on how we should support all these READ RETRY
implementations (see http://permalink.gmane.org/gmane.linux.drivers.mtd/50603),
so please tell if I'm wrong.

Best Regards,

Boris


Boris BREZILLON (2):
  mtd: nand: add manufacturer specific init infrastructure
  mtd: nand: add hynix specific initializer

 drivers/mtd/nand/Makefile     |    2 +-
 drivers/mtd/nand/nand_base.c  |    7 ++
 drivers/mtd/nand/nand_hynix.c |  151 +++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/nand_ids.c   |    3 +-
 include/linux/mtd/nand.h      |    6 ++
 5 files changed, 167 insertions(+), 2 deletions(-)
 create mode 100644 drivers/mtd/nand/nand_hynix.c

-- 
1.7.9.5

