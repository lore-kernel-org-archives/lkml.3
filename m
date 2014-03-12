Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaCLMkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:40:19 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56531 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaCLMkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:40:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, b.zolnierkie@samsung.com,
        linux-ide@vger.kernel.org
Subject: [PATCH 5/5] ahci: st: Invoke AHCI Platform Suspend/Resume
Date: Wed, 12 Mar 2014 12:39:42 +0000
Message-Id: <1394627982-23726-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
References: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we disable IRQs on suspend and update the internal
power state during suspend/resume.

Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/ata/ahci_st.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 3edec5d..17191b9 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -186,6 +186,10 @@ static int st_ahci_suspend(struct device *dev)
 	struct ahci_host_priv *hpriv = drv_data->hpriv;
 	int err;
 
+	ret = ahci_platform_suspend_host(dev);
+	if (ret)
+		return ret;
+
 	if (drv_data->pwr) {
 		err = reset_control_assert(drv_data->pwr);
 		if (err) {
@@ -215,7 +219,7 @@ static int st_ahci_resume(struct device *dev)
 		return err;
 	}
 
-	return 0;
+	return ahci_platform_resume_host(dev);
 }
 #endif
 
-- 
1.8.3.2

