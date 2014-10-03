Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbaJDAL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:11:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbaJCVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.16 235/357] iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure
Date: Fri,  3 Oct 2014 14:30:21 -0700
Message-Id: <20141003212940.566624518@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


