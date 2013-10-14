Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3JNJKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:10:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:17108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab3JNJKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:10:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="392597888"
From: Zhang Rui <rui.zhang@intel.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 2/3] Platform: fix module autoloading for ACPI enumerated devices
Date: Mon, 14 Oct 2013 17:10:33 +0800
Message-Id: <1381741834-7334-2-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381741834-7334-1-git-send-email-rui.zhang@intel.com>
References: <1381741834-7334-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/platform.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4f8bef3..80d2250 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -690,6 +690,10 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (rc != -ENODEV)
 		return rc;
 
+	rc = acpi_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
+
 	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
 			pdev->name);
 	return 0;
-- 
1.7.9.5

