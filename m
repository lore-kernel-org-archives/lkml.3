Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3G3Jtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:49:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3G3JdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 050/106] net: Swap ver and type in pppoe_hdr
Date: Tue, 30 Jul 2013 10:31:09 +0100
Message-Id: <1375176725-5825-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

commit b1a5a34bd0b8767ea689e68f8ea513e9710b671e upstream.

Ver and type in pppoe_hdr should be swapped as defined by RFC2516
section-4.

Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5:
  - include/uapi/linux/if_pppox.h -> include/linux/if_pppox.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/if_pppox.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_pppox.h b/include/linux/if_pppox.h
index 09c474c..b8b7544 100644
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -140,11 +140,11 @@ struct pppoe_tag {
 
 struct pppoe_hdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 ver : 4;
 	__u8 type : 4;
+	__u8 ver : 4;
 #elif defined(__BIG_ENDIAN_BITFIELD)
-	__u8 type : 4;
 	__u8 ver : 4;
+	__u8 type : 4;
 #else
 #error	"Please fix <asm/byteorder.h>"
 #endif
-- 
1.8.3.2

