Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3CRCw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:52:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:49292 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3CRCw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:52:26 -0400
Message-ID: <5146814A.4010200@huawei.com>
Date: Mon, 18 Mar 2013 10:51:54 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH 2/2] relay: move FIX_SIZE macro into relay.c
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to place FIX_SIZE macro in relay.c, instead of relay.h

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/linux/relay.h |    3 ---
 kernel/relay.c        |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 91cacc3..d7c8359 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -20,9 +20,6 @@
 #include <linux/poll.h>
 #include <linux/kref.h>

-/* Needs a _much_ better name... */
-#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
-
 /*
  * Tracks changes to rchan/rchan_buf structs
  */
diff --git a/kernel/relay.c b/kernel/relay.c
index d21006c..4c2959b 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -550,6 +550,9 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 	return NOTIFY_OK;
 }

+/* Needs a _much_ better name... */
+#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
+
 /**
  *	relay_open - create a new relay channel
  *	@base_filename: base name of files to create, %NULL for buffering only
-- 
1.7.9.7


