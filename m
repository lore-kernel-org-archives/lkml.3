Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3CRTG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:06:29 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48809 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3CRTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:06:26 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, gregkh@linuxfoundation.org, prabhakar.lad@ti.com,
        sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH v2] drivers: staging: davinci_vpfe: use resource_size()
Date: Mon, 18 Mar 2013 21:06:20 +0200
Message-Id: <1363633580-2920-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the resource_size() function instead of explicit computation.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    4 ++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 9285353..05673ed 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1859,5 +1859,5 @@ void vpfe_ipipe_cleanup(struct vpfe_ipipe_device *ipipe,
 	iounmap(ipipe->isp5_base_addr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 4);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 }
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index ebeea72..c4a5660 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1953,7 +1953,7 @@ static void isif_remove(struct vpfe_isif_device *isif,
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (res)
 			release_mem_region(res->start,
-					   res->end - res->start + 1);
+					   resource_size(res));
 		i++;
 	}
 }
@@ -2003,7 +2003,7 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
 			status = -ENOENT;
 			goto fail_nobase_res;
 		}
-		res_len = res->end - res->start + 1;
+		res_len = resource_size(res);
 		res = request_mem_region(res->start, res_len, res->name);
 		if (!res) {
 			status = -EBUSY;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 9cb0262..126f84c 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1995,5 +1995,5 @@ vpfe_resizer_cleanup(struct vpfe_resizer_device *vpfe_rsz,
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 5);
 	if (res)
 		release_mem_region(res->start,
-					res->end - res->start + 1);
+					resource_size(res));
 }
-- 
1.7.9.5

