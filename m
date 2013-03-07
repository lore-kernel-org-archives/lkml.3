Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab3CGEza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:55:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3CGEz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:55:29 -0500
Date: Wed, 6 Mar 2013 20:54:18 -0800
From: tip-bot for Peter Jones <tipbot@zytor.com>
Message-ID: <tip-3c4aff6b9a183b4f24eb7b8dd6c8a92cdba3bc75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pjones@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1362592823-28967-1-git-send-email-pjones@redhat.com>
References: <1362592823-28967-1-git-send-email-pjones@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, doc:
  Be explicit about what the x86 struct boot_params requires
Git-Commit-ID: 3c4aff6b9a183b4f24eb7b8dd6c8a92cdba3bc75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 20:54:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c4aff6b9a183b4f24eb7b8dd6c8a92cdba3bc75
Gitweb:     http://git.kernel.org/tip/3c4aff6b9a183b4f24eb7b8dd6c8a92cdba3bc75
Author:     Peter Jones <pjones@redhat.com>
AuthorDate: Wed, 6 Mar 2013 13:00:23 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Mar 2013 20:34:43 -0800

x86, doc: Be explicit about what the x86 struct boot_params requires

If the sentinel triggers, we do not want the boot loader authors to
just poke it and make the error go away, we want them to actually fix
the problem.

This should help avoid making the incorrect change in non-compliant
bootloaders.

[ hpa: dropped the Documentation/x86/boot.txt hunk pending
  clarifications ]

Signed-off-by: Peter Jones <pjones@redhat.com>
Link: http://lkml.kernel.org/r/1362592823-28967-1-git-send-email-pjones@redhat.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/bootparam_utils.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index ff808ef..653668d 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -19,8 +19,22 @@
  */
 static void sanitize_boot_params(struct boot_params *boot_params)
 {
+	/* 
+	 * IMPORTANT NOTE TO BOOTLOADER AUTHORS: do not simply clear
+	 * this field.  The purpose of this field is to guarantee
+	 * compliance with the x86 boot spec located in
+	 * Documentation/x86/boot.txt .  That spec says that the
+	 * *whole* structure should be cleared, after which only the
+	 * portion defined by struct setup_header (boot_params->hdr)
+	 * should be copied in.
+	 *
+	 * If you're having an issue because the sentinel is set, you
+	 * need to change the whole structure to be cleared, not this
+	 * (or any other) individual field, or you will soon have
+	 * problems again.
+	 */
 	if (boot_params->sentinel) {
-		/*fields in boot_params are not valid, clear them */
+		/* fields in boot_params are left uninitialized, clear them */
 		memset(&boot_params->olpc_ofw_header, 0,
 		       (char *)&boot_params->efi_info -
 			(char *)&boot_params->olpc_ofw_header);
