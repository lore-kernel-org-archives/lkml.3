Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab3EAWRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:17:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44365 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306Ab3EAWRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:17:37 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 3/4] mmzone: note that node_size_lock should be manipulated via pgdat_resize_lock()
Date: Wed,  1 May 2013 15:17:14 -0700
Message-Id: <1367446635-12856-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-5518-0000-0000-00000E32186E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index afd0aa5..45be383 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -716,6 +716,8 @@ typedef struct pglist_data {
 	 * or node_spanned_pages stay constant.  Holding this will also
 	 * guarantee that any pfn_valid() stays that way.
 	 *
+	 * Use pgdat_resize_lock() and pgdat_resize_unlock() to manipulate.
+	 *
 	 * Updaters of any of these fields also must hold
 	 * lock_memory_hotplug().
 	 *
-- 
1.8.2.2

