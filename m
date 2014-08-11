Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaHKTQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:16:46 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58461 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaHKTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:16:44 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Hyong-Youb Kim <hykim@myri.com>, netdev@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] net: ethernet: myricom: myri10ge: myri10ge.c:  Cleaning up missing null-terminate after strncpy call
Date: Mon, 11 Aug 2014 21:18:16 +0200
Message-Id: <1407784696-31698-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index f3d5d79..69c26f0 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -574,6 +574,7 @@ myri10ge_validate_firmware(struct myri10ge_priv *mgp,
 
 	/* save firmware version for ethtool */
 	strncpy(mgp->fw_version, hdr->version, sizeof(mgp->fw_version));
+	mgp->fw_version[sizeof(mgp->fw_version) - 1] = '\0';
 
 	sscanf(mgp->fw_version, "%d.%d.%d", &mgp->fw_ver_major,
 	       &mgp->fw_ver_minor, &mgp->fw_ver_tiny);
-- 
1.7.10.4

