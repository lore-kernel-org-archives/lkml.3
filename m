Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387Ab3GCTVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:21:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113Ab3GCSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:46 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=wUY6OGqaqooA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vSCc3Pc3MxkA:10 a=69EAbJreAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=EfJqPEOeqlMA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184044.808116726@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:38:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Binderman <dcb314@hotmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>, <stable@kernel.org>
Subject: [001/141] avr32: fix relocation check for signed 18-bit offset
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0001-avr32-fix-relocation-check-for-signed-18-bit-offset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hans-Christian Egtvedt <egtvedt@samfundet.no>

[ Upstream commit e68c636d88db3fda74e664ecb1a213ae0d50a7d8 ]

Caught by static code analysis by David.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/avr32/kernel/module.c |    2 +-
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
1.7.10.4


