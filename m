Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaHTWSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:18:12 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:36844 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaHTWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:18:09 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 0/8] Implement NAPI in et131x
Date: Wed, 20 Aug 2014 23:17:50 +0100
Message-Id: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's put a NAPI on this baby...

NAPI support was identified by Dave Miller <davem@davemloft.net> as a
must to get this driver out of staging. This patchset first tidies up
the code enough to make adding NAPI easier, and the final patch mostly
adds the 'boilerplate' NAPI code as described by:

http://www.linuxfoundation.org/collaborate/workgroups/networking/napi

The code has been tested on hardware, with no issues found to date.

**GregKH** - this patchset is based upon my previous bugfix 'Fix errors
caused by phydev->addr accesses' which is currently only on your
staging-linus branch, not staging-next - so won't apply cleanly in it's
current state. Please let me know if I need to do anything about this.

Cheers,

Mark

---
Mark Einon (8):
  staging: et131x: Use eth_mac_addr() instead of duplicating the
    functionality
  staging: et131x: Don't handle rx/tx packets when changing mtu
  staging: et131x: Use for loop to initialise contiguous registers to
    zero
  staging: et131x: Use for loop to initialise contiguous macstat
    registers to zero
  staging: et131x: Remove unnecessary i2c_wack variable
  staging: et131x: Rename NUM_PACKETS_HANDLED to MAX_PACKETS_HANDLED
  staging: et131x: Fix ET_INTR_TXDMA_ISR register name typo
  staging: et131x: Implement NAPI support

 drivers/staging/et131x/README   |   1 -
 drivers/staging/et131x/et131x.c | 271 ++++++++++------------------------------
 drivers/staging/et131x/et131x.h |  96 +-------------
 3 files changed, 69 insertions(+), 299 deletions(-)

-- 
2.1.0

