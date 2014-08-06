Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaHFLei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:34:38 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:56932 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbaHFLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:34:37 -0400
From: Thierry FAUCK - IBM LTC <thierry@linux.vnet.ibm.com>
To: avagin@openvz.org
Cc: paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Thierry Fauck <thierry@linux.vnet.ibm.com>
Subject: [PATCH] Some systems have a dynamic PAGE_SIZE value and do not add a definition for PAGE_SIZE. This value will have to be retrieved using getpagesize() or sysconf().
Date: Wed,  6 Aug 2014 13:34:26 +0200
Message-Id: <1407324866-3548-1-git-send-email-thierry@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080611-8372-0000-0000-000000C10C5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Fauck <thierry@linux.vnet.ibm.com>

Signed-off-by: Thierry Fauck <thierry@linux.vnet.ibm.com>
---
 tools/testing/selftests/ptrace/peeksiginfo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/ptrace/peeksiginfo.c b/tools/testing/selftests/ptrace/peeksiginfo.c
index d46558b..c34cd8a 100644
--- a/tools/testing/selftests/ptrace/peeksiginfo.c
+++ b/tools/testing/selftests/ptrace/peeksiginfo.c
@@ -31,6 +31,10 @@ static int sys_ptrace(int request, pid_t pid, void *addr, void *data)
 #define TEST_SICODE_PRIV	-1
 #define TEST_SICODE_SHARE	-2
 
+#ifndef PAGE_SIZE
+#define PAGE_SIZE sysconf(_SC_PAGESIZE)
+#endif
+
 #define err(fmt, ...)						\
 		fprintf(stderr,					\
 			"Error (%s:%d): " fmt,			\
-- 
2.0.0

