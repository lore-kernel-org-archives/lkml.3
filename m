Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3AYLrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:47:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3AYLrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:47:20 -0500
Date: Fri, 25 Jan 2013 03:47:03 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-164c800e42657e586f6fd446b3d8d41cf1f815f1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1358185607-90799-1-git-send-email-dsahern@gmail.com>
References: <1358185607-90799-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Move name malloc to when needed in dso__load
Git-Commit-ID: 164c800e42657e586f6fd446b3d8d41cf1f815f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:47:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  164c800e42657e586f6fd446b3d8d41cf1f815f1
Gitweb:     http://git.kernel.org/tip/164c800e42657e586f6fd446b3d8d41cf1f815f1
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 14 Jan 2013 10:46:47 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:30 -0300

perf symbols: Move name malloc to when needed in dso__load

Memory is currently leaked on some paths.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1358185607-90799-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2960284..daf9554 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -768,10 +768,6 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	else
 		machine = NULL;
 
-	name = malloc(PATH_MAX);
-	if (!name)
-		return -1;
-
 	dso->adjust_symbols = 0;
 
 	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
@@ -795,6 +791,10 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (machine)
 		root_dir = machine->root_dir;
 
+	name = malloc(PATH_MAX);
+	if (!name)
+		return -1;
+
 	/* Iterate over candidate debug images.
 	 * Keep track of "interesting" ones (those which have a symtab, dynsym,
 	 * and/or opd section) for processing.
