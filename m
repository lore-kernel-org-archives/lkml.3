Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaCIUHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 16:07:12 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:39049 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaCIUHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 16:07:09 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Johannes Berg <johannes.berg@intel.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 2/2] brcmsmac: update comment to reflect the code
Date: Sun,  9 Mar 2014 21:06:52 +0100
Message-Id: <1394395612-3510-2-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394395612-3510-1-git-send-email-emilgoode@gmail.com>
References: <1394395612-3510-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brcms_attach function is defined as static but the comment is
saying that it should not be static or gcc will issue a warning.
I believe we can remove the comment as I don't se a problem with
this function being defined as static.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 93598cd..8c5fa4e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1092,12 +1092,6 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
  * Attach to the WL device identified by vendor and device parameters.
  * regs is a host accessible memory address pointing to WL device registers.
  *
- * brcms_attach is not defined as static because in the case where no bus
- * is defined, wl_attach will never be called, and thus, gcc will issue
- * a warning that this function is defined but not used if we declare
- * it as static.
- *
- *
  * is called in brcms_bcma_probe() context, therefore no locking required.
  */
 static struct brcms_info *brcms_attach(struct bcma_device *pdev)
-- 
1.7.10.4

