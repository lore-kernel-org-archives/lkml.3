Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaFFRey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:34:54 -0400
Received: from mout.web.de ([212.227.15.3]:60741 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaFFRew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:52 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-edac@vger.kernel.org
Subject: [PATCH 06/13] EDAC: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:25 +0200
Message-Id: <1402076072-4044-6-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:AgLnyVy111AqoyM4eU6SNw8LLAzHEZ9AvJpIs5MCZPH0/wY8S7M
 QGMjx1vh8SLtTsM6q7mA8E7mNCLlNKf7kAT4e5Q8FYEGOO58+ufmrmQ+IRww0CmXc0DB7ER
 1ZsCORKkL3ZTHetIqhn4dHGDebwjV92jDRTLV5QekAlK+uVTZMxV4Qntiu7AAwOqvYRVFCl
 +jWSxqndUhc5Kj6+tAK5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-edac@vger.kernel.org
---
 drivers/edac/edac_device.c | 2 +-
 drivers/edac/edac_mc.c     | 2 +-
 drivers/edac/edac_pci.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 592af5f..b9216b2 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -318,7 +318,7 @@ static int add_edac_dev_to_global_list(struct edac_device_ctl_info *edac_dev)
 		}
 	}
 
-	list_add_tail_rcu(&edac_dev->link, insert_before);
+	list_add_before_rcu(&edac_dev->link, insert_before);
 	return 0;
 
 fail0:
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 2c694b5..ef4d653 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -653,7 +653,7 @@ static int add_mc_to_global_list(struct mem_ctl_info *mci)
 		}
 	}
 
-	list_add_tail_rcu(&mci->link, insert_before);
+	list_add_before_rcu(&mci->link, insert_before);
 	atomic_inc(&edac_handlers);
 	return 0;
 
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 2cf44b4d..df6c69b 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -144,7 +144,7 @@ static int add_edac_pci_to_global_list(struct edac_pci_ctl_info *pci)
 		}
 	}
 
-	list_add_tail_rcu(&pci->link, insert_before);
+	list_add_before_rcu(&pci->link, insert_before);
 	return 0;
 
 fail0:
-- 
2.0.0

