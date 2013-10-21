Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3JUWCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:02:49 -0400
Received: from mail-pb0-f74.google.com ([209.85.160.74]:56698 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3JUWCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:02:47 -0400
From: Nate Klein <nxk@google.com>
To: netdev@vger.kernel.org
Cc: eilong@broadcom.com, nxk@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH] net-bnx2x: Fix byte order problem on NVRAM writes
Date: Mon, 21 Oct 2013 14:57:01 -0700
Message-Id: <1382392621-8998-1-git-send-email-nxk@google.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested:
    ethtool -e eth0 raw on >first.nvram
    ethtool -E eth0 <first.nvram
    ethtool -e eth0 raw on >second.nvram
    cmp first.nvram second.nvram || ethtool -E eth0 <second.nvram
    (No output means pass.)
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 8213cc8..35671fb 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1549,7 +1549,7 @@ static int bnx2x_nvram_write_dword(struct bnx2x *bp, u32 offset, u32 val,
 	REG_WR(bp, MCP_REG_MCPR_NVM_COMMAND, MCPR_NVM_COMMAND_DONE);
 
 	/* write the data */
-	REG_WR(bp, MCP_REG_MCPR_NVM_WRITE, val);
+	REG_WR(bp, MCP_REG_MCPR_NVM_WRITE, cpu_to_be32(val));
 
 	/* address of the NVRAM to write to */
 	REG_WR(bp, MCP_REG_MCPR_NVM_ADDR,
-- 
1.8.4

