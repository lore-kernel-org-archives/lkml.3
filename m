Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaFPE3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:29:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41093 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaFPE3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:29:15 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v3 3/7] staging: lustre: lclient: lcommon_misc.c fixing coding style issues
Date: Mon, 16 Jun 2014 14:28:32 +1000
Message-Id: <1402892916-5298-3-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402892916-5298-1-git-send-email-askb23@gmail.com>
References: <1402892916-5298-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed warning:
* WARNING: min() should probably be min_t(__u32, desc.ld_tgt_count,
LOV_MAX_STRIPE_COUNT)

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
index e04c2d3..01ce5c1 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
@@ -63,7 +63,7 @@ int cl_init_ea_size(struct obd_export *md_exp, struct obd_export *dt_exp)
 	if (rc)
 		return rc;
 
-	stripes = min(desc.ld_tgt_count, (__u32)LOV_MAX_STRIPE_COUNT);
+	stripes = min_t(__u32, desc.ld_tgt_count, (__u32)LOV_MAX_STRIPE_COUNT);
 	lsm.lsm_stripe_count = stripes;
 	easize = obd_size_diskmd(dt_exp, &lsm);
 
-- 
1.9.0

