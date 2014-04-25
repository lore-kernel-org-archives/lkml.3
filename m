Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaDYJmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:42:22 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46551 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaDYJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:42:12 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 1/3] Staging: lustre: Avoid using 0 instead of NULL
Date: Fri, 25 Apr 2014 11:41:41 +0200
Message-Id: <1398418903-13315-2-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398418903-13315-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398418903-13315-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following sparse complaints:

drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:755:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:757:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:758:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:759:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:760:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:762:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:764:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:765:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:766:9:
	warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:768:9:
	warning: Using plain integer as NULL pointer

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 6758646..5fa9ef4 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -718,7 +718,7 @@ LPROC_SEQ_FOPS_RO(lprocfs_grant_speed);
 		snprintf(var_name, MAX_STRING_SIZE, #name);	\
 		pool_vars[0].data = var;			\
 		pool_vars[0].fops = ops;			\
-		lprocfs_add_vars(pl->pl_proc_dir, pool_vars, 0);\
+		lprocfs_add_vars(pl->pl_proc_dir, pool_vars, NULL);\
 	} while (0)
 
 static int ldlm_pool_proc_init(struct ldlm_pool *pl)
-- 
1.9.1

