Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaAZDH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:07:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaAZDEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:04:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Hollmann <hollmann@in.tum.de>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.4 05/12] hwmon: (coretemp) Fix truncated name of alarm attributes
Date: Sat, 25 Jan 2014 19:05:08 -0800
Message-Id: <20140126030452.347123628@linuxfoundation.org>
X-Mailer: git-send-email 1.9.rc0.19.gb594c97
In-Reply-To: <20140126030451.934281002@linuxfoundation.org>
References: <20140126030451.934281002@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 3f9aec7610b39521c7c69d754de7265f6994c194 upstream.

When the core number exceeds 9, the size of the buffer storing the
alarm attribute name is insufficient and the attribute name is
truncated. This causes libsensors to skip these attributes as the
truncated name is not recognized.

Reported-by: Andreas Hollmann <hollmann@in.tum.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/coretemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -53,7 +53,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in
 
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
 #define NUM_REAL_CORES		32	/* Number of Real cores per cpu */
-#define CORETEMP_NAME_LENGTH	17	/* String Length of attrs */
+#define CORETEMP_NAME_LENGTH	19	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)


