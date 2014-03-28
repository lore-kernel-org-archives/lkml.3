Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaC1SJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:09:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaC1RaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.4 06/13] p54: clamp properly instead of just truncating
Date: Fri, 28 Mar 2014 10:31:56 -0700
Message-Id: <20140328173053.917264555@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173053.049244535@linuxfoundation.org>
References: <20140328173053.049244535@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 608cfbe4abaf76e9d732efd7ed1cfa3998163d91 upstream.

The call to clamp_t() first truncates the variable signed 8 bit and as a
result, the actual clamp is a no-op.

Fixes: 0d78156eef1d ('p54: improve site survey')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -583,7 +583,7 @@ static void p54_rx_stats(struct p54_comm
 	chan = priv->curchan;
 	if (chan) {
 		struct survey_info *survey = &priv->survey[chan->hw_value];
-		survey->noise = clamp_t(s8, priv->noise, -128, 127);
+		survey->noise = clamp(priv->noise, -128, 127);
 		survey->channel_time = priv->survey_raw.active;
 		survey->channel_time_tx = priv->survey_raw.tx;
 		survey->channel_time_busy = priv->survey_raw.tx +


