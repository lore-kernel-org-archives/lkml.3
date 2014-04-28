Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaD1C0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:26:37 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51629 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaD1C0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:26:36 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH v3 2/4] staging/lustre/lnet: remove unused variable in lnet_destroy_remote_nets_table
Date: Sun, 27 Apr 2014 22:25:56 -0400
Message-Id: <1398651958-5103-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398651958-5103-1-git-send-email-green@linuxhacker.ru>
References: <1398651958-5103-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Local variable 'hash' is never used
found by Klocwork Insight tool

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9386
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/lnet/api-ni.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index 85b8d81..3f1fdaa 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -127,8 +127,7 @@ lnet_create_remote_nets_table(void)
 static void
 lnet_destroy_remote_nets_table(void)
 {
-	int		i;
-	struct list_head	*hash;
+	int i;
 
 	if (the_lnet.ln_remote_nets_hash == NULL)
 		return;
@@ -137,7 +136,8 @@ lnet_destroy_remote_nets_table(void)
 		LASSERT(list_empty(&the_lnet.ln_remote_nets_hash[i]));
 
 	LIBCFS_FREE(the_lnet.ln_remote_nets_hash,
-		    LNET_REMOTE_NETS_HASH_SIZE * sizeof(*hash));
+		    LNET_REMOTE_NETS_HASH_SIZE *
+		    sizeof(the_lnet.ln_remote_nets_hash[0]));
 	the_lnet.ln_remote_nets_hash = NULL;
 }
 
-- 
1.9.0

