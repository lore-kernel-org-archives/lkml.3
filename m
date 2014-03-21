Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbaCUNwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:52:31 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34579 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaCUNw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:52:29 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: [PATCH] drivers: staging: cxt1e1: hwprobe Fix different address spaces
Date: Fri, 21 Mar 2014 15:52:23 +0200
Message-Id: <1395409943-19023-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix different address spaces when unmapping IO. hi->addr_mapped[0]
and hi->addr_mapped[1] should be tagged __iomem.

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/staging/cxt1e1/hwprobe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 9b4198b..f55c27e 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -174,12 +174,12 @@ cleanup_ioremap(void)
 		if (hi->pci_slot == 0xff)
 			break;
 		if (hi->addr_mapped[0]) {
-			iounmap((void *)(hi->addr_mapped[0]));
+			iounmap((void __iomem *)(hi->addr_mapped[0]));
 			release_mem_region((long) hi->addr[0], hi->len[0]);
 			hi->addr_mapped[0] = 0;
 		}
 		if (hi->addr_mapped[1]) {
-			iounmap((void *)(hi->addr_mapped[1]));
+			iounmap((void __iomem *)(hi->addr_mapped[1]));
 			release_mem_region((long) hi->addr[1], hi->len[1]);
 			hi->addr_mapped[1] = 0;
 		}
-- 
1.7.9.5

