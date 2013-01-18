Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3ARNYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:24:45 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40133 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3ARNYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:24:44 -0500
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, rjw@sisk.pl, jhbird.choi@samsung.com
Subject: [PATCH v4 3/4] PM: DEVFREQ: Move exynos4 devfreq driver into a new sub-directory
Date: Fri, 18 Jan 2013 18:54:29 +0530
Message-Id: <1358515469-7529-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357733199-17206-3-git-send-email-a.kesavan@samsung.com>
References: <1357733199-17206-3-git-send-email-a.kesavan@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In anticipation of the new exynos5 devfreq and ppmu driver, create
an exynos sub-directory. Move the existing exynos4 devfreq driver
into the same.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
Note: No changes, rebased against latest tree. Only compile
tested for Exynos4.

 drivers/devfreq/Makefile                   |    2 +-
 drivers/devfreq/exynos/Makefile            |    2 ++
 drivers/devfreq/{ => exynos}/exynos4_bus.c |    0
 3 files changed, 3 insertions(+), 1 deletions(-)
 create mode 100644 drivers/devfreq/exynos/Makefile
 rename drivers/devfreq/{ => exynos}/exynos4_bus.c (100%)

diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 8c46423..3bc1fef 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
 obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 
 # DEVFREQ Drivers
-obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos4_bus.o
+obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
diff --git a/drivers/devfreq/exynos/Makefile b/drivers/devfreq/exynos/Makefile
new file mode 100644
index 0000000..1498823
--- /dev/null
+++ b/drivers/devfreq/exynos/Makefile
@@ -0,0 +1,2 @@
+# Exynos DEVFREQ Drivers
+obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos4_bus.o
diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
similarity index 100%
rename from drivers/devfreq/exynos4_bus.c
rename to drivers/devfreq/exynos/exynos4_bus.c
-- 
1.7.8.6

