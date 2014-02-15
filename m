Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaBOMmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:42:38 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39884 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaBOMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:42:33 -0500
From: Levente Kurusa <levex@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Linux Media <linux-media@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Archana kumari <archanakumari959@gmail.com>,
        David Binderman <dcb314@hotmail.com>, Levente Kurusa <levex@linux.com>
Subject: [PATCH] staging: davinci_vpfe: fix error check
Date: Sat, 15 Feb 2014 11:17:11 +0100
Message-Id: <1392459431-28203-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check would check the pointer, which is never less than 0.
According to the error message, the correct check would be
to check the return value of ipipe_mode. Check that instead.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index 2d36b60..b2daf5e 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -267,7 +267,7 @@ int config_ipipe_hw(struct vpfe_ipipe_device *ipipe)
 	}
 
 	ipipe_mode = get_ipipe_mode(ipipe);
-	if (ipipe < 0) {
+	if (ipipe_mode < 0) {
 		pr_err("Failed to get ipipe mode");
 		return -EINVAL;
 	}
-- 
1.8.3.1

