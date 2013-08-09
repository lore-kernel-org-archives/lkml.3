Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031190Ab3HIVAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:00:14 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:26154 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031162Ab3HIVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:00:08 -0400
Message-ID: <201308092100.r79L07iF011272@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 16:50:36 -0400
Subject: [PATCH] tile: group .hottext* sections properly in vmlinux.lds
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change such sections are grouped with regular text
in the vmlinux image; this change puts them at the front,
which is where the standard Linux includes .text.hot*.
This change should fix a recently-observed bug where a bunch of
symbols were being omitted from the /proc/kallsyms output
because they fell between _etext and _sinittext.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index aab9955..c7ae53d 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -46,6 +46,8 @@ SECTIONS
     KPROBES_TEXT
     IRQENTRY_TEXT
     __fix_text_end = .;   /* tile-cpack won't rearrange before this */
+    ALIGN_FUNCTION();
+    *(.hottext*)
     TEXT_TEXT
     *(.text.*)
     *(.coldtext*)
-- 
1.8.3.1

