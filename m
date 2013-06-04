Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3FDQ5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:57:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48226 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3FDQ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 08/75] avr32: fix relocation check for signed 18-bit offset
Date: Tue,  4 Jun 2013 09:54:52 -0700
Message-Id: <1370364959-9475-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans-Christian Egtvedt <egtvedt@samfundet.no>

commit e68c636d88db3fda74e664ecb1a213ae0d50a7d8 upstream.

Caught by static code analysis by David.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/avr32/kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/kernel/module.c b/arch/avr32/kernel/module.c
index 596f730..2c94129 100644
--- a/arch/avr32/kernel/module.c
+++ b/arch/avr32/kernel/module.c
@@ -264,7 +264,7 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
 			break;
 		case R_AVR32_GOT18SW:
 			if ((relocation & 0xfffe0003) != 0
-			    && (relocation & 0xfffc0003) != 0xffff0000)
+			    && (relocation & 0xfffc0000) != 0xfffc0000)
 				return reloc_overflow(module, "R_AVR32_GOT18SW",
 						     relocation);
 			relocation >>= 2;
-- 
1.8.1.2

