Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaDGWed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:34:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbaDGWeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:34:31 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/2] Disable zone_reclaim_mode by default
Date: Mon,  7 Apr 2014 23:34:26 +0100
Message-Id: <1396910068-11637-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it was introduced, zone_reclaim_mode made sense as NUMA distances
punished and workloads were generally partitioned to fit into a NUMA
node. NUMA machines are now common but few of the workloads are NUMA-aware
and it's routine to see major performance due to zone_reclaim_mode being
disabled but relatively few can identify the problem.

Those that require zone_reclaim_mode are likely to be able to detect when
it needs to be enabled and tune appropriately so lets have a sensible
default for the bulk of users.

 Documentation/sysctl/vm.txt | 17 +++++++++--------
 include/linux/mmzone.h      |  1 -
 mm/page_alloc.c             | 17 +----------------
 3 files changed, 10 insertions(+), 25 deletions(-)

-- 
1.8.4.5

