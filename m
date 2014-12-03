Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaLCLlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:41:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbaLCL1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Florian Fainelli <florian@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 084/101] drivers/vlynq/vlynq.c: fix another resource size off by 1 error
Date: Wed,  3 Dec 2014 12:26:46 +0100
Message-Id: <c5988e0e5c0858bc916f5a15a066cc0d3d614e93.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 59d42cd43c7335a3a8081fd6ee54ea41b0c239be upstream.

We fixed the call to request_mem_region() in commit 3354f73b24c6
("drivers/vlynq/vlynq.c: fix resource size off by 1 error").  But we
need to fix the call the release_mem_region() as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/vlynq/vlynq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index 7b07135ab26e..c0227f9418eb 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -762,7 +762,8 @@ static int vlynq_remove(struct platform_device *pdev)
 
 	device_unregister(&dev->dev);
 	iounmap(dev->local);
-	release_mem_region(dev->regs_start, dev->regs_end - dev->regs_start);
+	release_mem_region(dev->regs_start,
+			   dev->regs_end - dev->regs_start + 1);
 
 	kfree(dev);
 
-- 
2.1.3

