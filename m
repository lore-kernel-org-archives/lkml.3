Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaABIYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:24:35 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:5467 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaABIYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:24:33 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] x86, hpet: fix memleak when hpet enable fail
Date: Thu, 2 Jan 2014 16:22:12 +0800
Message-ID: <1388650932-5168-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should free hpet_boot_cfg if hpet enable fail.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/x86/kernel/hpet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..0ed00cc 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -900,6 +900,7 @@ int __init hpet_enable(void)
 	return 0;
 
 out_nohpet:
+	kfree(hpet_boot_cfg);
 	hpet_clear_mapping();
 	hpet_address = 0;
 	return 0;
-- 
1.7.1


