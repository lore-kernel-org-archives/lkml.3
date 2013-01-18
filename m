Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3ARBkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:40:12 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:62900 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3ARBkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:40:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 1/2] powerpc/5200: Fix size to request_mem_region() call
Date: Fri, 18 Jan 2013 01:39:59 +0000
Message-Id: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Bestcomm driver requests a memory region larger than the one
described in the device tree. This is due to an extra undocumented field
in the bestcomm register structure. This hasn't been a problem up to
now, but there is a patch pending to make the DT platform_bus support
code use platform_device_add() which tightens the rules and provides
extra checks for drivers to stay within the specified register regions.

Alternately, I could have removed the extra field from the structure,
but I'm not sure if it is still needed for resume to work. Better be
safe and leave it in.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anatolij Gustschin <agust@denx.de>
---
 arch/powerpc/sysdev/bestcomm/bestcomm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.c b/arch/powerpc/sysdev/bestcomm/bestcomm.c
index d913063..81c3314 100644
--- a/arch/powerpc/sysdev/bestcomm/bestcomm.c
+++ b/arch/powerpc/sysdev/bestcomm/bestcomm.c
@@ -414,7 +414,7 @@ static int mpc52xx_bcom_probe(struct platform_device *op)
 		goto error_sramclean;
 	}
 
-	if (!request_mem_region(res_bcom.start, sizeof(struct mpc52xx_sdma),
+	if (!request_mem_region(res_bcom.start, resource_size(&res_bcom),
 				DRIVER_NAME)) {
 		printk(KERN_ERR DRIVER_NAME ": "
 			"Can't request registers region\n");
-- 
1.7.10.4

