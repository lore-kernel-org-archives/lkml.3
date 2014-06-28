Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaF1SK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:10:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaF1RwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.15 065/139] media: exynos4-is: Fix compilation for !CONFIG_COMMON_CLK
Date: Sat, 28 Jun 2014 10:47:06 -0700
Message-Id: <20140628174608.399791262@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit f486e7c3cb9849b6a661931fa8c51a43d477046b upstream.

CONFIG_COMMON_CLK is not enabled on S5PV210 platform, so include
some clk API data structures conditionally to avoid compilation
errors. These #ifdefs will be removed for next kernel release,
when the S5PV210 platform moves to DT and the common clk API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/exynos4-is/media-dev.c |    2 +-
 drivers/media/platform/exynos4-is/media-dev.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1520,7 +1520,7 @@ err:
 }
 #else
 #define fimc_md_register_clk_provider(fmd) (0)
-#define fimc_md_unregister_clk_provider(fmd) (0)
+#define fimc_md_unregister_clk_provider(fmd)
 #endif
 
 static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -94,7 +94,9 @@ struct fimc_sensor_info {
 };
 
 struct cam_clk {
+#ifdef CONFIG_COMMON_CLK
 	struct clk_hw hw;
+#endif
 	struct fimc_md *fmd;
 };
 #define to_cam_clk(_hw) container_of(_hw, struct cam_clk, hw)
@@ -142,7 +144,9 @@ struct fimc_md {
 
 	struct cam_clk_provider {
 		struct clk *clks[FIMC_MAX_CAMCLKS];
+#ifdef CONFIG_COMMON_CLK
 		struct clk_onecell_data clk_data;
+#endif
 		struct device_node *of_node;
 		struct cam_clk camclk[FIMC_MAX_CAMCLKS];
 		int num_clocks;


