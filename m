Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbaD1PUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbaD1PUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:20:01 -0400
Date: Mon, 28 Apr 2014 17:19:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Peter Chiang <pchiang@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 3/3] memcg: kill
	start_kernel()->mm_init_owner(&init_mm)
Message-ID: <20140428151947.GA20757@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428151926.GA20729@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove start_kernel()->mm_init_owner(&init_mm, &init_task).

This doesn't really hurt but unnecessary and misleading. init_task
is the "swapper" thread == current, its ->mm is always NULL. And
init_mm can only be used as ->active_mm, not as ->mm.

mm_init_owner() has a single caller with this patch, perhaps it
should die. mm_init() can initialize ->owner under #ifdef.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 init/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 3815895..17090bb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -507,7 +507,6 @@ asmlinkage void __init start_kernel(void)
 	page_address_init();
 	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
-	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
-- 
1.5.5.1

