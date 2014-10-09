Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaJIVJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbaJIVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 101/163] iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure
Date: Thu,  9 Oct 2014 14:02:06 -0700
Message-Id: <1412888588-26755-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Engel <joern@logfs.org>

commit 8ae757d09c45102b347a1bc2867f54ffc1ab8fda upstream.

In iscsi_copy_param_list() a failed iscsi_param_list memory allocation
currently invokes iscsi_release_param_list() to cleanup, and will promptly
trigger a NULL pointer dereference.

Instead, go ahead and return for the first iscsi_copy_param_list()
failure case.

Found by coverity.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 4d2e23f..43b7e6a 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -601,7 +601,7 @@ int iscsi_copy_param_list(
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

