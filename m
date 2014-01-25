Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaAYVrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:47:48 -0500
Received: from mout.gmx.net ([212.227.15.15]:61501 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbaAYVrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:47:47 -0500
Date: Sat, 25 Jan 2014 22:47:44 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] misc: genwqe: Fix potential memory leak when pinning memory
Message-ID: <20140125224744.0a9c360c@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:mmK3BDoL57GJTNp3rSVwjiIGRolhXvANg560atEqGyrNMwN79Tu
 MyBlBkof9Y37hwzLwcI1+mMiyi7rkWAihhnbd34RV2z1yR62Xdre/CGPJuVEZ8CoJen6PUl
 rX603dlsepp3PUQCXQiz2AGtYD+ahSmdqtJxI3aLJb0iu1k2IwiRqswWgYJQyRZj/kO/YWt
 95SsHpiWZNIfy8igXWI/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak in the genwqe_pin_mem() error path as called by
ioctl GENWQE_PIN_MEM. In case there is an error encountered when
mapping memory, the already allocated dma_mapping struct needs to
be freed correctly.

Detected by Coverity: CID 1162606.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/misc/genwqe/card_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
index 8f8a6b3..2c2c9cc 100644
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -787,6 +787,7 @@ static int genwqe_pin_mem(struct genwqe_file *cfile, struct genwqe_mem *m)
 	if (rc != 0) {
 		dev_err(&pci_dev->dev,
 			"[%s] genwqe_user_vmap rc=%d\n", __func__, rc);
+		kfree(dma_map);
 		return rc;
 	}
 
-- 
1.8.3.2
