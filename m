Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbbA0KBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:01:33 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:11407 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbbA0KB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:01:29 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <xiakaixu@huawei.com>,
        <kaixu.xia@linaro.org>
Subject: [PATCH] perf: remove the extra validity check on nr_pages
Date: Tue, 27 Jan 2015 17:55:12 +0800
Message-ID: <1422352512-75150-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is_power_of_2() also do the check on nr_pages,
so the first check performed is unnecessary. On the other
hand, the key point is to ensure @nr_pages is a power-of-two
number and mostly @nr_pages is a nonzero value, so in the
most cases, the function is_power_of_2() will be called.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 882f835..abb57c2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4268,7 +4268,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	 * If we have rb pages ensure they're a power-of-two number, so we
 	 * can do bitmasks instead of modulo.
 	 */
-	if (nr_pages != 0 && !is_power_of_2(nr_pages))
+	if (!is_power_of_2(nr_pages))
 		return -EINVAL;
 
 	if (vma_size != PAGE_SIZE * (1 + nr_pages))
-- 
1.8.5.5

