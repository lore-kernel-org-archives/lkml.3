Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbbANIw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:52:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbbANHZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.18 007/150] ath9k_hw: fix hardware queue allocation
Date: Tue, 13 Jan 2015 23:21:18 -0800
Message-Id: <20150114072056.183443206@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit ad8fdccf9c197a89e2d2fa78c453283dcc2c343f upstream.

The driver passes the desired hardware queue index for a WMM data queue
in qinfo->tqi_subtype. This was ignored in ath9k_hw_setuptxqueue, which
instead relied on the order in which the function is called.

Reported-by: Hubert Feurstein <h.feurstein@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/mac.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -311,14 +311,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw
 		q = ATH9K_NUM_TX_QUEUES - 3;
 		break;
 	case ATH9K_TX_QUEUE_DATA:
-		for (q = 0; q < ATH9K_NUM_TX_QUEUES; q++)
-			if (ah->txq[q].tqi_type ==
-			    ATH9K_TX_QUEUE_INACTIVE)
-				break;
-		if (q == ATH9K_NUM_TX_QUEUES) {
-			ath_err(common, "No available TX queue\n");
-			return -1;
-		}
+		q = qinfo->tqi_subtype;
 		break;
 	default:
 		ath_err(common, "Invalid TX queue type: %u\n", type);


