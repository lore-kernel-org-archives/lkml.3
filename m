Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3LQSPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:15:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab3LQSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Kevin B. Smith" <kevin.b.smith@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 088/103] x86, build, icc: Remove uninitialized_var() from compiler-intel.h
Date: Tue, 17 Dec 2013 18:13:17 +0000
Message-Id: <1387304012-23805-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 503cf95c061a0551eb684da364509297efbe55d9 upstream.

When compiling with icc, <linux/compiler-gcc.h> ends up included
because the icc environment defines __GNUC__.  Thus, we neither need
nor want to have this macro defined in both compiler-gcc.h and
compiler-intel.h, and the fact that they are inconsistent just makes
the compiler spew warnings.

Reported-by: Sunil K. Pandey <sunil.k.pandey@intel.com>
Cc: Kevin B. Smith <kevin.b.smith@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-0mbwou1zt7pafij09b897lg3@git.kernel.org
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/compiler-intel.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index d8e636e..cba9593 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -27,5 +27,3 @@
 #define __must_be_array(a) 0
 
 #endif
-
-#define uninitialized_var(x) x
-- 
1.8.3.2

