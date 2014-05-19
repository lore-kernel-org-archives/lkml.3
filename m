Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaESEd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:33:29 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14038 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbaESEcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:55 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474225"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Robert Richter <rric@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        oprofile-list@lists.sf.net, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] s390/irq: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:15 +0200
Message-Id: <1400473875-22228-14-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/s390/oprofile/hwsampler.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index 276f2e2..28b2760 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -212,10 +212,8 @@ static void init_all_cpu_buffers(void)
 static int prepare_cpu_buffers(void)
 {
 	int cpu;
-	int rc;
 	struct hws_cpu_buffer *cb;
 
-	rc = 0;
 	for_each_online_cpu(cpu) {
 		cb = &per_cpu(sampler_cpu_buffer, cpu);
 		atomic_set(&cb->ext_params, 0);
@@ -231,7 +229,7 @@ static int prepare_cpu_buffers(void)
 		cb->stop_mode = 0;
 	}
 
-	return rc;
+	return 0;
 }
 
 /*
@@ -1156,7 +1154,7 @@ int hwsampler_stop_all(void)
 	rc = 0;
 	if (hws_state == HWS_INIT) {
 		mutex_unlock(&hws_sem);
-		return rc;
+		return 0;
 	}
 	hws_state = HWS_STOPPING;
 	mutex_unlock(&hws_sem);

