Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaBVR6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:58:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaBVR6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:58:14 -0500
Date: Sat, 22 Feb 2014 09:57:55 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1cf0382af98f6365b01b59453fe18dffe3c73d2f@git.kernel.org>
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
In-Reply-To: <1389098853-14466-8-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Do not report zero address in unwind
Git-Commit-ID: 1cf0382af98f6365b01b59453fe18dffe3c73d2f
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

Commit-ID:  1cf0382af98f6365b01b59453fe18dffe3c73d2f
Gitweb:     http://git.kernel.org/tip/1cf0382af98f6365b01b59453fe18dffe3c73d2f
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:24 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:48 -0300

perf callchain: Do not report zero address in unwind

We are not interested in zero addresses in callchain, do not report
them.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/unwind.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index bff3209..3b70181 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -563,7 +563,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		unw_word_t ip;
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
-		ret = entry(ip, ui->thread, ui->machine, cb, arg);
+		ret = ip ? entry(ip, ui->thread, ui->machine, cb, arg) : 0;
 	}
 
 	unw_destroy_addr_space(addr_space);
