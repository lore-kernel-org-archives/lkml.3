Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab3APAZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:25:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59487 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872Ab3APAZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:25:19 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 00/17] mm: zone & pgdat accessors plus some cleanup
Date: Tue, 15 Jan 2013 16:24:37 -0800
Message-Id: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-7182-0000-0000-000004762DEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summaries:

01 - removes the use of zone_end_pfn as a local var name.
02 - adds zone_end_pfn(), zone_is_initialized(), zone_is_empty() and zone_spans_pfn()
03 - adds a VM_BUG using zone_is_initialized() in __free_one_page()

04 - add ensure_zone_is_initialized() (for memory_hotplug)
05 - use the above addition.

06 - add pgdat_end_pfn() and pgdat_is_empty()

07,08,09,10,11,12,16,17 - use the new helpers

13 - avoid repeating checks for section in page flags by adding a define.
14 - memory hotplug: factor out zone+pgdat growth.
15 - add debugging message to VM_BUG check.

As a general concern: spanned_pages & start_pfn (in pgdat & zone) are supposed
to be locked (via a seqlock) when read (due to changes to them via
memory_hotplug), but very few (only 1?) of their users appear to actually lock
them.

--

 include/linux/mm.h     |  8 ++++--
 include/linux/mmzone.h | 34 ++++++++++++++++++++++---
 mm/compaction.c        | 10 ++++----
 mm/kmemleak.c          |  5 ++--
 mm/memory_hotplug.c    | 68 ++++++++++++++++++++++++++++----------------------
 mm/page_alloc.c        | 31 +++++++++++++----------
 mm/vmstat.c            |  2 +-
 7 files changed, 100 insertions(+), 58 deletions(-)

