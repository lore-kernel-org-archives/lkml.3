Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428AbaAFWmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbaAFWm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 22/43] tg3: Expand 4g_overflow_test workaround to skb fragments of any size.
Date: Mon,  6 Jan 2014 14:39:39 -0800
Message-Id: <20140106223942.884336164@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 375679104ab3ccfd18dcbd7ba503734fb9a2c63a upstream.

The current driver assumes that an skb fragment can only be upto jumbo
size. Presumably this was a fast-path optimization. This assumption is
no longer true as fragments can be upto 32k.

v2: Remove unnecessary parantheses per Eric Dumazet.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6619,7 +6619,7 @@ static inline int tg3_4g_overflow_test(d
 {
 	u32 base = (u32) mapping & 0xffffffff;
 
-	return (base > 0xffffdcc0) && (base + len + 8 < base);
+	return base + len + 8 < base;
 }
 
 /* Test for DMA addresses > 40-bit */


