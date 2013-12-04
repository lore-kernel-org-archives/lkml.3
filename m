Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3LDQxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:53:10 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:63087 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab3LDQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:53:07 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: hskinnemoen@gmail.com, egtvedt@samfundet.no, linux-kernel@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] avr32: pm: Fix section mismatch
Date: Wed,  4 Dec 2013 17:52:55 +0100
Message-Id: <1386175975-18173-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power management has a section mismatch which leads to the following
warning during compilation:

WARNING: arch/avr32/mach-at32ap/built-in.o(.text+0x16d4): Section
mismatch in reference from the function avr32_pm_offset() to the
function .init.text:pm_exception()
The function avr32_pm_offset() references
the function __init pm_exception().

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/avr32/mach-at32ap/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/mach-at32ap/pm.c b/arch/avr32/mach-at32ap/pm.c
index 32d680e..db19084 100644
--- a/arch/avr32/mach-at32ap/pm.c
+++ b/arch/avr32/mach-at32ap/pm.c
@@ -181,7 +181,7 @@ static const struct platform_suspend_ops avr32_pm_ops = {
 	.enter	= avr32_pm_enter,
 };
 
-static unsigned long avr32_pm_offset(void *symbol)
+static unsigned long __init avr32_pm_offset(void *symbol)
 {
 	extern u8 pm_exception[];
 
-- 
1.8.1.2

