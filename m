Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaDVD76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:59:58 -0400
Received: from ozlabs.org ([103.22.144.67]:51144 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbaDVD7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Vincent Sanders <vince@simtec.co.uk>, Ben Dooks <ben@simtec.co.uk>
Subject: [PATCH 2/9] drivers/video/fbdev/sm501fb.c: avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:25 +0930
Message-Id: <1398137612-9714-3-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/video/fbdev/sm501fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sm501fb.c b/drivers/video/fbdev/sm501fb.c
index 1501979099dc..c2c8eb668784 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -1215,7 +1215,7 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
 }
 
 /* Prepare the device_attr for registration with sysfs later */
-static DEVICE_ATTR(crt_src, 0666, sm501fb_crtsrc_show, sm501fb_crtsrc_store);
+static DEVICE_ATTR(crt_src, 0664, sm501fb_crtsrc_show, sm501fb_crtsrc_store);
 
 /* sm501fb_show_regs
  *
-- 
1.8.3.2

