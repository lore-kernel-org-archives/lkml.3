Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaFYHYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:24:44 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:14796 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751755AbaFYHYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:24:43 -0400
From: Bo Shen <voice.shen@atmel.com>
To: <f.fainelli@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Bo Shen <voice.shen@atmel.com>
Subject: [RFC PATCH] phy: micrel: make phy_has_fixups attribute read correctly
Date: Wed, 25 Jun 2014 15:24:34 +0800
Message-ID: <1403681075-16181-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the fixups parameters get from dtb, it won't set has_fixups
parameters, so when read phy_has_fixups attribute, it always
present as 0.
Add this patch to make phy_has_fixups attribute read correctly.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 drivers/net/phy/micrel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index bc7c7d2..c384922 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -237,6 +237,8 @@ static int ksz9021_load_values_from_of(struct phy_device *phydev,
 
 	if (!matches)
 		return 0;
+	else
+		phydev->has_fixups = true;
 
 	if (matches < 4)
 		newval = kszphy_extended_read(phydev, reg);
@@ -330,6 +332,8 @@ static int ksz9031_of_load_skew_values(struct phy_device *phydev,
 
 	if (!matches)
 		return 0;
+	else
+		phydev->has_fixups = true;
 
 	if (matches < numfields)
 		newval = ksz9031_extended_read(phydev, OP_DATA, 2, reg);
-- 
1.8.5.2

