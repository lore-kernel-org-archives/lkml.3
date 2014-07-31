Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaGaLuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaGaLuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:50:01 -0400
From: "Jerome Marchand" <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 0/2] Fix excessive swapping when memcg are enabled
Date: Thu, 31 Jul 2014 13:49:43 +0200
Message-Id: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memory cgroups are enabled, reclaim code may force scan of
anonymous page in one memcg even when there are plenty of file pages
in other memcg. It has lead to excessive swapping in a real life
example: a virtual machine running in a memcg while there is
background I/O.

The first patch just updates an outdated comment that has bugged me
for a while but that I never bothered to update. The second patch
actually fixes the issue.

Jerome Marchand (2):
  mm, vmscan: fix an outdated comment still mentioning get_scan_ratio
  memcg, vmscan: Fix forced anon scan

 mm/vmscan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
1.9.3

