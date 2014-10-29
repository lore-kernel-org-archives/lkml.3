Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbaJ2UOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:14:37 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:4890 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636AbaJ2UOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:14:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQNAOdJUVRbtAu8/2dsb2JhbABcgw6BLLojAQEBAQEBBQF0mk+BHxcBAQEBAX2EXyOBGjeIRQG5NI8ghjaJdmQdhDUFnWqWQIFHAYIxPC+BBoFFAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/1 linux-next] powerpc: fix section mismatch warning
Date: Wed, 29 Oct 2014 21:14:27 +0100
Message-Id: <1414613667-2553-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding __init to MMU_setup() which uses __initdata boot_command_line.

Warning appeared since commit 3e47d1474c2b
("powerpc: Remove powerpc specific cmd_line")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/powerpc/mm/init_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index cad68ff..415a51b 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -103,7 +103,7 @@ unsigned long __max_low_memory = MAX_LOW_MEM;
 /*
  * Check for command-line options that affect what MMU_init will do.
  */
-void MMU_setup(void)
+void __init MMU_setup(void)
 {
 	/* Check for nobats option (used in mapin_ram). */
 	if (strstr(boot_command_line, "nobats")) {
-- 
1.9.3

