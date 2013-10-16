Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab3JPAHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:07:15 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:40225 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708Ab3JPAHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:07:13 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Simon Kelley <simon@thekelleys.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] drivers: net: wireless: Fix wrong check for reassociation request retry counter
Date: Tue, 15 Oct 2013 21:07:47 -0300
Message-Id: <1381882067-4041-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a typo where the checking for priv->ReAssociationRequestRetryCnt must
be, it was checking for priv->AssociationRequestRetryCnt instead.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/net/wireless/atmel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index b827d51..9c35479 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -3212,7 +3212,7 @@ static void associate(struct atmel_private *priv, u16 frame_len, u16 subtype)
 	if (subtype == IEEE80211_STYPE_REASSOC_RESP &&
 	    status != WLAN_STATUS_ASSOC_DENIED_RATES &&
 	    status != WLAN_STATUS_CAPS_UNSUPPORTED &&
-	    priv->AssociationRequestRetryCnt < MAX_ASSOCIATION_RETRIES) {
+	    priv->ReAssociationRequestRetryCnt < MAX_ASSOCIATION_RETRIES) {
 		mod_timer(&priv->management_timer, jiffies + MGMT_JIFFIES);
 		priv->ReAssociationRequestRetryCnt++;
 		send_association_request(priv, 1);
--
1.7.10.4

