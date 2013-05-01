Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab3EAWRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:17:31 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58541 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab3EAWR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:17:29 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 0/4] misc patches related to resizing nodes & zones
Date: Wed,  1 May 2013 15:17:11 -0700
Message-Id: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-7182-0000-0000-0000067F1AD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 3 are simply comment fixes and clarifications on locking.

The last 1 adds additional locking when updating node_present_pages based on
the existing documentation.

Cody P Schafer (4):
  mmzone: make holding lock_memory_hotplug() a requirement for updating
    pgdat size
  mm: fix comment referring to non-existent size_seqlock, change to
    span_seqlock
  mmzone: note that node_size_lock should be manipulated via
    pgdat_resize_lock()
  memory_hotplug: use pgdat_resize_lock() when updating
    node_present_pages

 include/linux/mmzone.h | 7 ++++++-
 mm/memory_hotplug.c    | 5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
1.8.2.2

