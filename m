Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3IUW26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:28:58 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54432 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3IUW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:28:34 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: roland@kernel.org
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com, bgottumukkala@emulex.com,
        tj@kernel.org, peter.senna@gmail.com, dan.carpenter@oracle.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 03/19] infiniband: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:35 +0200
Message-Id: <1379802471-30252-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables found and is_uctx_pd are only assigned the values true
and false. Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 56e0049..e30e342 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -120,7 +120,7 @@ static bool ocrdma_add_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
 static bool ocrdma_del_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
 			    bool is_vlan, u16 vlan_id)
 {
-	int found = false;
+	bool found = false;
 	int i;
 	union ib_gid sgid;
 	unsigned long flags;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 6e982bb..843d18b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -537,7 +537,7 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 	struct ocrdma_pd *pd;
 	struct ocrdma_ucontext *uctx = NULL;
 	int status;
-	u8 is_uctx_pd = false;
+	bool is_uctx_pd = false;
 
 	if (udata && context) {
 		uctx = get_ocrdma_ucontext(context);
-- 
1.8.3.1

