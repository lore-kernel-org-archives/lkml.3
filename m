Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3CUKyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:54:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3CUKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:53:58 -0400
Date: Thu, 21 Mar 2013 03:51:45 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-9e4a66482e9a96405eb9ee7f7bf28c9799ca8670@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1361374353-30385-4-git-send-email-bp@alien8.de>
References: <1361374353-30385-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Correct Makefile.include
Git-Commit-ID: 9e4a66482e9a96405eb9ee7f7bf28c9799ca8670
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:51:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e4a66482e9a96405eb9ee7f7bf28c9799ca8670
Gitweb:     http://git.kernel.org/tip/9e4a66482e9a96405eb9ee7f7bf28c9799ca8670
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Feb 2013 16:32:29 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:05:59 -0300

perf tools: Correct Makefile.include

It looks at O= and adjusts the $(OUTPUT) variable based on what the
output directory will be. However, when O is defined but empty, it
wrongly becomes the user's $HOME dir which is not what we want. So check
it is not empty before working with it further.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-4-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/scripts/Makefile.include | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 00a05f4..f03e681 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,3 +1,4 @@
+ifneq ($(O),)
 ifeq ($(origin O), command line)
 	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
 	ABSOLUTE_O := $(shell cd $(O) ; pwd)
@@ -7,9 +8,10 @@ ifeq ($(objtree),)
 	objtree := $(O)
 endif
 endif
+endif
 
-ifneq ($(OUTPUT),)
 # check that the output directory actually exists
+ifneq ($(OUTPUT),)
 OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
 $(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
 endif
