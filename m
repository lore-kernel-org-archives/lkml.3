Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632Ab3E2K2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:28:00 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10717 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965596Ab3E2K16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:27:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 May 2013 03:27:44 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@gmail.com>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <tbergstrom@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCHv2 5/7] gpu: host1x: Fix memory access in syncpt request
Date: Wed, 29 May 2013 13:26:06 +0300
Message-ID: <1369823168-5396-6-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
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
 drivers/gpu/host1x/syncpt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 4b49345..2b03f1b 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -40,7 +40,8 @@ static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
 
 	for (i = 0; i < host->info->nb_pts && sp->name; i++, sp++)
 		;
-	if (sp->dev)
+
+	if (i >= host->info->nb_pts)
 		return NULL;
 
 	name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
-- 
1.8.1.5

