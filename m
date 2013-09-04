Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614Ab3IDBVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:21:32 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51211 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3IDBVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:21:31 -0400
From: Yanchuan Nian <ycnian@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        pavel@suse.cz, tglx@linutronix.de, Yanchuan Nian <ycnian@gmail.com>
Subject: [PATCH] x86/irq: correct comment about i8259 initialization
Date: Wed,  4 Sep 2013 09:25:24 +0800
Message-Id: <1378257924-29446-1-git-send-email-ycnian@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanchuan Nian <ycnian@gmail.com>

0x30-0x3f have been used for ISA interrupts on i386 since 5 years ago,
but some comments about i8259 initialization were missed to update
at the same time.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 arch/x86/kernel/i8259.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 9a5c460..2e977b5 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -312,8 +312,7 @@ static void init_8259A(int auto_eoi)
 	 */
 	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
 
-	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
-	   to 0x20-0x27 on i386 */
+	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
 	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
 
 	/* 8259A-1 (the master) has a slave on IR2 */
-- 
1.8.1.4

