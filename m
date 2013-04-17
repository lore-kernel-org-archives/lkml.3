Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712Ab3DQRPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:15:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58003 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965286Ab3DQRPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:15:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/30] thermal: cpu_cooling: add documentation for get_property
Date: Wed, 17 Apr 2013 13:12:01 -0400
Message-ID: <1366218743-20841-9-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this is one of the central functions of this file,
it deserves a proper documentation. This patch improves
the existing comment to format it as a kernel-doc style.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index bc1ec19..0fa14b7 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -124,8 +124,14 @@ enum cpufreq_cooling_property {
 	GET_MAXL,
 };
 
-/*
- * this is the common function to
+/**
+ * get_property - fetch a property of interest for a give cpu.
+ * @cpu: cpu for which the property is required
+ * @input: query parameter
+ * @output: query return
+ * @property: type of query (frequency, level, max level)
+ *
+ * This is the common function to
  * 1. get maximum cpu cooling states
  * 2. translate frequency to cooling state
  * 3. translate cooling state to frequency
@@ -134,7 +140,9 @@ enum cpufreq_cooling_property {
  * a) reduce duplicate code as most of the code can be shared.
  * b) make sure the logic is consistent when translating between
  *    cooling states and frequencies.
-*/
+ *
+ * Return: 0 on success, -EINVAL when invalid parameters are passed.
+ */
 static int get_property(unsigned int cpu, unsigned long input,
 	unsigned int* output, enum cpufreq_cooling_property property)
 {
-- 
1.8.2.1.342.gfa7285d

