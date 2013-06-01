Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab3FAJxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:53:22 -0400
Received: from www17.your-server.de ([213.133.104.17]:60276 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab3FAJxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:53:15 -0400
X-Greylist: delayed 880 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jun 2013 05:53:15 EDT
Message-ID: <1370080390.29224.25.camel@localhost.localdomain>
Subject: [PATCH] dma-buf: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:53:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -680,10 +680,7 @@ int dma_buf_debugfs_create_file(const ch
 	d = debugfs_create_file(name, S_IRUGO, dma_buf_debugfs_dir,
 			write, &dma_buf_debug_fops);
 
-	if (IS_ERR(d))
-		return PTR_ERR(d);
-
-	return 0;
+	return PTR_RET(d);
 }
 #else
 static inline int dma_buf_init_debugfs(void)


