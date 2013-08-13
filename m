Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab3HMSNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:13:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55718 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab3HMSNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:13:43 -0400
From: Fred Chen <fchen@linux.vnet.ibm.com>
To: x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Fred Chen <fchen@linux.vnet.ibm.com>
Subject: [PATCH] strlen patch
Date: Tue, 13 Aug 2013 11:13:00 -0700
Message-Id: <1376417580-11554-1-git-send-email-fchen@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081318-7182-0000-0000-00000812AB5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch that fixes sparse error "arch/x86/boot/string.c:119:8: warning: symbol 'strlen' was not declared." by declaring it in arch/x86/boot/boot.h.

Signed-off-by: Fred Chen <fchen@linux.vnet.ibm.com>
---
 arch/x86/boot/boot.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
-- 
1.7.1

