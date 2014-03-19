Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbaCSXbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:31:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaCSXbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:31:08 -0400
Date: Wed, 19 Mar 2014 16:30:45 -0700
From: tip-bot for Vivek Goyal <tipbot@zytor.com>
Message-ID: <tip-aad830938ed8ba175d8060751654f78d4115ea0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, vgoyal@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, vgoyal@redhat.com, hpa@linux.intel.com
In-Reply-To: <1395170800-11059-2-git-send-email-vgoyal@redhat.com>
References: <1395170800-11059-2-git-send-email-vgoyal@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot:
  Undef memcmp before providing a new definition
Git-Commit-ID: aad830938ed8ba175d8060751654f78d4115ea0a
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

Commit-ID:  aad830938ed8ba175d8060751654f78d4115ea0a
Gitweb:     http://git.kernel.org/tip/aad830938ed8ba175d8060751654f78d4115ea0a
Author:     Vivek Goyal <vgoyal@redhat.com>
AuthorDate: Tue, 18 Mar 2014 15:26:36 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Mar 2014 15:43:37 -0700

x86, boot: Undef memcmp before providing a new definition

With CONFIG_X86_32=y, string_32.h gets pulled in compressed/string.c by
"misch.h". string_32.h defines a macro to map memcmp to __builtin_memcmp().
And that macro in turn changes the name of memcmp() defined here and
converts it to __builtin_memcmp().

I thought that's not the intention though. We probably want to provide
our own optimized definition of memcmp(). If yes, then undef the memcmp
before we define a new memcmp.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: http://lkml.kernel.org/r/1395170800-11059-2-git-send-email-vgoyal@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/string.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index ffb9c5c..212004e 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,5 +1,7 @@
 #include "misc.h"
 
+/* Avoid intereference from any defines in string_32.h */
+#undef memcmp
 int memcmp(const void *s1, const void *s2, size_t len)
 {
 	u8 diff;
