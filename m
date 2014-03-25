Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaCYUqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:46:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbaCYUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:46:34 -0400
Date: Tue, 25 Mar 2014 13:45:36 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-psizrnant8x3nrhbgvq2vekr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Actually discard the .discard sections
Git-Commit-ID: 26f5ef2e3c3c18f1dc31461ddf1db00b014edcd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26f5ef2e3c3c18f1dc31461ddf1db00b014edcd4
Gitweb:     http://git.kernel.org/tip/26f5ef2e3c3c18f1dc31461ddf1db00b014edcd4
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 25 Mar 2014 13:41:36 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Mar 2014 13:41:36 -0700

x86, vdso: Actually discard the .discard sections

The .discard/.discard.* sections are used to generate intermediate
results for the assembler (effectively "test assembly".)  The output
is waste and should not be retained.

Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-psizrnant8x3nrhbgvq2vekr@git.kernel.org
---
 arch/x86/vdso/vdso-layout.lds.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index c6d0e1b..2e263f3 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -62,6 +62,11 @@ SECTIONS
 	. = ALIGN(0x100);
 
 	.text		: { *(.text*) }			:text	=0x90909090
+
+	/DISCARD/ : {
+		*(.discard)
+		*(.discard.*)
+	}
 }
 
 /*
