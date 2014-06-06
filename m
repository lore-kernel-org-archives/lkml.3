Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaFFRfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:35:09 -0400
Received: from mout.web.de ([212.227.17.11]:60962 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaFFRfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:35:04 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH 13/13] staging: tidspbridge: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:32 +0200
Message-Id: <1402076072-4044-13-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:gyJtakCteit3/UqF2spW1ZtowhcT+Z/idUXaSoyH9pHMc7wBK0s
 xqT0G5JA9oCpbnAHtXJ5vWhgBrSMYuiXgB0B2OmVorA/h/vEsmXtgR4ZmuxpUGtg/9evW4D
 RE7mvZXXOb/rsYBIO08Yc2E1f+sKBwFeAmpiTarrP15mffO+LWCJN28vZjhtLzfY7CuTxsO
 SWx5u6y5TZhvQkidspwKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/tidspbridge/rmgr/rmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/rmgr/rmm.c b/drivers/staging/tidspbridge/rmgr/rmm.c
index 52187bd..7e1ba84 100644
--- a/drivers/staging/tidspbridge/rmgr/rmm.c
+++ b/drivers/staging/tidspbridge/rmgr/rmm.c
@@ -139,7 +139,7 @@ int rmm_alloc(struct rmm_target_obj *target, u32 segid, u32 size,
 						&target->ovly_list);
 			else
 				/* Put new section just before sect */
-				list_add_tail(&new_sect->list_elem,
+				list_add_before(&new_sect->list_elem,
 						&sect->list_elem);
 		}
 	}
-- 
2.0.0

