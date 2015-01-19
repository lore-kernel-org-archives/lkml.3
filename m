Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbbASPrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:47:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:54703 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbASPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:47:42 -0500
X-IronPort-AV: E=Sophos;i="5.09,427,1418083200"; 
   d="scan'208";a="219312190"
From: David Vrabel <david.vrabel@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-mm@kvack.org>,
        "Jenny Herbert" <jennifer.herbert@citrix.com>
Subject: [PATCH 2/2] mm: add 'foreign' alias for the 'pinned' page flag
Date: Mon, 19 Jan 2015 15:47:23 +0000
Message-ID: <1421682443-20509-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421682443-20509-1-git-send-email-david.vrabel@citrix.com>
References: <1421682443-20509-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jenny Herbert <jennifer.herbert@citrix.com>

The foreign page flag will be used by Xen guests to mark pages that
have grant mappings of frames from other (foreign) guests.

The foreign flag is an alias for the existing (Xen-specific) pinned
flag.  This is safe because pinned is only used on pages used for page
tables and these cannot also be foreign.

Signed-off-by: Jenny Herbert <jennifer.herbert@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 include/linux/page-flags.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e1f5fcd..5ed7bda 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -121,8 +121,12 @@ enum pageflags {
 	PG_fscache = PG_private_2,	/* page backed by cache */
 
 	/* XEN */
+	/* Pinned in Xen as a read-only pagetable page. */
 	PG_pinned = PG_owner_priv_1,
+	/* Pinned as part of domain save (see xen_mm_pin_all()). */
 	PG_savepinned = PG_dirty,
+	/* Has a grant mapping of another (foreign) domain's page. */
+	PG_foreign = PG_owner_priv_1,
 
 	/* SLOB */
 	PG_slob_free = PG_private,
@@ -215,6 +219,7 @@ __PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, checked)		/* Used by some filesystems */
 PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
+PAGEFLAG(Foreign, foreign);				/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 	__SETPAGEFLAG(SwapBacked, swapbacked)
-- 
1.7.10.4

