Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3ANRN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:13:58 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55191 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab3ANRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:13:56 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Matt Fleming <matt.fleming@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] x86: tools/relocs.c: fix resource leakage
Date: Mon, 14 Jan 2013 17:13:35 +0000
Message-Id: <1358183628-27784-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the opened file should be closed.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/x86/tools/relocs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 5a1847d..79d67bd 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -814,12 +814,14 @@ int main(int argc, char **argv)
 	read_relocs(fp);
 	if (show_absolute_syms) {
 		print_absolute_symbols();
-		return 0;
+		goto out;
 	}
 	if (show_absolute_relocs) {
 		print_absolute_relocs();
-		return 0;
+		goto out;
 	}
 	emit_relocs(as_text, use_real_mode);
+out:
+	fclose(fp);
 	return 0;
 }
-- 
1.7.9.5

