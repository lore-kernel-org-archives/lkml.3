Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaAHLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:21:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaAHLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:21:26 -0500
From: David Woodhouse <David.Woodhouse@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvmlinux@lists.linuxfoundation.org
Subject: [PATCH 2/4] x86, boot: Use __attribute__((used)) to ensure videocard structs are emitted
Date: Wed,  8 Jan 2014 11:21:21 +0000
Message-Id: <1389180083-23249-2-git-send-email-David.Woodhouse@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like GCC will always emit an object that is marked with an
explicit section, although the documentation doesn't say that and we
possibly shouldn't be relying on it.

Clang does *not* do so, so add __attribute__((used)) to make sure.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/x86/boot/video.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/video.h b/arch/x86/boot/video.h
index ff339c5..0bb2549 100644
--- a/arch/x86/boot/video.h
+++ b/arch/x86/boot/video.h
@@ -80,7 +80,7 @@ struct card_info {
 	u16 xmode_n;		/* Size of unprobed mode range */
 };
 
-#define __videocard struct card_info __attribute__((section(".videocards")))
+#define __videocard struct card_info __attribute__((used,section(".videocards")))
 extern struct card_info video_cards[], video_cards_end[];
 
 int mode_defined(u16 mode);	/* video.c */
-- 
1.8.4.2

