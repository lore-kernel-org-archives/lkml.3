Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaEHT5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:57:47 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63120 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaEHT5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:57:44 -0400
X-Google-Original-From: dirk.j.brandewie@intel.com
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, dirk.brandewie@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 3/5] intel_pstate: Fix fixed point rounding macro
Date: Thu,  8 May 2014 12:57:25 -0700
Message-Id: <1399579047-5792-4-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Change the FP_ROUNDUP macro to add 0.5 in fixed point representation
instead of 1.0

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index eab8ccf..bb20881 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -43,7 +43,7 @@
 #define FRAC_BITS 6
 #define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
 #define fp_toint(X) ((X) >> FRAC_BITS)
-#define FP_ROUNDUP(X) ((X) += 1 << FRAC_BITS)
+#define FP_ROUNDUP(X) ((X) += 1 << (FRAC_BITS-1))
 
 static inline int32_t mul_fp(int32_t x, int32_t y)
 {
-- 
1.9.0

