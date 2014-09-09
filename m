Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbaIIFgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:36:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:27941 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbaIIFgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208,223";a="383348211"
Message-ID: <540E91F0.2060306@linux.intel.com>
Date: Tue, 09 Sep 2014 13:36:48 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS
 devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6deb00230f5df68da3ca7490402a0c537bf386bb Mon Sep 17 00:00:00 2001
From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
Date: Tue, 9 Sep 2014 13:02:25 +0800
Subject: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices

LPSS devices must suspend/resume in fixed order. Or some LPSS devices
will hang during the transition to ACPI_STATE_D0 state.

Signed-off-by: Li Aubrey <aubrey.li@linux.intel.com>
Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index fddc1e8..54e5c97 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -419,7 +419,7 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
 	adev->driver_data = pdata;
 	pdev = acpi_create_platform_device(adev);
 	if (!IS_ERR_OR_NULL(pdev)) {
-		device_enable_async_suspend(&pdev->dev);
+		device_disable_async_suspend(&pdev->dev);
 		return 1;
 	}
 
-- 1.7.1

