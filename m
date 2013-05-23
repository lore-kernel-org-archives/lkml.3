Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3EWRfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:35:41 -0400
Received: from mta114.f1.k8.com.br ([187.73.32.186]:41635 "EHLO
	mta114.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab3EWRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:35:40 -0400
X-DKIM: OpenDKIM Filter v2.6.8 smtpz.f1.k8.com.br 4BA9A20101
Message-ID: <1369328974.3123.77.camel@Thor>
Subject: [PATCH 1/1] net-next: export skb_splice_bits()
From: Michel Machado <michel@digirati.com.br>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pravin B Shelar <pshelar@nicira.com>, linux-kernel@vger.kernel.org
Date: Thu, 23 May 2013 13:09:34 -0400
Organization: Digirati Internet
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

skb_splice_bits() is already available in include/linux/skbuff.h, but
without EXPORT_SYMBOL it can't be used by kernel modules.

Signed-off-by: Michel Machado <michel@digirati.com.br>
CC: "David S. Miller" <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Pravin B Shelar <pshelar@nicira.com>
---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index af9185d..0976908 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1854,6 +1854,7 @@ done:
 
 	return ret;
 }
+EXPORT_SYMBOL(skb_splice_bits);
 
 /**
  *	skb_store_bits - store bits from kernel buffer to skb

