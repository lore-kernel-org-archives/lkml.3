Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaL3STN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 13:19:13 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:48933 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaL3STL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 13:19:11 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH v3] x86/boot/early_serial_console: Remove unnecessary check
Date: Wed, 31 Dec 2014 00:18:58 +0600
Message-Id: <1419963538-19275-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already the same check before.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/early_serial_console.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 5df2869..c23bcae 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -73,9 +73,8 @@ static void parse_earlyprintk(void)
 		} else if (!strncmp(arg + pos, "ttyS", 4)) {
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
-
-			if (!strncmp(arg + pos, "ttyS", 4))
-				pos += 4;
+			/* += strlen("ttyS"); */
+			pos += 4;
 
 			if (arg[pos++] == '1')
 				idx = 1;
-- 
2.2.1.202.g44ae4ee.dirty

