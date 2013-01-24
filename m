Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3AXUfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:35:14 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54047
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839Ab3AXUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/74] perf tools: Fix possible (unlikely) buffer overflow
Date: Thu, 24 Jan 2013 17:07:45 -0300
Message-Id: <1359058103-31645-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

cppcheck reported:
[tools/perf/util/sysfs.c:50]: (error) Width 4096 given in format string
(no. 1) is larger than destination buffer 'sysfs_mountpoint[4096]',
use %4095s to prevent overflowing it

-> All other places in the kernel that use STR(PATH_MAX)
   have a buffer size of PATH_MAX + 1.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/50D9D30B.8090002@intra2net.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sysfs.c b/tools/perf/util/sysfs.c
index 48c6902..f71e9ea 100644
--- a/tools/perf/util/sysfs.c
+++ b/tools/perf/util/sysfs.c
@@ -8,7 +8,7 @@ static const char * const sysfs_known_mountpoints[] = {
 };
 
 static int sysfs_found;
-char sysfs_mountpoint[PATH_MAX];
+char sysfs_mountpoint[PATH_MAX + 1];
 
 static int sysfs_valid_mountpoint(const char *sysfs)
 {
-- 
1.8.1.1.361.gec3ae6e

