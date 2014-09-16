Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaIPWI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:08:29 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60285 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbaIPWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:08:25 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>
Date: Tue, 16 Sep 2014 23:38:38 +0000
Message-Id: <1410910735-27929-2-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 01/18] usbip: sysfs_utils: add read_sysfs_attribute
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous rework of usbip's sysfs access structures called for a
read_sysfs_attribute function to be implemented in sysfs_utils.c

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
---
 tools/usb/usbip/libsrc/sysfs_utils.c | 23 +++++++++++++++++++++++
 tools/usb/usbip/libsrc/sysfs_utils.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/tools/usb/usbip/libsrc/sysfs_utils.c b/tools/usb/usbip/libsrc/sysfs_utils.c
index 36ac88e..fc6d9f9 100644
--- a/tools/usb/usbip/libsrc/sysfs_utils.c
+++ b/tools/usb/usbip/libsrc/sysfs_utils.c
@@ -29,3 +29,26 @@ int write_sysfs_attribute(const char *attr_path, const char *new_value,
 
 	return 0;
 }
+
+int read_sysfs_attribute(const char *attr_path, char *buffer, size_t buffsize)
+{
+	int fd;
+	int length;
+
+	fd = open(attr_path, O_RDONLY);
+	if (fd < 0) {
+		dbg("error opening attribute %s", attr_path);
+		return -1;
+	}
+
+	length = read(fd, buffer, buffsize);
+	if (length < 0) {
+		dbg("error reading from attribute %s", attr_path);
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return length;
+}
diff --git a/tools/usb/usbip/libsrc/sysfs_utils.h b/tools/usb/usbip/libsrc/sysfs_utils.h
index 32ac1d1..c1f1b79 100644
--- a/tools/usb/usbip/libsrc/sysfs_utils.h
+++ b/tools/usb/usbip/libsrc/sysfs_utils.h
@@ -4,5 +4,6 @@
 
 int write_sysfs_attribute(const char *attr_path, const char *new_value,
 			  size_t len);
+int read_sysfs_attribute(const char *attr_path, char *buffer, size_t buffsize);
 
 #endif
-- 
2.1.0

