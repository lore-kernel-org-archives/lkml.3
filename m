Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbaGXHsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:48:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56757 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934309AbaGXHsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:48:15 -0400
Date: Thu, 24 Jul 2014 00:47:18 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: andi@firstfloor.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] powerpc/perf: include util/util.h and remove
 stringify macros
Message-ID: <20140724074718.GB18829@us.ibm.com>
References: <20140724074645.GA18829@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724074645.GA18829@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072407-9332-0000-0000-0000017D21F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC PATCH 1/2] powerpc/perf: include util/util.h and remove stringify macros

The stringify macros are defined in tools/perf/util/util.h and
don't need to be redfined specfiically for powerpc.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/arch/powerpc/util/header.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 2f7073d..6c1b8a7 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -5,9 +5,7 @@
 #include <string.h>
 
 #include "../../util/header.h"
-
-#define __stringify_1(x)        #x
-#define __stringify(x)          __stringify_1(x)
+#include "../../util/util.h"
 
 #define mfspr(rn)       ({unsigned long rval; \
 			 asm volatile("mfspr %0," __stringify(rn) \
-- 
1.7.9.5

