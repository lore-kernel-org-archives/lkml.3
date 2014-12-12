Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977AbaLLTMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:12:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:51801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934931AbaLLTMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="653022149"
Subject: [RFC][PATCH 3/8] x86, mpx: we do not allocate the bounds directory
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:17 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191217.ED102A0C@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The comment and code here are confusing.  We do not currently
allocate the bounds directory in the kernel.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/mm/mpx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/mpx.c~x86-mpx-we-do-not-allocate-the-bounds-directory arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~x86-mpx-we-do-not-allocate-the-bounds-directory	2014-12-12 11:11:39.858982368 -0800
+++ b/arch/x86/mm/mpx.c	2014-12-12 11:11:39.861982503 -0800
@@ -47,8 +47,8 @@ static unsigned long mpx_mmap(unsigned l
 	vm_flags_t vm_flags;
 	struct vm_area_struct *vma;
 
-	/* Only bounds table and bounds directory can be allocated here */
-	if (len != MPX_BD_SIZE_BYTES && len != MPX_BT_SIZE_BYTES)
+	/* Only bounds table can be allocated here */
+	if (len != MPX_BT_SIZE_BYTES)
 		return -EINVAL;
 
 	down_write(&mm->mmap_sem);
_
