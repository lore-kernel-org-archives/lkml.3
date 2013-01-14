Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3ANQu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:50:59 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48348 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3ANQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:50:58 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf: dso_load - move name malloc to when needed
Date: Mon, 14 Jan 2013 09:50:50 -0700
Message-Id: <1358182250-89669-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory is currently leaked on some paths.
---
 tools/perf/util/symbol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 61edfd0..e9c0c3a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -775,10 +775,6 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	else
 		machine = NULL;
 
-	name = malloc(PATH_MAX);
-	if (!name)
-		return -1;
-
 	dso->adjust_symbols = 0;
 
 	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
@@ -802,6 +798,10 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (machine)
 		root_dir = machine->root_dir;
 
+	name = malloc(PATH_MAX);
+	if (!name)
+		return -1;
+
 	/* Iterate over candidate debug images.
 	 * Keep track of "interesting" ones (those which have a symtab, dynsym,
 	 * and/or opd section) for processing.
-- 
1.7.10.1

