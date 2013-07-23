Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810Ab3GWWme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:42:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934690Ab3GWW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 059/103] ath9k: Do not assign noise for NULL caldata
Date: Tue, 23 Jul 2013 15:26:10 -0700
Message-Id: <20130723220425.173924460@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit d3bcb7b24bbf09fde8405770e676fe0c11c79662 upstream.

ah->noise is maintained globally and not per-channel. This
is updated in the reset() routine after the NF history has been
filled for the *current channel*, just before switching to
the new channel. There is no need to do it inside getnf(), since
ah->noise must contain a value for the new channel.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/calib.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -387,7 +387,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, s
 
 	if (!caldata) {
 		chan->noisefloor = nf;
-		ah->noise = ath9k_hw_getchan_noise(ah, chan);
 		return false;
 	}
 


