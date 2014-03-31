Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaCaNZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:25:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaCaNYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 63/71] p54: clamp properly instead of just truncating
Date: Mon, 31 Mar 2014 14:23:09 +0100
Message-Id: <1396272197-13394-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 608cfbe4abaf76e9d732efd7ed1cfa3998163d91 upstream.

The call to clamp_t() first truncates the variable signed 8 bit and as a
result, the actual clamp is a no-op.

Fixes: 0d78156eef1d ('p54: improve site survey')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/p54/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 82a1cac..5de755b 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -583,7 +583,7 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	chan = priv->curchan;
 	if (chan) {
 		struct survey_info *survey = &priv->survey[chan->hw_value];
-		survey->noise = clamp_t(s8, priv->noise, -128, 127);
+		survey->noise = clamp(priv->noise, -128, 127);
 		survey->channel_time = priv->survey_raw.active;
 		survey->channel_time_tx = priv->survey_raw.tx;
 		survey->channel_time_busy = priv->survey_raw.tx +
-- 
1.9.1

