Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaCJVfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:35:16 -0400
Received: from xes-mad.com ([216.165.139.218]:57798 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbaCJVfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:35:14 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/8] mfd: lpc_ich: Fix ACPI enable bitmask
Date: Mon, 10 Mar 2014 16:34:51 -0500
Message-Id: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.7.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original bitmask of 0x10 was incorrect and would result in a write
to a reserved read-only bit instead of enabling the ACPI I/O
region.  Update it to the proper value of 0x80.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Tested-by: Rajat Jain <rajatjain@juniper.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Ralston <james.d.ralston@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/lpc_ich.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index be93fa2..be10ad4 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -759,7 +759,7 @@ static void lpc_ich_enable_acpi_space(struct pci_dev *dev)
 	u8 reg_save;
 
 	pci_read_config_byte(dev, priv->acpi.ctrl, &reg_save);
-	pci_write_config_byte(dev, priv->acpi.ctrl, reg_save | 0x10);
+	pci_write_config_byte(dev, priv->acpi.ctrl, reg_save | 0x80);
 	priv->acpi.save = reg_save;
 }
 
-- 
1.7.7.GIT

