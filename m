Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaELBpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:45:09 -0400
Received: from 1wt.eu ([62.212.114.60]:34822 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306AbaELBpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:45:04 -0400
Message-Id: <20140512003202.795265260@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 052/143] net: Swap ver and type in pppoe_hdr
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit b1a5a34bd0b8767ea689e68f8ea513e9710b671e ]

Ver and type in pppoe_hdr should be swapped as defined by RFC2516
section-4.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/if_pppox.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_pppox.h b/include/linux/if_pppox.h
index 90b5fae..1750054 100644
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -108,11 +108,11 @@ struct pppoe_tag {
 
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
1.7.12.2.21.g234cd45.dirty



