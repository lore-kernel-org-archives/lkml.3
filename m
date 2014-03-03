Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaCCIY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:24:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:25752 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaCCIYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:24:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,576,1389772800"; 
   d="scan'208";a="491139655"
From: "He, Bo" <bo.he@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>
CC: "yanmin_zhang@intel.linux.com" <yanmin_zhang@intel.linux.com>,
        "Wang, Biao" <biao.wang@intel.com>
Subject: [PATCH]  mm, oom: normalize the adj to ensure oom_badness return
 one 
Thread-Topic: [PATCH]  mm, oom: normalize the adj to ensure oom_badness
 return one 
Thread-Index: Ac82uK1kETMgg4H6SHafPa3vfSroJw==
Date: Mon, 3 Mar 2014 08:24:22 +0000
Message-ID: <CD6925E8781EFD4D8E11882D20FC406D01AEDC58@SHSMSX103.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if oom_score_adj is a big negative number, such as -941,
adj *= totalpages / 1000 will be a big negative number, 
finally the oom_badness will get 0 points, here normalize 
the oom_score_adj to ensure oom_badness return the
positive number.

Change-Id: I1c56a948ce48b65a1bb63b56ffef07d5d76d7ec8
Signed-off-by: he, bo <bo.he@intel.com>
Signed-off-by: wang, biao <biao.wang@intel.com>
Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
---
 mm/oom_kill.c |    3 +++ 
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3291e82..5a93986 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -181,6 +181,9 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
        points -= (points * 3) / 100;
 
    /* Normalize to oom_score_adj units */
+   if(OOM_SCORE_ADJ_MIN < 0)
+       adj -= OOM_SCORE_ADJ_MIN;
+
    adj *= totalpages / 1000;
    points += adj;
 
-- 
1.7.6


