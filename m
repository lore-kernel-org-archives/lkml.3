Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaAIOEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:04:02 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58928 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaAIOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:01:21 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/8] tools include: Include <linux/compiler.h> from asm/bug.h
Date: Thu,  9 Jan 2014 23:00:55 +0900
Message-Id: <1389276059-8829-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it uses unlikely() macro inside WARN()

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/include/asm/bug.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/asm/bug.h b/tools/include/asm/bug.h
index eca78df7b8f2..9e5f4846967f 100644
--- a/tools/include/asm/bug.h
+++ b/tools/include/asm/bug.h
@@ -1,6 +1,8 @@
 #ifndef _TOOLS_ASM_BUG_H
 #define _TOOLS_ASM_BUG_H
 
+#include <linux/compiler.h>
+
 #define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
 
 #define WARN(condition, format...) ({		\
-- 
1.7.9.2

