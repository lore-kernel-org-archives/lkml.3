Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3HMSbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:31:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35445 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3HMSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:31:10 -0400
Date: Tue, 13 Aug 2013 11:30:55 -0700
From: tip-bot for Fred Chen <tipbot@zytor.com>
Message-ID: <tip-062fe8fe511e7f771ef1dc824eaf996ba50a694b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, fchen@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, fchen@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1376417580-11554-1-git-send-email-fchen@linux.vnet.ibm.com>
References: <1376417580-11554-1-git-send-email-fchen@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, boot:
  Fix warning due to undeclared strlen()
Git-Commit-ID: 062fe8fe511e7f771ef1dc824eaf996ba50a694b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 13 Aug 2013 11:31:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  062fe8fe511e7f771ef1dc824eaf996ba50a694b
Gitweb:     http://git.kernel.org/tip/062fe8fe511e7f771ef1dc824eaf996ba50a694b
Author:     Fred Chen <fchen@linux.vnet.ibm.com>
AuthorDate: Tue, 13 Aug 2013 11:13:00 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Aug 2013 11:27:39 -0700

x86, boot: Fix warning due to undeclared strlen()

Below is a patch that fixes sparse error
"arch/x86/boot/string.c:119:8: warning: symbol 'strlen' was not
declared." by declaring it in arch/x86/boot/boot.h.

Signed-off-by: Fred Chen <fchen@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1376417580-11554-1-git-send-email-fchen@linux.vnet.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/boot.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 5b75319..ef72bae 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -355,6 +355,7 @@ int strncmp(const char *cs, const char *ct, size_t count);
 size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
+size_t strlen(const char *s);
 
 /* tty.c */
 void puts(const char *);
