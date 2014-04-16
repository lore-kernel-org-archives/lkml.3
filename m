Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaDPMbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:31:31 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7390 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaDPMb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:31:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Apr 2014 05:23:40 -0700
From: Peter Chiang <pchiang@nvidia.com>
To: Peter Chiang <pchiang@nvidia.com>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oleg@redhat.com" <oleg@redhat.com>, "tj@kernel.org" <tj@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Apr 2014 20:31:24 +0800
Subject: RE: [PATCH] mm : Avoid candidate task is equal to current task
Thread-Topic: [PATCH] mm : Avoid candidate task is equal to current task
Thread-Index: Ac9ZIMLavZdg8yEMSayjZQY6ZEC6ywATQPhg
Message-ID: <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com>
In-Reply-To: <1397617379-26895-1-git-send-email-pchiang@nvidia.com>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm_update_next_owner() call from exit_mm() , and exit_mm()  change tsk->mm to NULL
If p==c , It seems to be  impossible that mm == c->mm  (tsk->mm) . Because mm is non-NULL and  c->mm is NULL . 


-----Original Message-----
From: Peter Chiang [mailto:pchiang@nvidia.com] 
Sent: Wednesday, April 16, 2014 11:03 AM
To: ccross@android.com; Peter Chiang; lizefan@huawei.com; akpm@linux-foundation.org; oleg@redhat.com; tj@kernel.org; pavel@ucw.cz; ebiederm@xmission.com; guillaume@morinfr.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm : Avoid candidate task is equal to current task

From: pchiang <pchiang@nvidia.com>

Fix kernel panic when finding a new owner for the mm and the new owner is equal to current onwer

Signed-off-by: pchiang <pchiang@nvidia.com>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c index 6ed6a1d..aa98422 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -399,7 +399,7 @@ retry:
 	 * here often
 	 */
 	do_each_thread(g, c) {
-		if (c->mm == mm)
+		if ((c != p) && (c->mm == mm))
 			goto assign_new_owner;
 	} while_each_thread(g, c);
 
--
1.8.1.5

