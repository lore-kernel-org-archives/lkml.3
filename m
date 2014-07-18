Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbaGREZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:25:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091AbaGREY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:24:58 -0400
Date: Thu, 17 Jul 2014 21:24:06 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a2f3b6bf0adadcb5f9383c60aa1355e0f9cba3da@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-10-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-10-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fix missing GNU IFUNC symbols
Git-Commit-ID: a2f3b6bf0adadcb5f9383c60aa1355e0f9cba3da
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

Commit-ID:  a2f3b6bf0adadcb5f9383c60aa1355e0f9cba3da
Gitweb:     http://git.kernel.org/tip/a2f3b6bf0adadcb5f9383c60aa1355e0f9cba3da
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:33 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:34 -0300

perf symbols: Fix missing GNU IFUNC symbols

Symbols of type STT_GNU_IFUNC are functions so accept them as such.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-10-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 6864661..dce5ccf 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -49,7 +49,8 @@ static inline uint8_t elf_sym__type(const GElf_Sym *sym)
 
 static inline int elf_sym__is_function(const GElf_Sym *sym)
 {
-	return elf_sym__type(sym) == STT_FUNC &&
+	return (elf_sym__type(sym) == STT_FUNC ||
+		elf_sym__type(sym) == STT_GNU_IFUNC) &&
 	       sym->st_name != 0 &&
 	       sym->st_shndx != SHN_UNDEF;
 }
