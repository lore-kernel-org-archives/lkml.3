Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaLCLbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:31:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaLCL1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:46 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/101] inetdevice: fixed signed integer overflow
Date: Wed,  3 Dec 2014 12:26:52 +0100
Message-Id: <77256f4afd82ebda1bd5564709809bae22b58f41.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 84bc88688e3f6ef843aa8803dbcd90168bb89faf ]

There could be a signed overflow in the following code.

The expression, (32-logmask) is comprised between 0 and 31 included.
It may be equal to 31.
In such a case the left shift will produce a signed integer overflow.
According to the C99 Standard, this is an undefined behavior.
A simple fix is to replace the signed int 1 with the unsigned int 1U.

Signed-off-by: Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/inetdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 79640e015a86..f738f922542d 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -234,7 +234,7 @@ static inline void in_dev_put(struct in_device *idev)
 static __inline__ __be32 inet_make_mask(int logmask)
 {
 	if (logmask)
-		return htonl(~((1<<(32-logmask))-1));
+		return htonl(~((1U<<(32-logmask))-1));
 	return 0;
 }
 
-- 
2.1.3

