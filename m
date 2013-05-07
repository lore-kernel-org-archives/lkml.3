Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab3EGJbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:31:47 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:55951 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378Ab3EGJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:31:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] frv: head.S - Remove commented-out initialization code
Date: Tue,  7 May 2013 11:31:40 +0200
Message-Id: <1367919100-7744-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commented-out calls to processor_init() and unit_init() seem to have
been copied from mn10300, when starting the frv port. Remove them.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/frv/kernel/head.S |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/frv/kernel/head.S b/arch/frv/kernel/head.S
index e9a8cc6..a7d0bea 100644
--- a/arch/frv/kernel/head.S
+++ b/arch/frv/kernel/head.S
@@ -479,11 +479,6 @@ __head_mmu_enabled:
 
 	LEDS		0x000c
 
-	# initialise the processor and the peripherals
-	#call		SYMBOL_NAME(processor_init)
-	#call		SYMBOL_NAME(unit_init)
-	#LEDS		0x0aff
-
 	sethi.p		#0xe5e5,gr3
 	setlo		#0xe5e5,gr3
 	or.p		gr3,gr0,gr4
-- 
1.7.0.4

