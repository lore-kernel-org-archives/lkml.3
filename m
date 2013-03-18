Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3CRK5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:57:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3CRK5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:57:22 -0400
Date: Mon, 18 Mar 2013 03:56:03 -0700
From: tip-bot for Ananth N Mavinakayanahalli <tipbot@zytor.com>
Message-ID: <tip-79146a69c8bc3f28e51c5267633abc6babf47a31@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        hpa@zytor.com, mingo@kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20130312090217.GC4668@in.ibm.com>
References: <20130312090217.GC4668@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix segfault
Git-Commit-ID: 79146a69c8bc3f28e51c5267633abc6babf47a31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:56:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79146a69c8bc3f28e51c5267633abc6babf47a31
Gitweb:     http://git.kernel.org/tip/79146a69c8bc3f28e51c5267633abc6babf47a31
Author:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
AuthorDate: Tue, 12 Mar 2013 14:32:17 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Mar 2013 17:00:33 -0300

perf probe: Fix segfault

Fix segfault in perf probe due to a bug introduced by commit d8639f068
(perf tools: Stop using 'self' in strlist).

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130312090217.GC4668@in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/strlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 55433aa..eabdce0 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -143,7 +143,7 @@ struct strlist *strlist__new(bool dupstr, const char *list)
 		slist->rblist.node_delete = strlist__node_delete;
 
 		slist->dupstr	 = dupstr;
-		if (slist && strlist__parse_list(slist, list) != 0)
+		if (list && strlist__parse_list(slist, list) != 0)
 			goto out_error;
 	}
 
