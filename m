Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3FPEq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:46:59 -0400
Received: from ozlabs.org ([203.10.76.45]:35933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab3FPEqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:46:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH 7/9] staging/zcache: don't use PTR_RET().
Date: Sun, 16 Jun 2013 14:12:46 +0930
Message-Id: <1371357768-4968-7-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
 <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've already tested that it's an error.

Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/staging/zcache/zcache-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index dcceed2..88e7fe7 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1908,7 +1908,7 @@ static int zcache_init(void)
 #endif
 		if (IS_ERR(old_ops) || old_ops) {
 			if (IS_ERR(old_ops))
-				return PTR_RET(old_ops);
+				return PTR_ERR(old_ops);
 			pr_warn("%s: frontswap_ops overridden\n", namestr);
 		}
 	}
-- 
1.8.1.2

