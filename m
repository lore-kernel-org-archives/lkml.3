Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162814Ab3DEUeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:34:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40412 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162735Ab3DEUeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:34:18 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] mm: fixup changers of per cpu pageset's ->high and ->batch
Date: Fri,  5 Apr 2013 13:33:47 -0700
Message-Id: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040520-5806-0000-0000-0000209E80D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one case while modifying the ->high and ->batch fields of per cpu pagesets
we're unneededly using stop_machine() (patches 1 & 2), and in another we don't have any
syncronization at all (patch 3).

This patchset fixes both of them.

Note that it results in a change to the behavior of zone_pcp_update(), which is
used by memory_hotplug. I _think_ that I've diserned (and preserved) the
essential behavior (changing ->high and ->batch), and only eliminated unneeded
actions (draining the per cpu pages), but this may not be the case.

--
 mm/page_alloc.c | 63 +++++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

