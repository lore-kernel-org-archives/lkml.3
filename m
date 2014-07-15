Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaGOQsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:48:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51276 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaGOQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:48:27 -0400
From: Adithya Krishnamurthy <linux.challenge1@gmail.com>
To: omar.ramirez@copitl.com, gregkh@linuxfoundation.org,
        rashika.kheria@gmail.com, freemangordon@abv.bg,
        dan.carpenter@oracle.com, ody.guru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Adithya Krishnamurthy <linux.challenge1@gmail.com>
Subject: [PATCH] Staging:tidspbridge Fix checkpatch.pl warning char * array declaration might be better as static const
Date: Tue, 15 Jul 2014 22:18:18 +0530
Message-Id: <1405442900-6977-1-git-send-email-linux.challenge1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adithya Krishnamurthy <linux.challenge1@gmail.com>

Fixed checkpatch "WARNING: char * array declaration might be better as static const"

Signed-off-by: Adithya Krishnamurthy <linux.challenge1@gmail.com>
---
 drivers/staging/tidspbridge/core/io_sm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 42f94e1..24bd962 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -1910,10 +1910,11 @@ int dump_dsp_stack(struct bridge_dev_context *bridge_context)
 	u32 offset_output;
 	u32 total_size;
 	u32 poll_cnt;
-	const char *dsp_regs[] = {"EFR", "IERR", "ITSR", "NTSR",
+	static const char * const dsp_regs[] = {"EFR", "IERR", "ITSR", "NTSR",
 				"IRP", "NRP", "AMR", "SSR",
 				"ILC", "RILC", "IER", "CSR"};
-	const char *exec_ctxt[] = {"Task", "SWI", "HWI", "Unknown"};
+	static const char * const exec_ctxt[] = {"Task", "SWI", "HWI",
+						"Unknown"};
 	struct bridge_drv_interface *intf_fxns;
 	struct dev_object *dev_object = bridge_context->dev_obj;
 
-- 
1.7.9.5

