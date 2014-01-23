Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaAWREz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:04:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaAWREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:04:52 -0500
Date: Thu, 23 Jan 2014 09:04:08 -0800
From: tip-bot for Alan Cox <tipbot@zytor.com>
Message-ID: <tip-g2uoiwbrpiimb63rx32qv8ne@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, alan@linux.intel.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        gnomes@lxorguk.ukuu.org.uk, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        gnomes@lxorguk.ukuu.org.uk, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Ensure sscanf does not overrun the 
 "mem" field
Git-Commit-ID: a761a2d8a7175b7b4e8525e0672e1a8d3c051001
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:04:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a761a2d8a7175b7b4e8525e0672e1a8d3c051001
Gitweb:     http://git.kernel.org/tip/a761a2d8a7175b7b4e8525e0672e1a8d3c051001
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Mon, 20 Jan 2014 19:10:11 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Jan 2014 16:19:08 -0300

perf tools: Ensure sscanf does not overrun the "mem" field

Make the parsing robust.

(perf has some other assumptions that BUFSIZE <= MAX_PATH which are
 not touched here)

Reported-by: Jackie Chang
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-g2uoiwbrpiimb63rx32qv8ne@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bb3e0ed..893f8e2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -930,7 +930,7 @@ static int write_topo_node(int fd, int node)
 		/* skip over invalid lines */
 		if (!strchr(buf, ':'))
 			continue;
-		if (sscanf(buf, "%*s %*d %s %"PRIu64, field, &mem) != 2)
+		if (sscanf(buf, "%*s %*d %31s %"PRIu64, field, &mem) != 2)
 			goto done;
 		if (!strcmp(field, "MemTotal:"))
 			mem_total = mem;
