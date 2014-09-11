Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaIKNEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbaIKNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sam Ravnborg" <sam@ravnborg.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.996590309@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 122/131] sparc: use asm-generic version of types.h
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

commit cbf1ef6b3345d2cc7e62407eec6a6f72a8b1346f upstream.

In sparc headers we use the following pattern:

    #if defined(__sparc__) && defined(__arch64__)

    sparc64 specific stuff

    #else

    sparc32 specific stuff

    #endif

In types.h this pattern was not followed and here
we only checked for __sparc__ for no good reason.
It was a left-over from long time ago.

I checked other architectures - and most of them
do not have any such checks. And all the recently
merged versions uses the asm-generic version.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[bwh: Guenter backported this to 3.2:
 - Adjusted filenames, context
 - There's no duplicate export of types.h to delete]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -21,3 +21,4 @@ generic-y += div64.h
 generic-y += local64.h
 generic-y += irq_regs.h
 generic-y += local.h
+generic-y += types.h
--- a/arch/sparc/include/asm/types.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _SPARC_TYPES_H
-#define _SPARC_TYPES_H
-/*
- * This file is never included by application software unless
- * explicitly requested (e.g., via linux/types.h) in which case the
- * application is Linux specific so (user-) name space pollution is
- * not a major issue.  However, for interoperability, libraries still
- * need to be careful to avoid a name clashes.
- */
-
-#if defined(__sparc__)
-
-#include <asm-generic/int-ll64.h>
-
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* defined(__sparc__) */
-
-#endif /* defined(_SPARC_TYPES_H) */

