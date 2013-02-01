Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161384Ab3BAKuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:50:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:39165 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161354Ab3BAKuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:50:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 17/33] ath9k_htc: Fix memory leak
Date: Fri,  1 Feb 2013 11:49:22 +0100
Message-Id: <20130201104725.891250071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -342,6 +342,8 @@ void ath9k_htc_txcompletion_cb(struct ht
 			endpoint->ep_callbacks.tx(endpoint->ep_callbacks.priv,
 						  skb, htc_hdr->endpoint_id,
 						  txok);
+		} else {
+			kfree_skb(skb);
 		}
 	}
 


