Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3EAXcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:32:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38983 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3EAXcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:32:12 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 0/4] misc patches related to resizing nodes & zones
Date: Wed,  1 May 2013 16:31:57 -0700
Message-Id: <1367451121-22725-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050123-7182-0000-0000-0000067F41D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First 2 are comment fixes.
Second 2 add pgdat_resize_lock()/unlock() usage per existing documentation.

--

Since v1 (http://thread.gmane.org/gmane.linux.kernel.mm/99297):
  - drop making lock_memory_hotplug() required (old patch #1)
  - fix __offline_pages() in the same manner as online_pages() (rientjes)
  - make comment regarding pgdat_resize_lock()/unlock() usage more clear (rientjes)

--

Cody P Schafer (4):
  mm: fix comment referring to non-existent size_seqlock, change to
    span_seqlock
  mmzone: note that node_size_lock should be manipulated via
    pgdat_resize_lock()
  memory_hotplug: use pgdat_resize_lock() in online_pages()
  memory_hotplug: use pgdat_resize_lock() in __offline_pages()

 include/linux/mmzone.h | 5 ++++-
 mm/memory_hotplug.c    | 9 +++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

-- 
1.8.2.2

