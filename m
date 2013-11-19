Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3KSM7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 07:59:04 -0500
Received: from multi.imgtec.com ([194.200.65.239]:47461 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3KSM7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 07:59:01 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] of: unflatten_and_copy: handle NULL initial_boot_params
Date: Tue, 19 Nov 2013 12:58:12 +0000
Message-ID: <1384865892-28659-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_19_12_58_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether initial_boot_params is NULL before dereferencing it in
unflatten_and_copy_device_tree() for the case where no device tree is
available but the arch can still boot to a minimal usable system without
it.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arch@vger.kernel.org
---
 drivers/of/fdt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 2fa024b97c43..ac4983955e6d 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -922,8 +922,14 @@ void __init unflatten_device_tree(void)
  */
 void __init unflatten_and_copy_device_tree(void)
 {
-	int size = __be32_to_cpu(initial_boot_params->totalsize);
-	void *dt = early_init_dt_alloc_memory_arch(size,
+	int size;
+	void *dt;
+
+	if (!initial_boot_params)
+		return;
+
+	size = __be32_to_cpu(initial_boot_params->totalsize);
+	dt = early_init_dt_alloc_memory_arch(size,
 		__alignof__(struct boot_param_header));
 
 	if (dt) {
-- 
1.8.1.2


