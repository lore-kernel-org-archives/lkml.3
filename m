Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaANQjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:39:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52692 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaANQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:39:31 -0500
Date: Tue, 14 Jan 2014 08:39:08 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-14bd6d20fef603060474701967085442b716b6a9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1389098853-14466-3-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Fix id_hdr_size initialization
Git-Commit-ID: 14bd6d20fef603060474701967085442b716b6a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:39:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14bd6d20fef603060474701967085442b716b6a9
Gitweb:     http://git.kernel.org/tip/14bd6d20fef603060474701967085442b716b6a9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:19 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:24 -0300

perf machine: Fix id_hdr_size initialization

The id_hdr_size field was not properly initialized, set it to zero, as
the machine struct may have come from some non zeroing allocation
routine or from the stack without any field being initialized.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a98538d..0130279 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -27,6 +27,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	machine->pid = pid;
 
 	machine->symbol_filter = NULL;
+	machine->id_hdr_size = 0;
 
 	machine->root_dir = strdup(root_dir);
 	if (machine->root_dir == NULL)
