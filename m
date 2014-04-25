Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaDYJA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:00:29 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47624 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaDYJAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:00:25 -0400
From: Kefeng Wang <kefeng.wang@linaro.org>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, kefeng.wang@linaro.org, xuwei5@hisilicon.com
Subject: [PATCH v6 1/3] ata: ahci: append new hflag AHCI_HFLAG_NO_FBS
Date: Fri, 25 Apr 2014 16:59:09 +0800
Message-Id: <1398416351-30567-2-git-send-email-kefeng.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398416351-30567-1-git-send-email-kefeng.wang@linaro.org>
References: <1398416351-30567-1-git-send-email-kefeng.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append AHCI_HFLAG_NO_FBS to force turning off FBS flag.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
---
 drivers/ata/ahci.h    |    1 +
 drivers/ata/libahci.c |    5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b5eb886..48073ef 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -236,6 +236,7 @@ enum {
 						        port start (wait until
 						        error-handling stage) */
 	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
+	AHCI_HFLAG_NO_FBS		= (1 << 17), /* no FBS */
 
 	/* ap->flags bits */
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 6bd4f66..e1cf859 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -457,6 +457,11 @@ void ahci_save_initial_config(struct device *dev,
 		cap |= HOST_CAP_FBS;
 	}
 
+	if ((cap & HOST_CAP_FBS) && (hpriv->flags & AHCI_HFLAG_NO_FBS)) {
+		dev_info(dev, "controller can't do FBS, turning off CAP_FBS\n");
+		cap &= ~HOST_CAP_FBS;
+	}
+
 	if (force_port_map && port_map != force_port_map) {
 		dev_info(dev, "forcing port_map 0x%x -> 0x%x\n",
 			 port_map, force_port_map);
-- 
1.7.9.5

