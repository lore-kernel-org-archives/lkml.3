Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab3CLSVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:21:36 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:63395 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab3CLSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:21:33 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, yunhong.jiang@intel.com, sheng@linux.intel.com,
        mikechan@google.com, xiaohui.xin@intel.com, jun.nakajima@intel.com,
        linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] mmc: host: use resource_size()
Date: Tue, 12 Mar 2013 20:21:26 +0200
Message-Id: <1363112486-2543-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() instead of explicit calculation. This was found via
make coccicheck.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/mmc/host/android-goldfish.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/android-goldfish.c b/drivers/mmc/host/android-goldfish.c
index ef3aef0..7780c14 100644
--- a/drivers/mmc/host/android-goldfish.c
+++ b/drivers/mmc/host/android-goldfish.c
@@ -476,7 +476,7 @@ static int goldfish_mmc_probe(struct platform_device *pdev)
 	host->mmc = mmc;
 
 	pr_err("mmc: Mapping %lX to %lX\n", (long)res->start, (long)res->end);
-	host->reg_base = ioremap(res->start, res->end - res->start + 1);
+	host->reg_base = ioremap(res->start, resource_size(res));
 	if (host->reg_base == NULL) {
 		ret = -ENOMEM;
 		goto ioremap_failed;
-- 
1.7.9.5

