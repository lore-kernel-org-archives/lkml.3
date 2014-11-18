Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaKRGfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:35:55 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:15947 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaKRGfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:35:53 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cl@linux.com>, <rabin@rab.in>,
        <davem@davemloft.net>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 1/2] kprobes: copy ainsn after alloc aggr kprobe
Date: Tue, 18 Nov 2014 14:32:38 +0800
Message-ID: <1416292359-75893-2-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1416292359-75893-1-git-send-email-wangnan0@huawei.com>
References: <1416292359-75893-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy old kprobe to newly alloced optimized_kprobe before
arch_prepare_optimized_kprobe(). Original kprove can brings more
information to optimizer.

v1 -> v2:
 -  Bugfix: copy p->addr when alloc_aggr_kprobe.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 kernel/kprobes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f54..e9868ec 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -730,7 +730,13 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 		return NULL;
 
 	INIT_LIST_HEAD(&op->list);
+
+	/*
+	 * copy gives arch_prepare_optimized_kprobe
+	 * more information
+	 */
 	op->kp.addr = p->addr;
+	copy_kprobe(p, &op->kp);
 	arch_prepare_optimized_kprobe(op);
 
 	return &op->kp;
-- 
1.8.4

