Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaHMJSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:18:13 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60111 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaHMJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:18:10 -0400
Date: Wed, 13 Aug 2014 14:48:04 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] ARM: integrator: Drop unnecessary continue
Message-ID: <20140813091804.GA3043@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continue is not needed at the bottom of a loop.

The Coccinelle semantic patch implementing this change is:

@@
@@

for (...;...;...) {
  ...
  if (...) {
    ...
-   continue;
  }
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 arch/arm/mach-integrator/impd1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-integrator/impd1.c b/arch/arm/mach-integrator/impd1.c
index 3ce8807..c4eb8c9 100644
--- a/arch/arm/mach-integrator/impd1.c
+++ b/arch/arm/mach-integrator/impd1.c
@@ -376,10 +376,8 @@ static int __init_refok impd1_probe(struct lm_device *dev)
 					    irq1, irq2,
 					    idev->platform_data, idev->id,
 					    &dev->resource);
-		if (IS_ERR(d)) {
+		if (IS_ERR(d))
 			dev_err(&dev->dev, "unable to register device: %ld\n", PTR_ERR(d));
-			continue;
-		}
 	}
 
 	return 0;
-- 
1.9.1

