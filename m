Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaLWKkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:40:23 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18026 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbaLWKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 02:38:37 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH nouveau 05/11] platform: switch to the new gpu rail clamping function
Date: Tue, 23 Dec 2014 18:39:58 +0800
Message-ID: <1419331204-26679-6-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drm/nouveau_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
index b307bbedd4c4..68788b17a45c 100644
--- a/drm/nouveau_platform.c
+++ b/drm/nouveau_platform.c
@@ -53,7 +53,7 @@ static int nouveau_platform_power_up(struct nouveau_platform_gpu *gpu)
 	reset_control_assert(gpu->rst);
 	udelay(10);
 
-	err = tegra_powergate_remove_clamping(TEGRA_POWERGATE_3D);
+	err = tegra_powergate_gpu_set_clamping(false);
 	if (err)
 		goto err_clamp;
 	udelay(10);
-- 
1.9.1

