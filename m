Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3BDLJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:09:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5105 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3BDLJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:09:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 04 Feb 2013 03:06:05 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-tegra@vger.kernel.org>,
        Sami Liedes <sliedes@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/2] regmap: Fix build error next-20130204
Date: Mon, 4 Feb 2013 13:08:19 +0200
Message-ID: <1359976100-28871-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com>
References: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function 'regmap_async_complete_cb':
1656:3: error: 'TASK_NORMAL' undeclared (first use in this function)
In function 'regmap_async_complete':
1688:2: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/base/regmap/regmap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bee8560..49ec460 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -16,6 +16,8 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regmap.h>
-- 
1.7.9.5

