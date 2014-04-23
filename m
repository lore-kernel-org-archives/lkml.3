Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaDWLhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:37:13 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39002 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaDWLhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:37:05 -0400
From: Kefeng Wang <kefeng.wang@linaro.org>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, kefeng.wang@linaro.org,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH v4 1/3] ata: ahci: append new hflag AHCI_HFLAG_NO_FBS
Date: Wed, 23 Apr 2014 19:36:45 +0800
Message-Id: <1398253008-17059-2-git-send-email-kefeng.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398253008-17059-1-git-send-email-kefeng.wang@linaro.org>
References: <1398253008-17059-1-git-send-email-kefeng.wang@linaro.org>
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
index 51af275..60db49b 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -235,6 +235,7 @@ enum {
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

