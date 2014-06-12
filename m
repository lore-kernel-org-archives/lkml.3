Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaFLGcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:32:09 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32705 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaFLGcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:32:06 -0400
Message-ID: <53994953.4060703@huawei.com>
Date: Thu, 12 Jun 2014 14:31:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/5] percpu-ref: introduce percpu_ref_alive()
References: <53994943.60703@huawei.com>
In-Reply-To: <53994943.60703@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used to check if the percpu_ref has been killed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/percpu-refcount.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index dba35c4..1d5f2b3 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -96,6 +96,17 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
 #define REF_STATUS(count)	(((unsigned long) count) & PCPU_STATUS_MASK)
 
 /**
+ * percpu_ref_alive - check if the ref has been killed
+ * @ref: percpu_ref to check
+ *
+ * Return true if percpu_ref_kill() has been called to drop the initial ref.
+ */
+static inline bool percpu_ref_alive(struct percpu_ref *ref)
+{
+	return !(REF_STATUS(ref->pcpu_count) == PCPU_REF_DEAD);
+}
+
+/**
  * percpu_ref_get - increment a percpu refcount
  * @ref: percpu_ref to get
  *
-- 
1.8.0.2

