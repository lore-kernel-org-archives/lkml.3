Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaK1JjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:39:06 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5197 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaK1JjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:39:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Nov 2014 01:37:26 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: [V2 PATCH] soc/tegra: fuse: export tegra_sku_info for module use
Date: Fri, 28 Nov 2014 17:41:02 +0800
Message-ID: <1417167662-20618-1-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Tegra drivers might be complied as kernel modules, and
they need the fuse information for initialization. One
example is the GK20A Nouveau driver. It needs the GPU speedo
value to calculate frequency-voltage table. So export
the tegra_sku_info.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---

v2: add more description why we need this patch

 drivers/soc/tegra/fuse/fuse-tegra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra.c b/drivers/soc/tegra/fuse/fuse-tegra.c
index 11a5043959dc..011a3363c265 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra.c
@@ -31,6 +31,7 @@
 static u32 (*fuse_readl)(const unsigned int offset);
 static int fuse_size;
 struct tegra_sku_info tegra_sku_info;
+EXPORT_SYMBOL(tegra_sku_info);
 
 static const char *tegra_revision_name[TEGRA_REVISION_MAX] = {
 	[TEGRA_REVISION_UNKNOWN] = "unknown",
-- 
1.9.1

