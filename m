Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab3DAOAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 10:00:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43915 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab3DAN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:57:48 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-f6-5159925bec4b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 03/11] usb: dwc3: Enable runtime pm only after PHYs are
 initialized
Date: Mon, 01 Apr 2013 19:24:02 +0530
Message-id: <1364824448-14732-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWjd6UmSgwfHHchYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiOKy
	SUnNySxLLdK3S+DK+LfmA0vBSe6Krr5O5gbGi5xdjJwcEgImEmtXH2CDsMUkLtxbD2RzcQgJ
	LGWUmLH+BStM0Yrtm1ghEosYJVa1PmWEcKYwSdz7f5cRpIpNQFei6e0uIJuDQ0QgTmLzBGGQ
	MLNAF5PE0qPiIGFhgQiJ/g25IGEWAVWJf7vbwObzCnhIbP8+GeoIBYk3t58xg9icAp4SH7Yu
	ZgKxhYBq2q+eALtBQuARu8TJA7vZIQYJSHybfIgFZL6EgKzEpgPMEHMkJQ6uuMEygVF4ASPD
	KkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzAKDr979nEHYz3D1gfYkwGGjeRWUo0OR8YhXkl
	8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJx231L5
	0dwF817vPs3E2KJZtDbrZVvSvn/aH6JezfLxnRgS1P6j8XRjOucO9jzXm1GxBeIp0RJZTeEm
	2zeEMBs8nd/o+3XOKdWrNuLFOnJyFUITdzYGsCp0C+e2ppyJmjRXYJvqAikGv8sGOS+igvlW
	SF70ePyG6QjPo39+jY77tK4f7bc8pMRSnJFoqMVcVJwIABwCziK4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG70pMhAg/Z2UYuD9+stzi47yGbR
	vHg9m0XvgqtsFhee9rBZXN41h81i9pJ+FosZ5/cxWSxa1spscX5LJ5PF4RUHmCyaT5xitpjw
	+wKbxfoZr1kc+DwWfL7C7jG74SKLx7yTgR77564B8u7+YPTo27KK0eP4je1MHp83yQVwRDUw
	2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA3a2kUJaY
	UwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzPi35gNLwUnuiq6+TuYGxoucXYyc
	HBICJhIrtm9ihbDFJC7cW8/WxcjFISSwiFFiVetTRghnCpPEvf93GUGq2AR0JZre7gKyOThE
	BOIkNk8QBgkzC3QxSSw9Kg4SFhaIkOjfkAsSZhFQlfi3uw1sPq+Ah8T275PZIHYpSLy5/YwZ
	xOYU8JT4sHUxE4gtBFTTfvUE6wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP0
	mfQOxlUNFocYBTgYlXh4Iy5EBAqxJpYVV+YeYpTgYFYS4V2RGRkoxJuSWFmVWpQfX1Sak1p8
	iDEZ6KqJzFKiyfnA9JFXEm9obGJuamxqaWJhYmZJmrCSOO/BVutAIYH0xJLU7NTUgtQimC1M
	HJxSDYzLEg8GrU+evMrX7Ukp17wFcn+cKxeYvkzYznDD3vqNf8oLn8on1f0PHEuOSJ026pyp
	bMnz4HpThVj3VK6VBZ+rWg82VIQw6PDHyzQ9dr10lIUvjjlS/Gz01wvGSyWrvqVer9Hy38t2
	wUR9A+/+GXvmW7blfa89OffV9XCbnvm9sTduqdcwsCmxFGckGmoxFxUnAgC1Mmz1FQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow dwc3 to enable auto power management only after its PHYs
are initialized so that any further PHY handling by dwc3's
runtime power management callbacks is fine.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/core.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 3a6993c..e250828 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -491,15 +491,6 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 
-	/* Setting device state as 'suspended' initially,
-	 * to make sure we know device state prior to
-	 * pm_runtime_enable
-	 */
-	pm_runtime_set_suspended(dev);
-	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
-	pm_runtime_forbid(dev);
-
 	dwc3_cache_hwparams(dwc);
 
 	ret = dwc3_alloc_event_buffers(dwc, DWC3_EVENT_BUFFERS_SIZE);
@@ -521,6 +512,15 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
+	/* Setting device state as 'suspended' initially,
+	 * to make sure we know device state prior to
+	 * pm_runtime_enable
+	 */
+	pm_runtime_set_suspended(dev);
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+	pm_runtime_forbid(dev);
+
 	if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
 		mode = DWC3_MODE_HOST;
 	else if (IS_ENABLED(CONFIG_USB_DWC3_GADGET))
-- 
1.7.6.5

