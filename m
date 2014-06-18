Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbaFRIYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:24:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55741 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFRIYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:24:42 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v7 3/8] staging: lustre: lclient: lcommon_misc.c fixing coding style issues
Date: Wed, 18 Jun 2014 18:23:51 +1000
Message-Id: <1403079836-9304-4-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403079836-9304-1-git-send-email-askb23@gmail.com>
References: <1403079836-9304-1-git-send-email-askb23@gmail.com>
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
index 21de1cd..367bdad 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
@@ -63,7 +63,7 @@ int cl_init_ea_size(struct obd_export *md_exp, struct obd_export *dt_exp)
 	if (rc)
 		return rc;
 
-	stripes = min(desc.ld_tgt_count, (__u32)LOV_MAX_STRIPE_COUNT);
+	stripes = min_t(__u32, desc.ld_tgt_count, LOV_MAX_STRIPE_COUNT);
 	lsm.lsm_stripe_count = stripes;
 	easize = obd_size_diskmd(dt_exp, &lsm);
 
-- 
1.9.0

