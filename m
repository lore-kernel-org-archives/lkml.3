Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967762AbaFQWiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:38:23 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:27817 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966569AbaFQWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:38:20 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 0/2] mm, thp: two THP splitting performance fixes
Date: Tue, 17 Jun 2014 18:37:57 -0400
Message-Id: <1403044679-9993-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
 - Add a second patch to replace smp_mb() by smp_mb__after_atomic().
 - Add performance data to the first patch

This mini-series contains 2 minor changes to the transparent huge
page splitting code to split its performance, particularly for the
x86 architecture.

Waiman Long (2):
  mm, thp: move invariant bug check out of loop in
    __split_huge_page_map
  mm, thp: replace smp_mb after atomic_add by smp_mb__after_atomic

 mm/huge_memory.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

