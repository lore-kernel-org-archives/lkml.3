Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3EFIn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:43:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49742 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3EFIn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:43:27 -0400
X-AuditID: 9c930197-b7c1fae000001854-71-51876d2d8adf
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new streaming format
Date: Mon,  6 May 2013 17:42:55 +0900
Message-Id: <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LZ4 has been updated with LZ4 Streaming Format specification(v1.3).
lz4demo is replaced by lz4c. lz4c supports both the new streaming and
legacy format with -l option.

This patch makes use of lz4c to support legacy format which is
used for LZ4 De/compression in the linux kernel.

Link: https://code.google.com/p/lz4/source/checkout
Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Chanho Min <chanho.min@lge.com>
---
 scripts/Makefile.lib | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index a0ab6d7..c9bfbb0 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -313,7 +313,7 @@ cmd_lzo = (cat $(filter-out FORCE,$^) | \
 
 quiet_cmd_lz4 = LZ4     $@
 cmd_lz4 = (cat $(filter-out FORCE,$^) | \
-	lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	lz4c -l -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
 
 # U-Boot mkimage
-- 
1.8.1.1

