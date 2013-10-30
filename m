Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3J3Tn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:43:28 -0400
Received: from mout.gmx.net ([212.227.15.19]:53177 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab3J3Tn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:43:26 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2 v2] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
Date: Wed, 30 Oct 2013 20:46:55 +0100
Message-Id: <1383162416-4444-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
References: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:bbOcyHcBtORiSNXYwfLXhZN2Pl5fDMPAzNKuA3SZt0JneWrp4PU
 RTlyWpW+e23mNwKnOzj8RBhdcJtRmJHPMoeg9V7HFHO6vkZL6BWRgXVNgmU6s246a6KFM3m
 RQ4UoyMa8CZCMDtw/Oklsmbp8lKPv1t7kFSS4i+ZHM+u0dZjSBXpyN3Qhyjl0zsbm367Y3u
 +i0uB6qIn9ENOW4Xc6RgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the implementation strcmp might return the difference between
two strings not only -1,0,1 consequently
 if (strcmp (a,b) == -1)
might lead to taking the wrong branch

-> compare with < 0  instead,
which in any case is more canonical.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
sorry for the rubbish first patch, 
should get more sleep, but coding is too much fun;)

 drivers/char/tpm/tpm_ppi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 8e562dc..18c5810 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -169,7 +169,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (strcmp(version, "1.1") == -1)
+	if (strcmp(version, "1.1") < 0)
 		params[2].integer.value = TPM_PPI_FN_SUBREQ;
 	else
 		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
@@ -179,7 +179,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length = sizeof(req);
 		sscanf(buf, "%d", &req);
@@ -245,7 +245,7 @@ static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-	if (strcmp(version, "1.2") == -1) {
+	if (strcmp(version, "1.2") < 0) {
 		params[3].type = ACPI_TYPE_BUFFER;
 		params[3].buffer.length =  0;
 		params[3].buffer.pointer = NULL;
@@ -387,7 +387,7 @@ static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 	kfree(output.pointer);
 	output.length = ACPI_ALLOCATE_BUFFER;
 	output.pointer = NULL;
-	if (strcmp(version, "1.2") == -1)
+	if (strcmp(version, "1.2") < 0)
 		return -EPERM;
 
 	params[2].integer.value = TPM_PPI_FN_GETOPR;
-- 
1.7.8.6

