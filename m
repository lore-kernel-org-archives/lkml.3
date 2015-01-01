Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbbAAP3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:29:54 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:48392 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbbAAP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:29:53 -0500
X-Greylist: delayed 1146 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2015 10:29:53 EST
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@adurom.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ipw2x00: ipw2100.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 16:32:53 +0100
Message-Id: <1420126373-27344-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
write_nic_dword_auto_inc() write_nic_auto_inc_address()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 6fabea0..fa88839 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -433,17 +433,6 @@ static inline void write_nic_byte(struct net_device *dev, u32 addr, u8 val)
 	write_register_byte(dev, IPW_REG_INDIRECT_ACCESS_DATA, val);
 }
 
-static inline void write_nic_auto_inc_address(struct net_device *dev, u32 addr)
-{
-	write_register(dev, IPW_REG_AUTOINCREMENT_ADDRESS,
-		       addr & IPW_REG_INDIRECT_ADDR_MASK);
-}
-
-static inline void write_nic_dword_auto_inc(struct net_device *dev, u32 val)
-{
-	write_register(dev, IPW_REG_AUTOINCREMENT_DATA, val);
-}
-
 static void write_nic_memory(struct net_device *dev, u32 addr, u32 len,
 				    const u8 * buf)
 {
-- 
1.7.10.4

