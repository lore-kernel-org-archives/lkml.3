Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaHTL7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:59:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58955 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 052/104] sparc64: Add membar to Niagara2 memcpy code.
Date: Wed, 20 Aug 2014 13:43:15 +0200
Message-Id: <0d543dade2be5f0ddb268c6d6ea0e86938e3bf42.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5aa4ecfd0ddb1e6dcd1c886e6c49677550f581aa ]

This is the prevent previous stores from overlapping the block stores
done by the memcpy loop.

Based upon a glibc patch by Jose E. Marchesi

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/lib/NG2memcpy.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/lib/NG2memcpy.S b/arch/sparc/lib/NG2memcpy.S
index 2c20ad63ddbf..30eee6e8a81b 100644
--- a/arch/sparc/lib/NG2memcpy.S
+++ b/arch/sparc/lib/NG2memcpy.S
@@ -236,6 +236,7 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len */
 	 */
 	VISEntryHalf
 
+	membar		#Sync
 	alignaddr	%o1, %g0, %g0
 
 	add		%o1, (64 - 1), %o4
-- 
2.0.4

