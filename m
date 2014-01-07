Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaAGUD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:03:26 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:58767 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaAGUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:03:20 -0500
From: Erik Faye-Lund <kusmabite@gmail.com>
To: linux-tegra@vger.kernel.org
Cc: thierry.reding@gmail.com, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Erik Faye-Lund <kusmabite@gmail.com>
Subject: [PATCH] gpu: host1x: do not check previously handled gathers
Date: Tue,  7 Jan 2014 21:03:06 +0100
Message-Id: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When patching gathers, we don't need to check against
gathers with lower indices than the current one, as
they are guaranteed to already have been handled.

Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
---

Here's a trivial optimization I have been running with for a while.

 drivers/gpu/host1x/job.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index de5ec33..e965805 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -534,7 +534,7 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 
 		g->base = job->gather_addr_phys[i];
 
-		for (j = 0; j < job->num_gathers; j++)
+		for (j = i + 1; j < job->num_gathers; j++)
 			if (job->gathers[j].bo == g->bo)
 				job->gathers[j].handled = true;
 
-- 
1.8.1.2

