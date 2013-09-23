Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3IWBpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:45:19 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50226 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3IWBpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:45:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/5] perf tool: Explicitly add libdl dependency
Date: Sun, 22 Sep 2013 19:44:57 -0600
Message-Id: <1379900700-5186-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compile failure on Fedora 12.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/config/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6850529..85fc870 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -87,7 +87,7 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
-EXTLIBS = -lelf -lpthread -lrt -lm
+EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
-- 
1.7.10.1

