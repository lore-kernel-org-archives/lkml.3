Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3HKAz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 20:55:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:37325 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3HKAzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 20:55:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,853,1367996400"; 
   d="scan'208";a="384386388"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, ananth@in.ibm.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] kprobes: Use KSYM_NAME_LEN to size identifier buffers
Date: Sat, 10 Aug 2013 17:55:33 -0700
Message-Id: <1376182533-17530-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376182533-17530-1-git-send-email-andi@firstfloor.org>
References: <1376182533-17530-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Mario <jmario@redhat.com>

Use KSYM_NAME_LEN to size identifier buffers, so that it can
be easier increased.

Cc: ananth@in.ibm.com
Signed-off-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/kprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 6e33498..e174daf 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2083,7 +2083,7 @@ static int __init init_kprobes(void)
 {
 	int i, err = 0;
 	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[128];
+	char *modname, namebuf[KSYM_NAME_LEN];
 	const char *symbol_name;
 	void *addr;
 	struct kprobe_blackpoint *kb;
@@ -2209,7 +2209,7 @@ static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 	const char *sym = NULL;
 	unsigned int i = *(loff_t *) v;
 	unsigned long offset = 0;
-	char *modname, namebuf[128];
+	char *modname, namebuf[KSYM_NAME_LEN];
 
 	head = &kprobe_table[i];
 	preempt_disable();
-- 
1.8.3.1

