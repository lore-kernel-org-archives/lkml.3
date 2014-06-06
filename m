Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaFFRhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:37:46 -0400
Received: from mout.web.de ([212.227.15.3]:52030 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaFFRew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:52 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-pci@vger.kernel.org
Subject: [PATCH 07/13] PCI: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:26 +0200
Message-Id: <1402076072-4044-7-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:hal59sGSD54Df3XocGNShxGvcBE190+xX7j/yx6OIuwH0KUwyB/
 7nCQV2BDJkDu5XS4R0ESAT8a1ZN1e1Ds6Pjx8X9lhO+8G69tiKA9eQkw313pYo9pPvBOV/S
 BVp/U8EuXW+khLnjgM0EdL84WXNSEXz/Tqvy+2LjSj7c2/x7Vc6qn3+KOCun8VZf9Yuy71j
 ZR3PcgBx0s7yWCJCDf2gA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/setup-bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index fd9b545..77ceaab 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -167,7 +167,7 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 			}
 		}
 		/* Insert it just before n*/
-		list_add_tail(&tmp->list, n);
+		list_add_before(&tmp->list, n);
 	}
 }
 
-- 
2.0.0

