Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3IYSbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:31:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41547 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3IYSb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:31:26 -0400
Date: Wed, 25 Sep 2013 11:31:12 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-6d19912c9bc0ae0ba5f7dd32c714ea7cc3339c81@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1379900700-5186-3-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Explicitly add libdl dependency
Git-Commit-ID: 6d19912c9bc0ae0ba5f7dd32c714ea7cc3339c81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 11:31:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d19912c9bc0ae0ba5f7dd32c714ea7cc3339c81
Gitweb:     http://git.kernel.org/tip/6d19912c9bc0ae0ba5f7dd32c714ea7cc3339c81
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 22 Sep 2013 19:44:57 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Sep 2013 12:39:27 -0300

perf tools: Explicitly add libdl dependency

Fixes compile failure on Fedora 12.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 346ee92..5f6f9b3 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -87,7 +87,7 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
-EXTLIBS = -lelf -lpthread -lrt -lm
+EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
