Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3AYLs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:48:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3AYLs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:48:27 -0500
Date: Fri, 25 Jan 2013 03:48:14 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-b7c14a0b6a4e3add92e1527a31cb1826f4799248@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1358185650-90848-1-git-send-email-dsahern@gmail.com>
References: <1358185650-90848-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Mark vmlinux filename as allocated
Git-Commit-ID: b7c14a0b6a4e3add92e1527a31cb1826f4799248
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:48:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7c14a0b6a4e3add92e1527a31cb1826f4799248
Gitweb:     http://git.kernel.org/tip/b7c14a0b6a4e3add92e1527a31cb1826f4799248
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 14 Jan 2013 10:47:30 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:32 -0300

perf symbols: Mark vmlinux filename as allocated

Needs to be marked allocated so memory can be freed when dso is deleted.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1358185650-90848-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index daf9554..e6432d8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -923,8 +923,10 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 	filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
 		err = dso__load_vmlinux(dso, map, filename, filter);
-		if (err > 0)
+		if (err > 0) {
+			dso->lname_alloc = 1;
 			goto out;
+		}
 		free(filename);
 	}
 
@@ -932,6 +934,7 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 		err = dso__load_vmlinux(dso, map, vmlinux_path[i], filter);
 		if (err > 0) {
 			dso__set_long_name(dso, strdup(vmlinux_path[i]));
+			dso->lname_alloc = 1;
 			break;
 		}
 	}
@@ -971,6 +974,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		if (err > 0) {
 			dso__set_long_name(dso,
 					   strdup(symbol_conf.vmlinux_name));
+			dso->lname_alloc = 1;
 			goto out_fixup;
 		}
 		return err;
