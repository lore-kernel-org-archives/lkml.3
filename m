Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbaISPcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:32:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:3095 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296AbaISPay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="605437239"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: sparse@chrisli.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 6/7] mm: Silence nested-externs warnings
Date: Fri, 19 Sep 2014 08:29:39 -0700
Message-Id: <1411140580-20909-7-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Use diagnostic control macros to ignore nested-externs warnings
in this case.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>
CC: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/mm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8981cc8..9bf2c7e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1623,7 +1623,9 @@ static inline void mark_page_reserved(struct page *page)
  */
 static inline unsigned long free_initmem_default(int poison)
 {
+	DIAG_PUSH DIAG_IGNORE(nested-externs)
 	extern char __init_begin[], __init_end[];
+	DIAG_POP
 
 	return free_reserved_area(&__init_begin, &__init_end,
 				  poison, "unused kernel");
-- 
1.9.3

