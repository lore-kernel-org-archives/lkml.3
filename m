Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3CNOzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:55:50 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54536 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CNOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:55:49 -0400
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 22:55:47 +0800
Message-ID: <CAPgLHd_gP4uiNYgHp7tT9t9_gZh0OKGZiVJGfJj8tAKNynT-JA@mail.gmail.com>
Subject: [PATCH -next] Staging: netlogic: remove unused variable in xlr_net_start_xmit()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, ganesanr@broadcom.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable 'qmap' is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/netlogic/xlr_net.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index efc6172..dd98cb1 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -293,10 +293,8 @@ static netdev_tx_t xlr_net_start_xmit(struct sk_buff *skb,
 	struct nlm_fmn_msg msg;
 	struct xlr_net_priv *priv = netdev_priv(ndev);
 	int ret;
-	u16 qmap;
 	u32 flags;
 
-	qmap = skb->queue_mapping;
 	xlr_make_tx_desc(&msg, virt_to_phys(skb->data), skb);
 	flags = nlm_cop2_enable();
 	ret = nlm_fmn_send(2, 0, priv->nd->tx_stnid, &msg);


