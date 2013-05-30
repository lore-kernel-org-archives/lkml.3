Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066Ab3E3QDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:03:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50880 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934469Ab3E3QCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 54/66] tools lib lk: Respect CROSS_COMPILE
Date: Thu, 30 May 2013 19:01:27 +0300
Message-Id: <1369929699-8724-55-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

Make lk use CROSS_COMPILE, in order to be able to cross compile perf
again.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1368822464-4887-1-git-send-email-rabin@rab.in
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 926cbf3..2c5a197 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -1,5 +1,8 @@
 include ../../scripts/Makefile.include
 
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
-- 
1.8.1.4

