Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaHTT0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaHTT0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:26:14 -0400
Date: Wed, 20 Aug 2014 21:22:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mempolicy: change alloc_pages_vma() to use
	mpol_cond_put()
Message-ID: <20140820192247.GB8524@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820192207.GA8524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup. alloc_pages_vma() can use mpol_cond_put().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8f5330d..c0c5d38 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2046,8 +2046,7 @@ retry_cpuset:
 	page = __alloc_pages_nodemask(gfp, order,
 				      policy_zonelist(gfp, pol, node),
 				      policy_nodemask(gfp, pol));
-	if (unlikely(mpol_needs_cond_ref(pol)))
-		__mpol_put(pol);
+	mpol_cond_put(pol);
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
-- 
1.5.5.1


