Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293Ab3GSHyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:54:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35923 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239Ab3GSHyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:54:10 -0400
Date: Fri, 19 Jul 2013 00:53:42 -0700
From: tip-bot for Robert Richter <tipbot@zytor.com>
Message-ID: <tip-ab4ecda5205b56cb3b8b44f2c18ffdefb24313a2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, bp@alien8.de, jolsa@redhat.com,
        robert.richter@linaro.org, tglx@linutronix.de, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, bp@alien8.de, jolsa@redhat.com,
        robert.richter@linaro.org, tglx@linutronix.de, rric@kernel.org
In-Reply-To: <20130716145036.GH8731@rric.localhost>
References: <20130716145036.GH8731@rric.localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix 'make tools/perf'
Git-Commit-ID: ab4ecda5205b56cb3b8b44f2c18ffdefb24313a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:53:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab4ecda5205b56cb3b8b44f2c18ffdefb24313a2
Gitweb:     http://git.kernel.org/tip/ab4ecda5205b56cb3b8b44f2c18ffdefb24313a2
Author:     Robert Richter <rric@kernel.org>
AuthorDate: Tue, 16 Jul 2013 16:50:36 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Jul 2013 10:40:02 -0300

perf tools: Fix 'make tools/perf'

Boris just raised another variant of building perf tools which is
broken:

 $ make tools/perf
 ...
     LINK /home/robert/cx/linux/tools/perf/perf
 gcc: error: ../linux/tools/lib/lk/liblk.a: No such file or directory

The variant wasn't considered by:

 107de37 perf tools: Fix build errors with O and DESTDIR make vars set

There are other variant of building perf too:

 $ make -C tools perf
 $ make -C tools/perf

Plus variants with O= and DESTDIR set.

This patch fixes the above and was tested with the following:

 $ make O=... DESTDIR=... tools/perf
 $ make O=... DESTDIR=... -C tools/ perf
 $ make O=... DESTDIR=... -C tools/perf
 $ make tools/perf
 $ make -C tools/ perf
 $ make -C tools/perf

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org
Link: http://lkml.kernel.org/r/20130716145036.GH8731@rric.localhost
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5b7c6db..2a69026 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -124,7 +124,7 @@ strip-libs = $(filter-out -l%,$(1))
 ifneq ($(OUTPUT),)
   TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-  LK_PATH=$(objtree)/lib/lk/
+  LK_PATH=$(OUTPUT)/../lib/lk/
 else
   LK_PATH=$(OUTPUT)
 endif
