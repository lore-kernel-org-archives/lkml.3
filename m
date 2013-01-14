Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3ANSQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:16:18 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51973 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab3ANSQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:16:14 -0500
From: Cong Ding <dinggnu@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] x86: boot/compressed/mkpiggy.c: fix resource leakage
Date: Mon, 14 Jan 2013 18:14:55 +0000
Message-Id: <1358187343-15752-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the file should be closed if it goes to error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/x86/boot/compressed/mkpiggy.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 958a641..e29154f 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -58,6 +58,7 @@ int main(int argc, char *argv[])
 
 	if (fread(&olen, sizeof(olen), 1, f) != 1) {
 		perror(argv[1]);
+		fclose(f);
 		return 1;
 	}
 
-- 
1.7.9.5

