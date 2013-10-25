Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab3JYOiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:38:16 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:54240 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3JYOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:38:15 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] openrisc: Refactor 16-bit constant relocation
Date: Fri, 25 Oct 2013 16:37:56 +0200
Message-Id: <1382711876-21439-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/openrisc/kernel/module.c: In function 'apply_relocate_add':
arch/openrisc/kernel/module.c:50:13: warning: assignment from incompatible pointer type
arch/openrisc/kernel/module.c:54:13: warning: assignment from incompatible pointer type

Move the pointer increments to the dereference statements to avoid
incompatible pointer assignments, and remove superfluous casts.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Assembler output is identical before and after patch

 arch/openrisc/kernel/module.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
index 10ff50f0202a..ef872ae4c878 100644
--- a/arch/openrisc/kernel/module.c
+++ b/arch/openrisc/kernel/module.c
@@ -47,12 +47,10 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			*location = value;
 			break;
 		case R_OR32_CONST:
-			location = (uint16_t *)location + 1;
-			*((uint16_t *)location) = (uint16_t) (value);
+			*((uint16_t *)location + 1) = value;
 			break;
 		case R_OR32_CONSTH:
-			location = (uint16_t *)location + 1;
-			*((uint16_t *)location) = (uint16_t) (value >> 16);
+			*((uint16_t *)location + 1) = value >> 16;
 			break;
 		case R_OR32_JUMPTARG:
 			value -= (uint32_t)location;
-- 
1.7.9.5

