Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaIAUY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:24:56 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51896
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbaIAUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:24:54 -0400
X-IronPort-AV: E=Sophos;i="5.04,444,1406584800"; 
   d="scan'208";a="77358104"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 2/2] staging: lustre: ldlm: simplify rc initialization
Date: Mon,  1 Sep 2014 22:21:10 +0200
Message-Id: <1409602870-4642-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Simplify initialization of rc to take advantage of the fact that it is done
at statement level.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 655a1c7..9ce437b 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -569,7 +569,8 @@ int ldlm_cli_enqueue_fini(struct obd_export *exp, struct ptlrpc_request *req,
 		if (lvb_len != 0)
 			rc = ldlm_fill_lvb(lock, &req->rq_pill, RCL_SERVER,
 					   lvb, size);
-		rc = (rc != 0 ? rc : ELDLM_LOCK_ABORTED);
+		if (rc == 0)
+			rc = ELDLM_LOCK_ABORTED;
 		goto cleanup;
 	}
 

