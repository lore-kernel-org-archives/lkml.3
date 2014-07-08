Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaGHOIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:08:21 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38050 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaGHOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:08:20 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
        prabhakar.csengg@gmail.com, josh@joshtriplett.org, levex@linux.com,
        archanakumari959@gmail.com, lisa@xenapiadmin.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] [media] davinci-vpfe: Fix retcode check
Date: Tue,  8 Jul 2014 17:08:08 +0300
Message-Id: <1404828488-7649-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use signed type to check correctly for negative error code. The issue
was reported with static analyser:

[linux-3.13/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:270]:
(style) A pointer can not be negative so it is either pointless or an
error to check if it is.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=69071
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

