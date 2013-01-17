Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3AQW4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:56:09 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41279 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3AQWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:17 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 0/9] mm: zone & pgdat accessors plus some cleanup
Date: Thu, 17 Jan 2013 14:52:52 -0800
Message-Id: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-4834-0000-0000-000002B5BEAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summaries:
1 - avoid repeating checks for section in page flags by adding a define.
2 - add & switch to zone_end_pfn() and zone_spans_pfn()
3 - adds zone_is_initialized() & zone_is_empty()
4 - adds a VM_BUG using zone_is_initialized() in __free_one_page()
5 - add pgdat_end_pfn() and pgdat_is_empty()
6 - add debugging message to VM_BUG check.
7 - add ensure_zone_is_initialized() (for memory_hotplug)
8 - use the above addition in memory_hotplug
9 - use pgdat_end_pfn()

As a general concern: spanned_pages & start_pfn (in pgdat & zone) are supposed
to be locked (via a seqlock) when read (due to changes to them via
memory_hotplug), but very few (only 1?) of their users appear to actually lock
them.

--

Since v1:
 - drop zone+pgdat growth factoring (I use this in some WIP code to resign the
   NUMA node a page belongs to, will send with that patchset)
 - merge zone_end_pfn() & zone_spans_pfn() introduction & usage
 - split zone_is_initialized() & zone_is_empty() out from the above.
 - add a missing semicolon

 include/linux/mm.h     |  8 ++++++--
 include/linux/mmzone.h | 34 +++++++++++++++++++++++++++++----
 mm/compaction.c        | 10 +++++-----
 mm/kmemleak.c          |  5 ++---
 mm/memory_hotplug.c    | 52 ++++++++++++++++++++++++++------------------------
 mm/page_alloc.c        | 31 +++++++++++++++++-------------
 mm/vmstat.c            |  2 +-
 7 files changed, 89 insertions(+), 53 deletions(-)

