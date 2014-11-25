Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaKYKpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:45:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59273 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaKYKnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Devesh Sharma <devesh.sharma@emulex.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 248/254] IB/core: Clear AH attr variable to prevent garbage data
Date: Tue, 25 Nov 2014 10:39:58 +0000
Message-Id: <1416912004-5928-249-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devesh Sharma <devesh.sharma@emulex.com>

commit 8b0f93d9490653a7b9fc91f3570089132faed1c0 upstream.

During create-ah from userspace, uverbs is sending garbage data in
attr.dmac and attr.vlan_id.  This patch sets attr.dmac and
attr.vlan_id to zero.

Fixes: dd5f03beb4f7 ("IB/core: Ethernet L2 attributes in verbs/cm structures")
Signed-off-by: Devesh Sharma <devesh.sharma@emulex.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ea6203ee7bcc..23467a2abd62 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2425,6 +2425,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
 	attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
 	attr.grh.traffic_class = cmd.attr.grh.traffic_class;
+	attr.vlan_id           = 0;
+	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
 	ah = ib_create_ah(pd, &attr);
-- 
2.1.0

