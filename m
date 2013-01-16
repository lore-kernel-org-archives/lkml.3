Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3APVah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:30:37 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34107 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab3APVag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:30:36 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH net-next] ipv6: fix ipv6_prefix_equal64_half mask conversion
Date: Wed, 16 Jan 2013 22:30:17 +0100
Message-Id: <1358371817-15378-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the 64bit optimized version of ipv6_prefix_equal to convert the
bitmask to network byte order only after the bit-shift.

The bug was introduced in:

3867517 ipv6: 64bit version of ipv6_prefix_equal().

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 include/net/ipv6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index dfc1363..459a5a4 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -404,7 +404,7 @@ static inline bool __ipv6_prefix_equal64_half(const __be64 *a1,
 					      const __be64 *a2,
 					      unsigned int len)
 {
-	if (len && ((*a1 ^ *a2) & cpu_to_be64(~0UL) << (64 - len)))
+	if (len && ((*a1 ^ *a2) & cpu_to_be64((~0UL) << (64 - len))))
 		return false;
 	return true;
 }
-- 
1.7.12.1

