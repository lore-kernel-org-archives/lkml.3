Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab3GVQMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:12:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab3GVQL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:58 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Keith Mannthey <keith.mannthey@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 26/48] staging/lustre/osc: Check return code for lu_kmem_init
Date: Tue, 23 Jul 2013 00:06:47 +0800
Message-Id: <1374509230-3324-27-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Mannthey <keith.mannthey@intel.com>

lu_kmem_init can fail and returns has a return code.
Check for this return code in lu_kmem_init.

This issue was found during 2gb VM Racer testing

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3063
Lustre-change: http://review.whamcloud.com/6514
Signed-off-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_request.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index 0c0e07b..fea04ca 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -3681,6 +3681,8 @@ int __init osc_init(void)
 	CDEBUG(D_INFO, "Lustre OSC module (%p).\n", &osc_caches);
 
 	rc = lu_kmem_init(osc_caches);
+	if (rc)
+		RETURN(rc);
 
 	lprocfs_osc_init_vars(&lvars);
 
-- 
1.7.9.5

