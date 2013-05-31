Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3EaIsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:48:36 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48338 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3EaIsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:19 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 06/16] perf, persistent: Return -EACCES if mapped buffers must be readonly
Date: Fri, 31 May 2013 10:47:26 +0200
Message-Id: <1369990056-10310-7-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

mmap should return EACCES error if fd can not be opened writable.
This error code also helps userland to map buffers readonly on
failure.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0730f36..a9b6470 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3761,7 +3761,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	if (event->attr.persistent && (vma->vm_flags & VM_WRITE))
-		return -EINVAL;
+		return -EACCES;
 
 	vma_size = vma->vm_end - vma->vm_start;
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
-- 
1.8.1.1

