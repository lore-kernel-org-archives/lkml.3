Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaDNOxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:53:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46570 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaDNOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:53:03 -0400
Date: Mon, 14 Apr 2014 07:52:47 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-2c529e4e6aab405aa52e8627cbd691ed28b56a0b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, jean.pihet@linaro.org, jolsa@redhat.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, jean.pihet@linaro.org, jolsa@redhat.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1395873845-466-1-git-send-email-artagnon@gmail.com>
References: <1395873845-466-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Pick up libdw without explicit LIBDW_DIR
Git-Commit-ID: 2c529e4e6aab405aa52e8627cbd691ed28b56a0b
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

Commit-ID:  2c529e4e6aab405aa52e8627cbd691ed28b56a0b
Gitweb:     http://git.kernel.org/tip/2c529e4e6aab405aa52e8627cbd691ed28b56a0b
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Wed, 26 Mar 2014 18:44:05 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:17 +0200

perf tools: Pick up libdw without explicit LIBDW_DIR

The Makefile logic sets FEATURE_CHECKS_CFLAGS-libdw-dwarf-unwind and
FEATURE_CHECKS_LDFLAGS-libdw-dwarf-unwind only if LIBDW_DIR is
defined. This means that under a normal setup,

  $ make NO_LIBUNWIND=1

won't automatically pick up libdw. Fix this.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395873845-466-1-git-send-email-artagnon@gmail.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/config/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5a3c452..ee21fa9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -65,10 +65,9 @@ ifndef NO_LIBELF
   ifdef LIBDW_DIR
     LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
     LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-
-    FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
-    FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
   endif
+  FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
+  FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
 endif
 
 # include ARCH specific config
