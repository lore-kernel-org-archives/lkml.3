Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbaGEBcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 21:32:08 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:46475 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaGEBcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 21:32:06 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] [media] davinci-vpfe: Fix retcode check
Date: Sat,  5 Jul 2014 04:31:49 +0300
Message-Id: <1404523909-2058-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See https://bugzilla.kernel.org/show_bug.cgi?id=69071
---8<---
Use signed type to check correctly for negative error code

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index b2daf5e..e326032 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -254,7 +254,7 @@ int config_ipipe_hw(struct vpfe_ipipe_device *ipipe)
 	void __iomem *ipipe_base = ipipe->base_addr;
 	struct v4l2_mbus_framefmt *outformat;
 	u32 color_pat;
-	u32 ipipe_mode;
+	int ipipe_mode;
 	u32 data_path;
 
 	/* enable clock to IPIPE */
-- 
1.8.3.2

