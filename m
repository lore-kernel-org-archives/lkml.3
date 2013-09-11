Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3IKE3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3IKE3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:01 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=tYj5_5k0sd4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ej21fbKeCjYA:10 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=wALiR6nJgdXM2Eb63C8A:9 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042855.610309685@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [021/251] ath9k: Do not assign noise for NULL caldata
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0021-ath9k-Do-not-assign-noise-for-NULL-caldata.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

[ Upstream commit d3bcb7b24bbf09fde8405770e676fe0c11c79662 ]

ah->noise is maintained globally and not per-channel. This
is updated in the reset() routine after the NF history has been
filled for the *current channel*, just before switching to
the new channel. There is no need to do it inside getnf(), since
ah->noise must contain a value for the new channel.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/calib.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index e5cceb0..00960b7 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -388,7 +388,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	if (!caldata) {
 		chan->noisefloor = nf;
-		ah->noise = ath9k_hw_getchan_noise(ah, chan);
 		return false;
 	}
 
-- 
1.7.10.4


