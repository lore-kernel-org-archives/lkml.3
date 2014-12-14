Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbaLNXGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:06:05 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48390 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLNXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:05:55 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ken Cox <jkc@redhat.com>, Erik Arfvidson <erik.arfvidson@unisys.com>,
        Silvio F <silvio.fricke@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: virtpci: virtpci.c:  Removes unnecessary NULL check
Date: Mon, 15 Dec 2014 00:08:37 +0100
Message-Id: <1418598517-25289-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is impossible for dprivate to ever be NULL, no check required.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/unisys/virtpci/virtpci.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index ee9f826..37b94de 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -1314,18 +1314,13 @@ static ssize_t virtpci_driver_attr_show(struct kobject *kobj,
 	ssize_t ret = 0;
 
 	struct driver_private *dprivate = to_driver(kobj);
-	struct device_driver *driver;
+	struct device_driver *driver = dprivate->driver;
 
-	if (dprivate != NULL)
-		driver = dprivate->driver;
-	else
-		driver = NULL;
+	DBGINF("In virtpci_driver_attr_show driver->name:%s\n",	driver->name);
+
+	if (dattr->show)
+		ret = dattr->show(driver, buf);
 
-	DBGINF("In virtpci_driver_attr_show driver->name:%s\n", driver->name);
-	if (driver) {
-		if (dattr->show)
-			ret = dattr->show(driver, buf);
-	}
 	return ret;
 }
 
@@ -1337,19 +1332,13 @@ static ssize_t virtpci_driver_attr_store(struct kobject *kobj,
 	ssize_t ret = 0;
 
 	struct driver_private *dprivate = to_driver(kobj);
-	struct device_driver *driver;
-
-	if (dprivate != NULL)
-		driver = dprivate->driver;
-	else
-		driver = NULL;
+	struct device_driver *driver = dprivate->driver;
 
 	DBGINF("In virtpci_driver_attr_store driver->name:%s\n", driver->name);
 
-	if (driver) {
-		if (dattr->store)
-			ret = dattr->store(driver, buf, count);
-	}
+	if (dattr->store)
+		ret = dattr->store(driver, buf, count);
+
 	return ret;
 }
 
-- 
1.7.10.4

