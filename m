Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3BCO5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34439 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab3BCO5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:11 -0500
Message-Id: <20130203144651.167294006@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 080/128] ath9k_htc: Fix memory leak
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 0981c3b24ef664f5611008a6e6d0622fac6d892b upstream.

SKBs that are allocated in the HTC layer do not have callbacks
registered and hence ended up not being freed, Fix this by freeing
them properly in the TX completion routine.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 4a9570d..aac4a40 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -344,6 +344,8 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 			endpoint->ep_callbacks.tx(endpoint->ep_callbacks.priv,
 						  skb, htc_hdr->endpoint_id,
 						  txok);
+		} else {
+			kfree_skb(skb);
 		}
 	}
 


