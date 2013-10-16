Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3JPCKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:10:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60472 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab3JPCHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:13 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 03/10][v6] tools/perf: silence compiler warnings
Date: Tue, 15 Oct 2013 19:06:35 -0700
Message-Id: <1381889202-16826-4-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-0320-0000-0000-0000015FDBEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uninitialized variables cause warnings which are treated as errors
during build (without WERROR=0).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/srcline.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 10983a9..0477055 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -223,8 +223,8 @@ out:
 
 char *get_srcline(struct dso *dso, unsigned long addr)
 {
-	char *file;
-	unsigned line;
+	char *file = NULL;
+	unsigned line = 0;
 	char *srcline;
 	char *dso_name = dso->long_name;
 	size_t size;
-- 
1.7.9.5

