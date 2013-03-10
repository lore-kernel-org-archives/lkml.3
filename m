Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab3CJMPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:15:11 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63584 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3CJMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:15:08 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] Drivers: staging: media: davinci_vpfe: Use resource_size function
Date: Sun, 10 Mar 2013 14:14:53 +0200
Message-Id: <1362917693-29589-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size function on resource object instead of explicit
computation.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index c8cae51..b2f4ef8 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -1065,7 +1065,6 @@ vpfe_ipipeif_cleanup(struct vpfe_ipipeif_device *ipipeif,
 	iounmap(ipipeif->ipipeif_base_addr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
 	if (res)
-		release_mem_region(res->start,
-					res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 
 }
-- 
1.7.10.4

