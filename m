Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaILXHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:07:43 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59661 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaILXHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:13 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] eeepc-laptop: pull out ACPI_STORE_FUNC and ACPI_SHOW_FUNC macros
Date: Sat, 13 Sep 2014 01:06:45 +0200
Message-Id: <1410563212-31565-7-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull out macros EEEPC_ACPI_STORE_FUNC and EEEPC_ACPI_SHOW_FUNC. These
macros define functions that call store_sys_acpi() and show_sys_acpi()
respectively. This helps prevent duplication later on.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 8225b1e..3c04b77 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -295,19 +295,25 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
 	return sprintf(buf, "%d\n", value);
 }
 
-#define EEEPC_CREATE_DEVICE_ATTR(_name, _mode, _cm)			\
+#define EEEPC_ACPI_SHOW_FUNC(_name, _cm)				\
 	static ssize_t show_##_name(struct device *dev,			\
 				    struct device_attribute *attr,	\
 				    char *buf)				\
 	{								\
 		return show_sys_acpi(dev, _cm, buf);			\
-	}								\
+	}
+
+#define EEEPC_ACPI_STORE_FUNC(_name, _cm)				\
 	static ssize_t store_##_name(struct device *dev,		\
 				     struct device_attribute *attr,	\
 				     const char *buf, size_t count)	\
 	{								\
 		return store_sys_acpi(dev, _cm, buf, count);		\
-	}								\
+	}
+
+#define EEEPC_CREATE_DEVICE_ATTR(_name, _mode, _cm)			\
+	EEEPC_ACPI_SHOW_FUNC(_name, _cm)				\
+	EEEPC_ACPI_STORE_FUNC(_name, _cm)				\
 	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name)
 
 EEEPC_CREATE_DEVICE_ATTR(camera, S_IWUSR | S_IRUGO, CM_ASL_CAMERA);
-- 
2.1.0

