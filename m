Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaDHIXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:23:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbaDHIXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:23:04 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/2] Disable zone_reclaim_mode by default v2
Date: Tue,  8 Apr 2014 09:22:58 +0100
Message-Id: <1396945380-18592-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since v1
 o topology comment updates

When it was introduced, zone_reclaim_mode made sense as NUMA distances
punished and workloads were generally partitioned to fit into a NUMA
node. NUMA machines are now common but few of the workloads are NUMA-aware
and it's routine to see major performance due to zone_reclaim_mode being
enabled but relatively few can identify the problem.

Those that require zone_reclaim_mode are likely to be able to detect when
it needs to be enabled and tune appropriately so lets have a sensible
default for the bulk of users.

 Documentation/sysctl/vm.txt         | 17 +++++++++--------
 arch/ia64/include/asm/topology.h    |  3 ++-
 arch/powerpc/include/asm/topology.h |  8 ++------
 include/linux/mmzone.h              |  1 -
 include/linux/topology.h            |  3 ++-
 mm/page_alloc.c                     | 17 +----------------
 6 files changed, 16 insertions(+), 33 deletions(-)

-- 
1.8.4.5

