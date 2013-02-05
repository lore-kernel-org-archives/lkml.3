Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab3BEWZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:25:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3BEWJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 33/93] ath9k_htc: Fix memory leak
Date: Tue,  5 Feb 2013 20:06:22 -0200
Message-Id: <1360102042-10732-34-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
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
 
-- 
1.7.9.5

