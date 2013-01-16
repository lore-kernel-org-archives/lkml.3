Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab3APQCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36030 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab3APQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 080/222] x86,AMD: Power driver support for AMD's family 16h processors
Date: Wed, 16 Jan 2013 13:54:40 -0200
Message-Id: <1358351822-7675-81-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit 22e32f4f57778ebc6e17812fa3008361c05d64f9 upstream.

Add family 16h PCI ID to AMD's power driver to allow it report
power consumption on these processors.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/hwmon/fam15h_power.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 49dadf4..e5c9b44 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -31,6 +31,9 @@ MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
 MODULE_AUTHOR("Andreas Herrmann <andreas.herrmann3@amd.com>");
 MODULE_LICENSE("GPL");
 
+/* Family 16h Northbridge's function 4 PCI ID */
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
+
 /* D18F3 */
 #define REG_NORTHBRIDGE_CAP		0xe8
 
@@ -256,6 +259,7 @@ static void __devexit fam15h_power_remove(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(fam15h_power_id_table) = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
-- 
1.7.9.5

