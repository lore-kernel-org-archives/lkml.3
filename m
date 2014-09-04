Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbaIDNTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:19:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:41308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaIDNTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:19:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,465,1406617200"; 
   d="scan'208";a="475176131"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: akpm@linux-foundation.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] kernel: Resolve a shadow warning
Date: Thu,  4 Sep 2014 06:18:57 -0700
Message-Id: <1409836737-29469-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve a shadow warning in W=2 builds arising from min/max macro
references in a parameter to a min3/max3 macro. There is no
functional issue - the warning is benign - but simply changing
some local variable names will eliminate it.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/kernel.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 95624be..c653902 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -716,22 +716,22 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	_max1 > _max2 ? _max1 : _max2; })
 
 #define min3(x, y, z) ({			\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	typeof(z) _min3 = (z);			\
-	(void) (&_min1 == &_min2);		\
-	(void) (&_min1 == &_min3);		\
-	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
-		(_min2 < _min3 ? _min2 : _min3); })
+	typeof(x) _min31 = (x);			\
+	typeof(y) _min32 = (y);			\
+	typeof(z) _min33 = (z);			\
+	(void) (&_min31 == &_min32);		\
+	(void) (&_min31 == &_min33);		\
+	_min31 < _min32 ? (_min31 < _min33 ? _min31 : _min33) : \
+		(_min32 < _min33 ? _min32 : _min33); })
 
 #define max3(x, y, z) ({			\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	typeof(z) _max3 = (z);			\
-	(void) (&_max1 == &_max2);		\
-	(void) (&_max1 == &_max3);		\
-	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
-		(_max2 > _max3 ? _max2 : _max3); })
+	typeof(x) _max31 = (x);			\
+	typeof(y) _max32 = (y);			\
+	typeof(z) _max33 = (z);			\
+	(void) (&_max31 == &_max32);		\
+	(void) (&_max31 == &_max33);		\
+	_max31 > _max32 ? (_max31 > _max33 ? _max31 : _max33) : \
+		(_max32 > _max33 ? _max32 : _max33); })
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
-- 
1.9.3

