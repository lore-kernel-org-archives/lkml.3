Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaHRJlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:41:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaHRJgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 122/137] sparc64: Add membar to Niagara2 memcpy code.
Date: Mon, 18 Aug 2014 10:33:03 +0100
Message-Id: <1408354398-10226-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 5aa4ecfd0ddb1e6dcd1c886e6c49677550f581aa upstream.

This is the prevent previous stores from overlapping the block stores
done by the memcpy loop.

Based upon a glibc patch by Jose E. Marchesi

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

