Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbbASIVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:21:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:45422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbbASIU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:20:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442178994"
Message-ID: <54BE0FB3.1030008@intel.com>
Date: Tue, 20 Jan 2015 16:20:03 +0800
From: Pan Xinhui <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
CC: akpm@linux-foundation.org, oleg@redhat.com, bill.c.roberts@gmail.com,
        rientjes@google.com, yanmin_zhang@linux.intel.com
Subject: [PATCH] mm/util.c: add a none zero check of "len"
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although this check should have been done by caller. But as it's exported to others,
It's better to add a none zero check of "len" like other functions.

Signed-off-by: xinhuix.pan <xinhuix.pan@intel.com>
---
  mm/util.c | 5 +++++
  1 file changed, 5 insertions(+)

diff --git a/mm/util.c b/mm/util.c
index fec39d4..3dc2873 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -72,6 +72,9 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
  {
  	void *p;
  
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
+
  	p = kmalloc_track_caller(len, gfp);
  	if (p)
  		memcpy(p, src, len);
@@ -91,6 +94,8 @@ void *memdup_user(const void __user *src, size_t len)
  {
  	void *p;
  
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
  	/*
  	 * Always use GFP_KERNEL, since copy_from_user() can sleep and
  	 * cause pagefault, which makes it pointless to use GFP_NOFS
-- 
1.9.1
