Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaKAWs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:48:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbaKAWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:30 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Joern Engel" <joern@logfs.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.106217878@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 054/102] iscsi-target: avoid NULL pointer in
 iscsi_copy_param_list failure
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

