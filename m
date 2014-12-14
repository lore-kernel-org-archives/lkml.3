Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaLNWih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:38:37 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37595 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLNWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:38:29 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ken Cox <jkc@redhat.com>, Erik Arfvidson <erik.arfvidson@unisys.com>,
        Silvio F <silvio.fricke@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: virtpci: virtpci.c:  Fix for possible null pointer dereference
Date: Sun, 14 Dec 2014 23:41:11 +0100
Message-Id: <1418596871-24827-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/unisys/virtpci/virtpci.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index ee9f826..d818eda 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -1314,15 +1314,13 @@ static ssize_t virtpci_driver_attr_show(struct kobject *kobj,
 	ssize_t ret = 0;
 
 	struct driver_private *dprivate = to_driver(kobj);
-	struct device_driver *driver;
 
-	if (dprivate != NULL)
-		driver = dprivate->driver;
-	else
-		driver = NULL;
+	if (dprivate) {
+		struct device_driver *driver = dprivate->driver;
+
+		DBGINF("In virtpci_driver_attr_show driver->name:%s\n",
+				driver->name);
 
-	DBGINF("In virtpci_driver_attr_show driver->name:%s\n", driver->name);
-	if (driver) {
 		if (dattr->show)
 			ret = dattr->show(driver, buf);
 	}
@@ -1337,16 +1335,13 @@ static ssize_t virtpci_driver_attr_store(struct kobject *kobj,
 	ssize_t ret = 0;
 
 	struct driver_private *dprivate = to_driver(kobj);
-	struct device_driver *driver;
 
-	if (dprivate != NULL)
-		driver = dprivate->driver;
-	else
-		driver = NULL;
+	if (dprivate) {
+		struct device_driver *driver = dprivate->driver;
 
-	DBGINF("In virtpci_driver_attr_store driver->name:%s\n", driver->name);
+		DBGINF("In virtpci_driver_attr_store driver->name:%s\n",
+				driver->name);
 
-	if (driver) {
 		if (dattr->store)
 			ret = dattr->store(driver, buf, count);
 	}
-- 
1.7.10.4

