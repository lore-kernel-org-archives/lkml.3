Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3DVO3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51431 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab3DVO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Woodhouse" <David.Woodhouse@intel.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.966815666@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [68/75] mtd: Disable mtdchar mmap on MMU systems
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

commit f5cf8f07423b2677cebebcebc863af77223a4972 upstream.

This code was broken because it assumed that all MTD devices were map-based.
Disable it for now, until it can be fixed properly for the next merge window.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/mtdchar.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1154,7 +1154,11 @@ static int mtd_mmap(struct file *file, s
 	unsigned long off;
 	u32 len;
 
-	if (mtd->type == MTD_RAM || mtd->type == MTD_ROM) {
+        /* This is broken because it assumes the MTD device is map-based
+	   and that mtd->priv is a valid struct map_info.  It should be
+	   replaced with something that uses the mtd_get_unmapped_area()
+	   operation properly. */
+	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
 		off = vma->vm_pgoff << PAGE_SHIFT;
 		start = map->phys;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);

