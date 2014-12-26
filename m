Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaLZMXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:23:13 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:43474 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaLZMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:23:11 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86: Remove excess calculations for heap_end_ptr
Date: Fri, 26 Dec 2014 18:22:42 +0600
Message-Id: <1419596562-20679-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g98acd41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

heap_end_ptr default value defined as _end+STACK_SZE-512, but
STACK_SIZE is already 512.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 16ef025..c69b870 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -342,7 +342,7 @@ ramdisk_size:	.long	0		# its size in bytes
 bootsect_kludge:
 		.long	0		# obsolete
 
-heap_end_ptr:	.word	_end+STACK_SIZE-512
+heap_end_ptr:	.word	_end
 					# (Header version 0x0201 or later)
 					# space from here (exclusive) down to
 					# end of setup code can be used by setup
-- 
2.2.1.201.gbbcefff

