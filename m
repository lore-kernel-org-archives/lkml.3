Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab3E1Dyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:54:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52520 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758809Ab3E1DyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Binderman" <dcb314@hotmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.680742671@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [32/94] avr32: fix relocation check for signed 18-bit offset
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans-Christian Egtvedt <egtvedt@samfundet.no>

commit e68c636d88db3fda74e664ecb1a213ae0d50a7d8 upstream.

Caught by static code analysis by David.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/avr32/kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/avr32/kernel/module.c
+++ b/arch/avr32/kernel/module.c
@@ -264,7 +264,7 @@ int apply_relocate_add(Elf32_Shdr *sechd
 			break;
 		case R_AVR32_GOT18SW:
 			if ((relocation & 0xfffe0003) != 0
-			    && (relocation & 0xfffc0003) != 0xffff0000)
+			    && (relocation & 0xfffc0000) != 0xfffc0000)
 				return reloc_overflow(module, "R_AVR32_GOT18SW",
 						     relocation);
 			relocation >>= 2;

