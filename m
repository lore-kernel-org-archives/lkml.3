Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918Ab3GSQv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:51:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687Ab3GSQvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:51:24 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH resend 2/3] vmpressure: do not check for pending work to prevent from new work
Date: Fri, 19 Jul 2013 18:51:10 +0200
Message-Id: <1374252671-11939-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
References: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because it is racy and it doesn't give us much anyway as schedule_work
handles this case already.

Brought-up-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/vmpressure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index f4ee6a1..192f973 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -246,7 +246,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 	scanned = vmpr->scanned;
 	spin_unlock(&vmpr->sr_lock);
 
-	if (scanned < vmpressure_win || work_pending(&vmpr->work))
+	if (scanned < vmpressure_win)
 		return;
 	schedule_work(&vmpr->work);
 }
-- 
1.8.3.2

