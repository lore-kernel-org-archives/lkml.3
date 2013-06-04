Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3FDWk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:40:56 -0400
Received: from 1wt.eu ([62.212.114.60]:35100 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3FDWka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:30 -0400
Message-Id: <20130604172130.347309124@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 001/184] Revert "pcdp: use early_ioremap/early_iounmap to
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 access pcdp table"

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 2af3af56e7d4756b21a2e0d86e4fc4e5b7f0df24, which was
commit 6c4088ac3a4d82779903433bcd5f048c58fb1aca upstream.

This broke compilation of the driver in 2.6.32.y as the
early_io{remap,unmap}() functions are not defined for ia64.  The driver
can *only* be built for ia64 (even in current mainline), so a fix for
x86_64 is pointless.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/firmware/pcdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/pcdp.c b/drivers/firmware/pcdp.c
index a330492..51e0e2d 100644
--- a/drivers/firmware/pcdp.c
+++ b/drivers/firmware/pcdp.c
@@ -95,7 +95,7 @@ efi_setup_pcdp_console(char *cmdline)
 	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	pcdp = early_ioremap(efi.hcdp, 4096);
+	pcdp = ioremap(efi.hcdp, 4096);
 	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi.hcdp);
 
 	if (strstr(cmdline, "console=hcdp")) {
@@ -131,6 +131,6 @@ efi_setup_pcdp_console(char *cmdline)
 	}
 
 out:
-	early_iounmap(pcdp, 4096);
+	iounmap(pcdp);
 	return rc;
 }
-- 
1.7.12.2.21.g234cd45.dirty



