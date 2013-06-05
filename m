Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3FEHxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:53:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:62131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3FEHxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:53:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,804,1363158000"; 
   d="scan'208";a="345029698"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.10] mei: me: clear interrupts on the resume path
Date: Wed,  5 Jun 2013 10:51:13 +0300
Message-Id: <1370418673-20112-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to clear pending interrupts on the resume
path. This brings the device into defined state
before starting the reset flow

This should solve suspend/resume issues:

mei_me : wait hw ready failed. status = 0x0
mei_me : version message write failed

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-me.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a2f5520f..1b3844e 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -306,6 +306,7 @@ static int mei_me_pci_resume(struct device *device)
 
 	mutex_lock(&dev->device_lock);
 	dev->dev_state = MEI_DEV_POWER_UP;
+	mei_clear_interrupts(dev);
 	mei_reset(dev, 1);
 	mutex_unlock(&dev->device_lock);
 
-- 
1.8.1.2

