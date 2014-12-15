Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaLOSG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:06:59 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:52034 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLOSGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:06:55 -0500
From: Aleksey Makarov <feumilieu@gmail.com>
X-Google-Original-From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 12/14] MIPS: OCTEON: Update octeon-model.h code for new SoCs.
Date: Mon, 15 Dec 2014 21:03:18 +0300
Message-Id: <1418666603-15159-13-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Add coverage for OCTEON III models.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/include/asm/octeon/octeon-model.h | 65 ++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/octeon/octeon-model.h b/arch/mips/include/asm/octeon/octeon-model.h
index e2c122c..35d7cbd 100644
--- a/arch/mips/include/asm/octeon/octeon-model.h
+++ b/arch/mips/include/asm/octeon/octeon-model.h
@@ -45,6 +45,7 @@
  */
 
 #define OCTEON_FAMILY_MASK	0x00ffff00
+#define OCTEON_PRID_MASK	0x00ffffff
 
 /* Flag bits in top byte */
 /* Ignores revision in model checks */
@@ -63,6 +64,46 @@
 #define OM_MATCH_6XXX_FAMILY_MODELS	0x40000000
 /* Match all cnf7XXX Octeon models. */
 #define OM_MATCH_F7XXX_FAMILY_MODELS	0x80000000
+/* Match all cn7XXX Octeon models. */
+#define OM_MATCH_7XXX_FAMILY_MODELS     0x10000000
+#define OM_MATCH_FAMILY_MODELS		(OM_MATCH_5XXX_FAMILY_MODELS |	\
+					 OM_MATCH_6XXX_FAMILY_MODELS |	\
+					 OM_MATCH_F7XXX_FAMILY_MODELS | \
+					 OM_MATCH_7XXX_FAMILY_MODELS)
+/*
+ * CN7XXX models with new revision encoding
+ */
+
+#define OCTEON_CN73XX_PASS1_0	0x000d9700
+#define OCTEON_CN73XX		(OCTEON_CN73XX_PASS1_0 | OM_IGNORE_REVISION)
+#define OCTEON_CN73XX_PASS1_X	(OCTEON_CN73XX_PASS1_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+
+#define OCTEON_CN70XX_PASS1_0	0x000d9600
+#define OCTEON_CN70XX_PASS1_1	0x000d9601
+#define OCTEON_CN70XX_PASS1_2	0x000d9602
+
+#define OCTEON_CN70XX_PASS2_0	0x000d9608
+
+#define OCTEON_CN70XX		(OCTEON_CN70XX_PASS1_0 | OM_IGNORE_REVISION)
+#define OCTEON_CN70XX_PASS1_X	(OCTEON_CN70XX_PASS1_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+#define OCTEON_CN70XX_PASS2_X	(OCTEON_CN70XX_PASS2_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+
+#define OCTEON_CN71XX		OCTEON_CN70XX
+
+#define OCTEON_CN78XX_PASS1_0	0x000d9500
+#define OCTEON_CN78XX_PASS1_1	0x000d9501
+#define OCTEON_CN78XX_PASS2_0	0x000d9508
+
+#define OCTEON_CN78XX		(OCTEON_CN78XX_PASS1_0 | OM_IGNORE_REVISION)
+#define OCTEON_CN78XX_PASS1_X	(OCTEON_CN78XX_PASS1_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+#define OCTEON_CN78XX_PASS2_X	(OCTEON_CN78XX_PASS2_0 | \
+				 OM_IGNORE_MINOR_REVISION)
+
+#define OCTEON_CN76XX		(0x000d9540 | OM_CHECK_SUBMODEL)
 
 /*
  * CNF7XXX models with new revision encoding
@@ -217,6 +258,10 @@
 #define OCTEON_CN3XXX		(OCTEON_CN58XX_PASS1_0 | OM_MATCH_PREVIOUS_MODELS | OM_IGNORE_REVISION)
 #define OCTEON_CN5XXX		(OCTEON_CN58XX_PASS1_0 | OM_MATCH_5XXX_FAMILY_MODELS)
 #define OCTEON_CN6XXX		(OCTEON_CN63XX_PASS1_0 | OM_MATCH_6XXX_FAMILY_MODELS)
+#define OCTEON_CNF7XXX		(OCTEON_CNF71XX_PASS1_0 | \
+				 OM_MATCH_F7XXX_FAMILY_MODELS)
+#define OCTEON_CN7XXX		(OCTEON_CN78XX_PASS1_0 | \
+				 OM_MATCH_7XXX_FAMILY_MODELS)
 
 /* These are used to cover entire families of OCTEON processors */
 #define OCTEON_FAM_1		(OCTEON_CN3XXX)
@@ -288,9 +333,16 @@ static inline uint64_t cvmx_read_csr(uint64_t csr_addr);
 		((((arg_model) & (OM_FLAG_MASK)) == OM_CHECK_SUBMODEL)	\
 			&& __OCTEON_MATCH_MASK__((chip_model), (arg_model), OCTEON_58XX_MODEL_REV_MASK)) || \
 		((((arg_model) & (OM_MATCH_5XXX_FAMILY_MODELS)) == OM_MATCH_5XXX_FAMILY_MODELS) \
-			&& ((chip_model) >= OCTEON_CN58XX_PASS1_0) && ((chip_model) < OCTEON_CN63XX_PASS1_0)) || \
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CN58XX_PASS1_0) \
+			&& ((chip_model & OCTEON_PRID_MASK) < OCTEON_CN63XX_PASS1_0)) || \
 		((((arg_model) & (OM_MATCH_6XXX_FAMILY_MODELS)) == OM_MATCH_6XXX_FAMILY_MODELS) \
-			&& ((chip_model) >= OCTEON_CN63XX_PASS1_0)) ||	\
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CN63XX_PASS1_0) \
+			&& ((chip_model & OCTEON_PRID_MASK) < OCTEON_CNF71XX_PASS1_0)) || \
+		((((arg_model) & (OM_MATCH_F7XXX_FAMILY_MODELS)) == OM_MATCH_F7XXX_FAMILY_MODELS) \
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CNF71XX_PASS1_0) \
+			&& ((chip_model & OCTEON_PRID_MASK) < OCTEON_CN78XX_PASS1_0)) || \
+		((((arg_model) & (OM_MATCH_7XXX_FAMILY_MODELS)) == OM_MATCH_7XXX_FAMILY_MODELS) \
+			&& ((chip_model & OCTEON_PRID_MASK) >= OCTEON_CN78XX_PASS1_0)) || \
 		((((arg_model) & (OM_MATCH_PREVIOUS_MODELS)) == OM_MATCH_PREVIOUS_MODELS) \
 			&& (((chip_model) & OCTEON_58XX_MODEL_MASK) < ((arg_model) & OCTEON_58XX_MODEL_MASK))) \
 		)))
@@ -326,6 +378,15 @@ static inline int __octeon_is_model_runtime__(uint32_t model)
 #define OCTEON_IS_COMMON_BINARY() 1
 #undef OCTEON_MODEL
 
+#define OCTEON_IS_OCTEON1()	OCTEON_IS_MODEL(OCTEON_CN3XXX)
+#define OCTEON_IS_OCTEONPLUS()	OCTEON_IS_MODEL(OCTEON_CN5XXX)
+#define OCTEON_IS_OCTEON2()						\
+	(OCTEON_IS_MODEL(OCTEON_CN6XXX) || OCTEON_IS_MODEL(OCTEON_CNF71XX))
+
+#define OCTEON_IS_OCTEON3()	OCTEON_IS_MODEL(OCTEON_CN7XXX)
+
+#define OCTEON_IS_OCTEON1PLUS()	(OCTEON_IS_OCTEON1() || OCTEON_IS_OCTEONPLUS())
+
 const char *octeon_model_get_string(uint32_t chip_id);
 const char *octeon_model_get_string_buffer(uint32_t chip_id, char *buffer);
 
-- 
2.1.3

