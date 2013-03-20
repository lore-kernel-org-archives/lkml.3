Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab3CTJ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:26:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:30748 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964939Ab3CTJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:26:15 -0400
Message-ID: <514980B4.4050300@huawei.com>
Date: Wed, 20 Mar 2013 17:26:12 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] relay: use macro PAGE_ALIGN instead of FIX_SIZE
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro FIX_SIZE is same as PAGE_ALIGN at present,
so use PAGE_ALIGN instead.

Thanks Andrew found this.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/relay.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index d0c638f..5666dad 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -550,9 +550,6 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 	return NOTIFY_OK;
 }

-/* Needs a _much_ better name... */
-#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
-
 /**
  *	relay_open - create a new relay channel
  *	@base_filename: base name of files to create, %NULL for buffering only
@@ -591,7 +588,7 @@ struct rchan *relay_open(const char *base_filename,
 	chan->version = RELAYFS_CHANNEL_VERSION;
 	chan->n_subbufs = n_subbufs;
 	chan->subbuf_size = subbuf_size;
-	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
+	chan->alloc_size = PAGE_ALIGN(subbuf_size * n_subbufs);
 	chan->parent = parent;
 	chan->private_data = private_data;
 	if (base_filename) {
-- 
1.7.9.7


