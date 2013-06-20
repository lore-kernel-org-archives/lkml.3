Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379Ab3FTLEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:04:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:56546 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291Ab3FTLD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:03:59 -0400
Message-ID: <51C2E116.3030901@huawei.com>
Date: Thu, 20 Jun 2013 19:01:42 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <dhowells@redhat.com>, <ralf@linux-mips.org>, <dhillf@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] proc: kcore: using strlcpy instead of strncpy
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for NUL terminated string, need alway set '\0' in the end.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 fs/proc/kcore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 0a22194..06ea155 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -408,7 +408,7 @@ static void elf_kcore_store_hdr(char *bufp, int nphdr, int dataoff)
 	prpsinfo.pr_zomb	= 0;
 
 	strcpy(prpsinfo.pr_fname, "vmlinux");
-	strncpy(prpsinfo.pr_psargs, saved_command_line, ELF_PRARGSZ);
+	strlcpy(prpsinfo.pr_psargs, saved_command_line, sizeof(prpsinfo.pr_psargs));
 
 	nhdr->p_filesz	+= notesize(&notes[1]);
 	bufp = storenote(&notes[1], bufp);
-- 
1.7.1

