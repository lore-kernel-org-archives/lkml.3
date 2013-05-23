Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab3EWRXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:23:46 -0400
Received: from mta112.f1.k8.com.br ([187.73.32.184]:54648 "EHLO
	mta112.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab3EWRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:23:45 -0400
X-Greylist: delayed 841 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 13:23:45 EDT
X-DKIM: OpenDKIM Filter v2.6.8 smtpz.f1.k8.com.br 3ED5980056
Message-ID: <1369329818.3123.83.camel@Thor>
Subject: [PATCH 1/1] net-next: export dma_skb_copy_datagram_iovec()
From: Michel Machado <michel@digirati.com.br>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Thu, 23 May 2013 13:23:38 -0400
Organization: Digirati Internet
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_skb_copy_datagram_iovec() is already available in include/net/netdma.h, but
without EXPORT_SYMBOL it can't be used by kernel modules.

Signed-off-by: Michel Machado <michel@digirati.com.br>
CC: "David S. Miller" <davem@davemloft.net>
---
diff --git a/net/core/user_dma.c b/net/core/user_dma.c
index 1b5fefd..653f516 100644
--- a/net/core/user_dma.c
+++ b/net/core/user_dma.c
@@ -129,3 +129,4 @@ end:
 fault:
 	return -EFAULT;
 }
+EXPORT_SYMBOL(dma_skb_copy_datagram_iovec);

