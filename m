Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbaFNVhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:37:23 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:17740 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbaFNVhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:37:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswIANi/nFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZkkgQMXdYRgI4EaN4hGAc9FF4VjiRMdhC0EmkOLMIgogX6BRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/1] arch/x86/mm/init_64.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Date: Sat, 14 Jun 2014 23:37:30 +0200
Message-Id: <1402781850-9675-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/mm/init_64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df1a992..0489b55 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -814,8 +814,7 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
 		if (phys_addr < (phys_addr_t)0x40000000)
 			return;
 
-		if (IS_ALIGNED(addr, PAGE_SIZE) &&
-		    IS_ALIGNED(next, PAGE_SIZE)) {
+		if (PAGE_ALIGNED(addr) && PAGE_ALIGNED(next)) {
 			/*
 			 * Do not free direct mapping pages since they were
 			 * freed when offlining, or simplely not in use.
-- 
1.8.4.5

