Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3EQLw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:52:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18194 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3EQLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:52:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 17 May 2013 04:48:30 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
Date: Fri, 17 May 2013 14:49:44 +0300
Message-ID: <1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Syncpoint wait returned EAGAIN if it was called with zero timeout.
This patch modifies the function to return ETIMEDOUT.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/syncpt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 4b49345..5bf5366 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -187,7 +187,7 @@ int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh, long timeout,
 	}
 
 	if (!timeout) {
-		err = -EAGAIN;
+		err = -ETIMEDOUT;
 		goto done;
 	}
 
@@ -205,7 +205,7 @@ int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh, long timeout,
 	if (err)
 		goto done;
 
-	err = -EAGAIN;
+	err = -ETIMEDOUT;
 	/* Caller-specified timeout may be impractically low */
 	if (timeout < 0)
 		timeout = LONG_MAX;
-- 
1.7.9.5

