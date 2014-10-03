Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbaJCV54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:57:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaJCVzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:55:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Stezenbach <js@sig21.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.16 283/357] ath9k_htc: fix random decryption failure
Date: Fri,  3 Oct 2014 14:31:09 -0700
Message-Id: <20141003212941.990350809@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Stezenbach <js@sig21.net>

commit d21ccfd0a60ea3dece3e1d142f52694abf87a0b1 upstream.

In v3.15 the driver stopped to accept network packets after successful
authentification, which could be worked around by passing the
nohwcrypt=1 module parameter.  This was not reproducible by
everyone, and showed random behaviour in some tests.
It was caused by an uninitialized variable introduced
in 4ed1a8d4a257 ("ath9k_htc: use ath9k_cmn_rx_accept") and
used in 341b29b9cd2f ("ath9k_htc: use ath9k_cmn_rx_skb_postprocess").

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=78581
Fixes: 341b29b9cd2f ("ath9k_htc: use ath9k_cmn_rx_skb_postprocess")
Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -978,7 +978,7 @@ static bool ath9k_rx_prepare(struct ath9
 	struct ath_hw *ah = common->ah;
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
-	bool decrypt_error;
+	bool decrypt_error = false;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
 		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",


