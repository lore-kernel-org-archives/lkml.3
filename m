Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbaIOWST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:18:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51096 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbaIOWSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 028/187] sparc64: Add membar to Niagara2 memcpy code.
Date: Mon, 15 Sep 2014 15:07:18 -0700
Message-Id: <1410818997-9432-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 5aa4ecfd0ddb1e6dcd1c886e6c49677550f581aa ]

This is the prevent previous stores from overlapping the block stores
done by the memcpy loop.

Based upon a glibc patch by Jose E. Marchesi

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/lib/NG2memcpy.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/lib/NG2memcpy.S b/arch/sparc/lib/NG2memcpy.S
index 2c20ad6..30eee6e 100644
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

