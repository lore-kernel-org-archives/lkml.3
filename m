Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaJ1LMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:12:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbaJ1LMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:12:50 -0400
Date: Tue, 28 Oct 2014 04:12:31 -0700
From: tip-bot for Steven Noonan <tipbot@zytor.com>
Message-ID: <tip-5631b8fba640a4ab2f8a954f63a603fa34eda96b@git.kernel.org>
Cc: mingo@kernel.org, steven@uplinklabs.net, rostedt@goodmis.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rth@twiddle.net, tglx@linutronix.de,
        jakub@redhat.com
Reply-To: mingo@kernel.org, rostedt@goodmis.org, steven@uplinklabs.net,
        hpa@zytor.com, linux-kernel@vger.kernel.org, rth@twiddle.net,
        tglx@linutronix.de, torvalds@linux-foundation.org, jakub@redhat.com
In-Reply-To: <1414274982-14040-1-git-send-email-steven@uplinklabs.net>
References: <1414274982-14040-1-git-send-email-steven@uplinklabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] compiler/gcc4+:
  Remove inaccurate comment about 'asm goto' miscompiles
Git-Commit-ID: 5631b8fba640a4ab2f8a954f63a603fa34eda96b
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

Commit-ID:  5631b8fba640a4ab2f8a954f63a603fa34eda96b
Gitweb:     http://git.kernel.org/tip/5631b8fba640a4ab2f8a954f63a603fa34eda96b
Author:     Steven Noonan <steven@uplinklabs.net>
AuthorDate: Sat, 25 Oct 2014 15:09:42 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:03:40 +0100

compiler/gcc4+: Remove inaccurate comment about 'asm goto' miscompiles

The bug referenced by the comment in this commit was not
completely fixed in GCC 4.8.2, as I mentioned in a thread back
in February:

   https://lkml.org/lkml/2014/2/12/797

The conclusion at that time was to make the quirk unconditional
until the bug could be found and fixed in GCC. Unfortunately,
when I submitted the patch (commit a9f18034) I left a comment
in that claimed the bug was fixed in GCC 4.8.2+.

This comment is inaccurate, and should be removed.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1414274982-14040-1-git-send-email-steven@uplinklabs.net
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/compiler-gcc4.h | 1 -
 include/linux/compiler-gcc5.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2507fd2..d1a5582 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -71,7 +71,6 @@
  *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
  *
  * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- * Fixed in GCC 4.8.2 and later versions.
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
index cdd1cc2..c8c5659 100644
--- a/include/linux/compiler-gcc5.h
+++ b/include/linux/compiler-gcc5.h
@@ -53,7 +53,6 @@
  *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
  *
  * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- * Fixed in GCC 4.8.2 and later versions.
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
