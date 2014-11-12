Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaKLRFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:05:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:39959 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbaKLRE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:04:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="606712238"
Subject: [PATCH 04/11] ia64: sync struct siginfo with general version
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, qiaowei.ren@intel.com,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 12 Nov 2014 09:04:56 -0800
References: <20141112170443.B4BD0899@viggo.jf.intel.com>
In-Reply-To: <20141112170443.B4BD0899@viggo.jf.intel.com>
Message-Id: <20141112170456.AD302D1B@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>


New fields about bound violation are added into general struct
siginfo. This will impact MIPS and IA64, which extend general
struct siginfo. This patch syncs this struct for IA64 with
general version.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/ia64/include/uapi/asm/siginfo.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/ia64/include/uapi/asm/siginfo.h~2014-10-14-08_12-ia64-sync-struct-siginfo-with-general-version arch/ia64/include/uapi/asm/siginfo.h
--- a/arch/ia64/include/uapi/asm/siginfo.h~2014-10-14-08_12-ia64-sync-struct-siginfo-with-general-version	2014-11-12 08:49:24.584830328 -0800
+++ b/arch/ia64/include/uapi/asm/siginfo.h	2014-11-12 08:49:24.587830463 -0800
@@ -63,6 +63,10 @@ typedef struct siginfo {
 			unsigned int _flags;	/* see below */
 			unsigned long _isr;	/* isr */
 			short _addr_lsb;	/* lsb of faulting address */
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL */
@@ -110,9 +114,9 @@ typedef struct siginfo {
 /*
  * SIGSEGV si_codes
  */
-#define __SEGV_PSTKOVF	(__SI_FAULT|3)	/* paragraph stack overflow */
+#define __SEGV_PSTKOVF	(__SI_FAULT|4)	/* paragraph stack overflow */
 #undef NSIGSEGV
-#define NSIGSEGV	3
+#define NSIGSEGV	4
 
 #undef NSIGTRAP
 #define NSIGTRAP	4
_
