Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbbALQLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:11:45 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49788 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbALQLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:11:42 -0500
X-IronPort-AV: E=Sophos;i="5.07,744,1413244800"; 
   d="scan'208";a="215536334"
From: David Vrabel <david.vrabel@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-mm@kvack.org>,
        "Jenny Herbert" <jennifer.herbert@citrix.com>
Subject: [PATCH 2/2] mm: add 'foreign' alias for the 'pinned' page flag
Date: Mon, 12 Jan 2015 15:53:13 +0000
Message-ID: <1421077993-7909-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421077993-7909-1-git-send-email-david.vrabel@citrix.com>
References: <1421077993-7909-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
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
 include/linux/page-flags.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e1f5fcd..7734cc8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -123,6 +123,7 @@ enum pageflags {
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
 	PG_savepinned = PG_dirty,
+	PG_foreign = PG_owner_priv_1,
 
 	/* SLOB */
 	PG_slob_free = PG_private,
@@ -215,6 +216,7 @@ __PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, checked)		/* Used by some filesystems */
 PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
+PAGEFLAG(Foreign, foreign);				/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 	__SETPAGEFLAG(SwapBacked, swapbacked)
-- 
1.7.10.4

