Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaL3N2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:28:34 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:35393 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaL3N2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:28:33 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH v2] x86/boot/early_serial_console: Remove unnecessary check
Date: Tue, 30 Dec 2014 19:28:22 +0600
Message-Id: <1419946102-17175-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already the same check before.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/early_serial_console.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 5df2869..62abcc8 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -74,8 +74,7 @@ static void parse_earlyprintk(void)
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
 
-			if (!strncmp(arg + pos, "ttyS", 4))
-				pos += 4;
+			pos += 4;
 
 			if (arg[pos++] == '1')
 				idx = 1;
-- 
2.2.1.202.g44ae4ee.dirty

