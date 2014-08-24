Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaHXO47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbaHXO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:56 -0400
Date: Sun, 24 Aug 2014 07:56:44 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-700be564308bcfc217bd3515d634b56f0c3c1bbb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jmario@redhat.com, jolsa@redhat.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jmario@redhat.com,
        jolsa@redhat.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1408501874-244377-1-git-send-email-dzickus@redhat.com>
References: <1408501874-244377-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Don't try to find DSOs in SYSV maps
Git-Commit-ID: 700be564308bcfc217bd3515d634b56f0c3c1bbb
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

Commit-ID:  700be564308bcfc217bd3515d634b56f0c3c1bbb
Gitweb:     http://git.kernel.org/tip/700be564308bcfc217bd3515d634b56f0c3c1bbb
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 19 Aug 2014 22:31:14 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 20 Aug 2014 08:26:09 -0300

perf symbols: Don't try to find DSOs in SYSV maps

We are seeing a lot of the following with regards to SYSV memory

Failed to open /SYSV0000279c, continuing without symbols

We don't believe this memory will have DSO info, so treat it like the
heap and stack for now and skip it to prevent the warning.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Joe Mario <jmario@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408501874-244377-1-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 31b8905..b709059 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -31,6 +31,7 @@ static inline int is_anon_memory(const char *filename)
 static inline int is_no_dso_memory(const char *filename)
 {
 	return !strncmp(filename, "[stack", 6) ||
+	       !strncmp(filename, "/SYSV",5)   ||
 	       !strcmp(filename, "[heap]");
 }
 
