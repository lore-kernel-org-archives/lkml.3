Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbbAKNGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:06:52 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61579 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbAKNGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:06:48 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Moni Shoua <monis@mellanox.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband: core: cm: Remove unused function
Date: Sun, 11 Jan 2015 14:09:52 +0100
Message-Id: <1420981792-16530-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function cm_is_active_peer() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/infiniband/core/cm.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..106dfee 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1224,14 +1224,6 @@ static int cm_issue_rej(struct cm_port *port,
 	return ret;
 }
 
-static inline int cm_is_active_peer(__be64 local_ca_guid, __be64 remote_ca_guid,
-				    __be32 local_qpn, __be32 remote_qpn)
-{
-	return (be64_to_cpu(local_ca_guid) > be64_to_cpu(remote_ca_guid) ||
-		((local_ca_guid == remote_ca_guid) &&
-		 (be32_to_cpu(local_qpn) > be32_to_cpu(remote_qpn))));
-}
-
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 					    struct ib_sa_path_rec *primary_path,
 					    struct ib_sa_path_rec *alt_path)
-- 
1.7.10.4

