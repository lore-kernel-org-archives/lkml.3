Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaLOO1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38146 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLOO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 003/168] inetdevice: fixed signed integer overflow
Date: Mon, 15 Dec 2014 14:24:17 +0000
Message-Id: <1418653622-21105-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>

commit 84bc88688e3f6ef843aa8803dbcd90168bb89faf upstream.

There could be a signed overflow in the following code.

The expression, (32-logmask) is comprised between 0 and 31 included.
It may be equal to 31.
In such a case the left shift will produce a signed integer overflow.
According to the C99 Standard, this is an undefined behavior.
A simple fix is to replace the signed int 1 with the unsigned int 1U.

Signed-off-by: Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/inetdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 0068708161ff..0a21fbefdfbe 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -242,7 +242,7 @@ static inline void in_dev_put(struct in_device *idev)
 static __inline__ __be32 inet_make_mask(int logmask)
 {
 	if (logmask)
-		return htonl(~((1<<(32-logmask))-1));
+		return htonl(~((1U<<(32-logmask))-1));
 	return 0;
 }
 
-- 
2.1.3

