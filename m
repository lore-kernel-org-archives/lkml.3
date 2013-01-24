Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945890Ab3AXUi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:38:26 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53974
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756Ab3AXUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 50/74] perf symbols: Move name malloc to when needed in dso__load
Date: Thu, 24 Jan 2013 17:07:59 -0300
Message-Id: <1359058103-31645-51-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
-- 
1.8.1.1.361.gec3ae6e

