Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab3E2Hfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:35:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44258 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935099Ab3E2Hft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:35:49 -0400
From: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
To: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] i2c: omap: correct usage of the interrupt enable register
Date: Wed, 29 May 2013 10:35:43 +0300
Message-ID: <1369812944-685-1-git-send-email-oleksandr.dmytryshyn@ti.com>
X-Mailer: git-send-email 1.8.2.rc2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupts from i2c controller are enabled while i2c bus is in the
suspend mode (I2C_IE register doesn't equals to 0).

Starting from the OMAP chips with version2 registers scheme there
are 2 registers (I2C_IRQENABLE_SET and I2C_IRQENABLE_CLR) to manage
interrupts instead of the older OMAP chips old scheme which have
only one register (I2C_IE). Now for enabling interrupts we must
use I2C_IRQENABLE_SET register and for disabling interrupts we must
use I2C_IRQENABLE_CLR register.

Next patch fixes it.

Patch is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
tag: v3.10-rc2

Verified on OMAP4430.

Oleksandr Dmytryshyn (1):
  i2c: omap: correct usage of the interrupt enable register

 drivers/i2c/busses/i2c-omap.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
1.8.2.rc2

