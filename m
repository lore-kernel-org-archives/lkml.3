Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaBLIYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:24:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50234 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbaBLIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:05 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andreas Hollmann" <hollmann@in.tum.de>,
        "Jean Delvare" <khali@linux-fr.org>,
        "Guenter Roeck" <linux@roeck-us.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.204866558@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 71/79] hwmon: (coretemp) Fix truncated name of alarm
 attributes
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/coretemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -52,7 +52,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in
 
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
 #define NUM_REAL_CORES		32	/* Number of Real cores per cpu */
-#define CORETEMP_NAME_LENGTH	17	/* String Length of attrs */
+#define CORETEMP_NAME_LENGTH	19	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)

