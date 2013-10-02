Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3JBO3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:29:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3JBO25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 02/26] ia64: Use get_user_pages_fast() in err_inject.c
Date: Wed,  2 Oct 2013 16:27:43 +0200
Message-Id: <1380724087-13927-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert get_user_pages() call to get_user_pages_fast(). This actually
fixes an apparent bug where get_user_pages() has been called without
mmap_sem for an arbitrary user-provided address.

CC: Tony Luck <tony.luck@intel.com>
CC: linux-ia64@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 arch/ia64/kernel/err_inject.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/err_inject.c b/arch/ia64/kernel/err_inject.c
index f59c0b844e88..75d35906a86b 100644
--- a/arch/ia64/kernel/err_inject.c
+++ b/arch/ia64/kernel/err_inject.c
@@ -142,8 +142,7 @@ store_virtual_to_phys(struct device *dev, struct device_attribute *attr,
 	u64 virt_addr=simple_strtoull(buf, NULL, 16);
 	int ret;
 
-        ret = get_user_pages(current, current->mm, virt_addr,
-                        1, VM_READ, 0, NULL, NULL);
+	ret = get_user_pages_fast(virt_addr, 1, VM_READ, NULL);
 	if (ret<=0) {
 #ifdef ERR_INJ_DEBUG
 		printk("Virtual address %lx is not existing.\n",virt_addr);
-- 
1.8.1.4

