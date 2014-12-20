Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaLTQK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:10:59 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:32863 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaLTQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:10:58 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Munsie <imunsie@au1.ibm.com>, Michael Neuling <mikey@neuling.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: cxl: sysfs.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:13:44 +0100
Message-Id: <1419092024-6701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function mmio_size_show() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/misc/cxl/sysfs.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/misc/cxl/sysfs.c b/drivers/misc/cxl/sysfs.c
index ce7ec06..0431ec3 100644
--- a/drivers/misc/cxl/sysfs.c
+++ b/drivers/misc/cxl/sysfs.c
@@ -102,17 +102,6 @@ static struct device_attribute afu_master_attrs[] = {
 
 /*********  AFU attributes  **************************************************/
 
-static ssize_t mmio_size_show(struct device *device,
-			      struct device_attribute *attr,
-			      char *buf)
-{
-	struct cxl_afu *afu = to_cxl_afu(device);
-
-	if (afu->pp_size)
-		return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->pp_size);
-	return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->adapter->ps_size);
-}
-
 static ssize_t reset_store_afu(struct device *device,
 			       struct device_attribute *attr,
 			       const char *buf, size_t count)
-- 
1.7.10.4

