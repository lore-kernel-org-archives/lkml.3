Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483AbaH0NPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:15:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22624 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbaH0NPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:15:45 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Russell King <linux@arm.linux.org.uk>,
        "David A. Long" <dave.long@linaro.org>, Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Will Deacon <will.deacon@arm.com>
CC: Wang Nan <wangnan0@huawei.com>, Pei Feiyue <peifeiyue@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 2/3] kprobes: copy ainsn after alloc aggr kprobe
Date: Wed, 27 Aug 2014 21:02:31 +0800
Message-ID: <1409144552-12751-3-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>
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

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "David A. Long" <dave.long@linaro.org> 
Cc: Jon Medhurst <tixy@linaro.org>
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 kernel/kprobes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f54..33cf568 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -730,7 +730,12 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 		return NULL;
 
 	INIT_LIST_HEAD(&op->list);
-	op->kp.addr = p->addr;
+
+	/*
+	 * copy gives arch_prepare_optimized_kprobe
+	 * more information
+	 */
+	copy_kprobe(p, &op->kp);
 	arch_prepare_optimized_kprobe(op);
 
 	return &op->kp;
-- 
1.8.4

