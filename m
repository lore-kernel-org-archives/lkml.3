Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaDKIlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:41:09 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10669 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755528AbaDKIlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:41:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,840,1389715200"; 
   d="scan'208";a="29141621"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] x86, msr: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 16:39:13 +0800
Message-ID: <1397205553-24652-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 arch/x86/kernel/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index c9603ac..6e4f77f 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -206,7 +206,7 @@ static int msr_device_create(int cpu)
 
 	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
 			    "msr%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void msr_device_destroy(int cpu)
-- 
1.8.3.1

