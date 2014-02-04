Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935406AbaBDWcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:32:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814AbaBDVIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Robert Lippert <rlippert@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 007/133] mm/mempolicy.c: fix mempolicy printing in numa_maps
Date: Tue,  4 Feb 2014 13:06:48 -0800
Message-Id: <20140204210737.227211443@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Cc: <stable@vger.kernel.org>	[3.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2857,7 +2857,7 @@ int mpol_to_str(char *buffer, int maxlen
 	 */
 	VM_BUG_ON(maxlen < strlen("interleave") + strlen("relative") + 16);
 
-	if (!pol || pol == &default_policy)
+	if (!pol || pol == &default_policy || (pol->flags & MPOL_F_MORON))
 		mode = MPOL_DEFAULT;
 	else
 		mode = pol->mode;


