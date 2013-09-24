Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3IXXvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:51:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:32836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab3IXXvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:51:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,974,1371106800"; 
   d="scan'208";a="383070824"
From: James Ralston <james.d.ralston@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>, Neil Horman <nhorman@tuxdriver.com>
Cc: Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] i2c-ismt: add Initialize DMA buffer code ismt_access()
Date: Tue, 24 Sep 2013 16:47:55 -0700
Message-Id: <1380066475-2119-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to Initialize the DMA buffer to compensate for possible hardware data corruption.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/i2c/busses/i2c-ismt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index 8ed79a0..d3f30ea 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -393,6 +393,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 
 	desc = &priv->hw[priv->head];
 
+	/* Initialize the DMA buffer */
+	memset(priv->dma_buffer, 0, (I2C_SMBUS_BLOCK_MAX+1));
+
 	/* Initialize the descriptor */
 	memset(desc, 0, sizeof(struct ismt_desc));
 	desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, read_write);
-- 
1.7.7.6

