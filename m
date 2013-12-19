Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3LSL7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:59:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45293 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3LSL7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Kevin B. Smith" <kevin.b.smith@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 178/208] x86, build, icc: Remove uninitialized_var() from compiler-intel.h
Date: Thu, 19 Dec 2013 11:54:36 +0000
Message-Id: <1387454106-19326-179-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/compiler-intel.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index 973ce10..dc1bd3d 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -28,8 +28,6 @@
 
 #endif
 
-#define uninitialized_var(x) x
-
 #ifndef __HAVE_BUILTIN_BSWAP16__
 /* icc has this, but it's called _bswap16 */
 #define __HAVE_BUILTIN_BSWAP16__
-- 
1.8.3.2

