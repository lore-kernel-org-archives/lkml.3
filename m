Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3JIL6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:58:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10268 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3JIL6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:58:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Oct 2013 04:58:51 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCH 3/3] drm/tegra: Reserve base for gr2d
Date: Wed, 9 Oct 2013 14:54:10 +0300
Message-ID: <1381319650-9799-4-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com>
References: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the gr2d to reserve a base for syncpoint.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/gr2d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 27ffcf1..f0c3fd5 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -285,7 +285,7 @@ static int gr2d_probe(struct platform_device *pdev)
 	if (!gr2d->channel)
 		return -ENOMEM;
 
-	*syncpts = host1x_syncpt_request(dev, false);
+	*syncpts = host1x_syncpt_request_based(dev, false);
 	if (!(*syncpts)) {
 		host1x_channel_free(gr2d->channel);
 		return -ENOMEM;
-- 
1.8.1.5

