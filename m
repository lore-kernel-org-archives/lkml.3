Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaK0Is0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:42066 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbaK0IsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:22 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 48/91] iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure
Date: Thu, 27 Nov 2014 16:42:31 +0800
Message-Id: <1417077794-9299-48-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joern Engel <joern@logfs.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 8ae757d09c45102b347a1bc2867f54ffc1ab8fda upstream.

In iscsi_copy_param_list() a failed iscsi_param_list memory allocation
currently invokes iscsi_release_param_list() to cleanup, and will promptly
trigger a NULL pointer dereference.

Instead, go ahead and return for the first iscsi_copy_param_list()
failure case.

Found by coverity.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 8a8ff23..ed4abad 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -552,7 +552,7 @@ int iscsi_copy_param_list(
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!param_list) {
 		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
-		goto err_out;
+		return -1;
 	}
 	INIT_LIST_HEAD(&param_list->param_list);
 	INIT_LIST_HEAD(&param_list->extra_response_list);
-- 
1.9.1

