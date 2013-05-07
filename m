Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3EGNql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:46:41 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:48562 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617Ab3EGNqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:38 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 21:46:36 +0800
Message-ID: <CAPgLHd_AKxWd1bOKF9afGLKsQzyfueYV6b3SrAf_V7ut2bUQzQ@mail.gmail.com>
Subject: [PATCH] powerpc/fsl_msi: fix error return code in fsl_of_msi_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: benh@kernel.crashing.org, paulus@samba.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, galak@kernel.crashing.org,
        u.kleine-koenig@pengutronix.de, agraf@suse.de,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the MSI bitmap alloc error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/powerpc/sysdev/fsl_msi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index ab02db3..f45556a 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -370,7 +370,6 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 	struct fsl_msi *msi;
 	struct resource res;
 	int err, i, j, irq_index, count;
-	int rc;
 	const u32 *p;
 	const struct fsl_msi_feature *features;
 	int len;
@@ -431,8 +430,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 	 */
 	msi->phandle = dev->dev.of_node->phandle;
 
-	rc = fsl_msi_init_allocator(msi);
-	if (rc) {
+	err = fsl_msi_init_allocator(msi);
+	if (err) {
 		dev_err(&dev->dev, "Error allocating MSI bitmap\n");
 		goto error_out;
 	}

