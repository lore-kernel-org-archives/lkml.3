Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3L2CJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:09:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54993 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab3L2CJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:46 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sunil K. Pandey" <sunil.k.pandey@intel.com>,
        "Kevin B. Smith" <kevin.b.smith@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.268261861@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 133/185] x86, build, icc: Remove uninitialized_var()
 from compiler-intel.h
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/compiler-intel.h | 2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -27,5 +27,3 @@
 #define __must_be_array(a) 0
 
 #endif
-
-#define uninitialized_var(x) x

