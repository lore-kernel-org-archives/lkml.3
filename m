Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaBGMBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:01:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaBGLwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 209/233] mm/mempolicy.c: fix mempolicy printing in numa_maps
Date: Fri,  7 Feb 2014 11:47:08 +0000
Message-Id: <1391773652-25214-210-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 8790c71a18e5d2d93532ae250bcf5eddbba729cd upstream.

As a result of commit 5606e3877ad8 ("mm: numa: Migrate on reference
policy"), /proc/<pid>/numa_maps prints the mempolicy for any <pid> as
"prefer:N" for the local node, N, of the process reading the file.

This should only be printed when the mempolicy of <pid> is
MPOL_PREFERRED for node N.

If the process is actually only using the default mempolicy for local
node allocation, make sure "default" is printed as expected.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Robert Lippert <rlippert@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.11: used David Rientjes's backport to 3.10 and
  3.12 stable trees. ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index bfa95cf..bfb3238 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2806,7 +2806,7 @@ int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 	 */
 	VM_BUG_ON(maxlen < strlen("interleave") + strlen("relative") + 16);
 
-	if (!pol || pol == &default_policy)
+	if (!pol || pol == &default_policy || (pol->flags & MPOL_F_MORON))
 		mode = MPOL_DEFAULT;
 	else
 		mode = pol->mode;
-- 
1.8.3.2

