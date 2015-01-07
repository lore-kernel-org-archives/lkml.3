Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbbAGHlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:41:45 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:46286 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbbAGHll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:41:41 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 05/11] kprobes: Add an KPROBE_FLAG_EARLY for early kprobe.
Date: Wed, 7 Jan 2015 15:35:42 +0800
Message-ID: <1420616142-42937-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.50F52B3B.00F4,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d2dc00fa976deff670c125a56372259d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a KPROBE_FLAG_EARLY for futher expansion. KPROBE_FLAG_EARLY
indicates a kprobe is installed at very early stage, its resources
should be allocated statically.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 include/linux/kprobes.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 1ab5475..fa0de88 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -128,6 +128,7 @@ struct kprobe {
 				   * this flag is only for optimized_kprobe.
 				   */
 #define KPROBE_FLAG_FTRACE	8 /* probe is using ftrace */
+#define KPROBE_FLAG_EARLY	16 /* early kprobe */
 
 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
-- 
1.8.4

