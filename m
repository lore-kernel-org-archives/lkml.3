Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3EQLx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:53:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11193 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab3EQLw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:52:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 17 May 2013 04:52:22 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCH 3/6] gpu: host1x: Fix memory access in syncpt request
Date: Fri, 17 May 2013 14:49:45 +0300
Message-ID: <1368791388-31441-4-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bad memory access in syncpoint request code. If
no syncpoints were available, the code accessed unreserved memory
area causing unexpected behaviour.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/syncpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 5bf5366..6b7ee88 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -40,7 +40,7 @@ static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
 
 	for (i = 0; i < host->info->nb_pts && sp->name; i++, sp++)
 		;
-	if (sp->dev)
+	if (i >= host->info->nb_pts)
 		return NULL;
 
 	name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
-- 
1.7.9.5

