Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980Ab3IFJbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:31:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:43953 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3IFJbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:31:10 -0400
From: Tom Gundersen <teg@jklm.no>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: simplefb: avoid overflow
Date: Fri,  6 Sep 2013 11:32:13 +0200
Message-Id: <1378459933-367-1-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lfb_size can easily be say 4M, which would make the bitshit overflow and
the test fail.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/sysfb_simplefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 22513e9..fff44a5 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -72,7 +72,7 @@ __init int create_simplefb(const struct screen_info *si,
 	 * the part that is occupied by the framebuffer */
 	len = mode->height * mode->stride;
 	len = PAGE_ALIGN(len);
-	if (len > si->lfb_size << 16) {
+	if (len > ((unsigned long) si->lfb_size) << 16) {
 		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
 		return -EINVAL;
 	}
-- 
1.8.4

