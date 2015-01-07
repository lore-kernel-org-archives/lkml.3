Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbbAGHns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:43:48 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64449 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbbAGHmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:42:04 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 06/11] kprobes: makes kprobes_initialized globally visable.
Date: Wed, 7 Jan 2015 15:35:46 +0800
Message-ID: <1420616146-42980-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches will enable kprobe registering very early, before
kprobe system initialized. Arch code can use it to do special treatments
for such kprobes.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 include/linux/kprobes.h | 2 ++
 kernel/kprobes.c        | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index fa0de88..b0265f9 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -50,6 +50,8 @@
 #define KPROBE_REENTER		0x00000004
 #define KPROBE_HIT_SSDONE	0x00000008
 
+extern int kprobes_initialized;
+
 #else /* CONFIG_KPROBES */
 typedef int kprobe_opcode_t;
 struct arch_specific_insn {
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9fbe0c3..4591cae 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -67,7 +67,7 @@
 	addr = ((kprobe_opcode_t *)(kallsyms_lookup_name(name)))
 #endif
 
-static int kprobes_initialized;
+int kprobes_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
-- 
1.8.4

