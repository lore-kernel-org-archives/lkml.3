Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaIWVj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:39:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:37460 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbaIWVjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:39:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,582,1406617200"; 
   d="scan'208";a="604279472"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Foley <pefoley2@pefoley.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd builds for kernels < 3.13
Date: Tue, 23 Sep 2014 14:55:14 -0700
Message-Id: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpssd depends on headers available in kernels >= 3.13. Therefore
disable the build for kernels < 3.13. For kernels < 3.13, to avoid the
appearance of a build break simply print an error message and exit.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Foley <pefoley2@pefoley.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 Documentation/mic/mpssd/mpssd.c | 15 +++++++++++++++
 Documentation/mic/mpssd/sysfs.c |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 3c5c379..2cc48cc 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -18,6 +18,10 @@
  * Intel MIC User Space Tools.
  */
 
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 13, 0))
+
 #define _GNU_SOURCE
 
 #include <stdlib.h>
@@ -1726,3 +1730,14 @@ main(int argc, char *argv[])
 
 	exit(0);
 }
+#else /* kernel version < 3.13 */
+
+#include <stdio.h>
+#include <stdlib.h>
+
+int main(void)
+{
+	fprintf(stderr, "mpssd is only usable against kernels >= 3.13\n");
+	exit(1);
+}
+#endif
diff --git a/Documentation/mic/mpssd/sysfs.c b/Documentation/mic/mpssd/sysfs.c
index 8dd3269..1e3ff75 100644
--- a/Documentation/mic/mpssd/sysfs.c
+++ b/Documentation/mic/mpssd/sysfs.c
@@ -18,6 +18,10 @@
  * Intel MIC User Space Tools.
  */
 
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 13, 0))
+
 #include "mpssd.h"
 
 #define PAGE_SIZE 4096
@@ -100,3 +104,4 @@ done:
 		free(oldvalue);
 	return ret;
 }
+#endif
-- 
2.0.0.rc3.2.g998f840

