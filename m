Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbaGWLYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:24:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641AbaGWLYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:24:19 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: [PATCH 0/2] Avoid unnecessary overhead in fault paths due to memcg and rss stats
Date: Wed, 23 Jul 2014 12:24:14 +0100
Message-Id: <1406114656-16350-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking for something else entirely I spotted two small issues in the
page fault fast path. Enabling memcg takes the RCU read lock unnecessarily
even when the task is not part of a memcg and we fiddle with RSS stats
more than necessary. Details in the patches.

 include/linux/memcontrol.h |  8 ++++++++
 include/linux/mm_types.h   |  1 -
 mm/memory.c                | 32 +++++++++++++-------------------
 3 files changed, 21 insertions(+), 20 deletions(-)

-- 
1.8.4.5

