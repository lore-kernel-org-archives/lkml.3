Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaINRbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:31:55 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36948 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaINRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:31:53 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: marvell: sky2.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 19:33:43 +0200
Message-Id: <1410716023-16068-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/marvell/sky2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index dba48a5c..7053d38 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4907,7 +4907,7 @@ static const char *sky2_name(u8 chipid, char *buf, int sz)
 	};
 
 	if (chipid >= CHIP_ID_YUKON_XL && chipid <= CHIP_ID_YUKON_OP_2)
-		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
+		strlcpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
 	else
 		snprintf(buf, sz, "(chip %#x)", chipid);
 	return buf;
-- 
1.7.10.4

