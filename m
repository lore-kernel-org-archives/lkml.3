Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaIQV1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:27:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:58150 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbaIQVZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:28 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, John Spencer <maillist-linux@barfooze.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/20] perf tools: Fix GNU-only grep usage in Makefile
Date: Wed, 17 Sep 2014 18:24:16 -0300
Message-Id: <1410989063-14207-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Spencer <maillist-linux@barfooze.de>

This makes it work with non-GNU grep's as well.

Signed-off-by: John Spencer <maillist-linux@barfooze.de>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://thread.gmane.org/gmane.linux.kernel.perf.user/1686
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 4d985e0f03f5..7076a62d0ff7 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -132,7 +132,7 @@ endef
 #
 # Usage: bool-value = $(call is-absolute,path)
 #
-is-absolute = $(shell echo $(shell-sq) | grep ^/ -q && echo y)
+is-absolute = $(shell echo $(shell-sq) | grep -q ^/ && echo y)
 
 # lookup
 #
-- 
1.9.3

