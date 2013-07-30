Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3G3Ss3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:48:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab3G3SsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:48:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 55/75] net: Swap ver and type in pppoe_hdr
Date: Tue, 30 Jul 2013 11:44:59 -0700
Message-Id: <1375209919-1768-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit b1a5a34bd0b8767ea689e68f8ea513e9710b671e ]

Ver and type in pppoe_hdr should be swapped as defined by RFC2516
section-4.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/linux/if_pppox.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_pppox.h b/include/uapi/linux/if_pppox.h
index 0b46fd5..e36a4ae 100644
--- a/include/uapi/linux/if_pppox.h
+++ b/include/uapi/linux/if_pppox.h
@@ -135,11 +135,11 @@ struct pppoe_tag {
 
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
1.8.1.2

