Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3LDWpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:45:32 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44428 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab3LDWp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:45:26 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/2] mm: memcg: 3.13 fixes
Date: Wed,  4 Dec 2013 17:45:12 -0500
Message-Id: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are two memcg fixes for 3.13.

The race condition in #1 is really long standing AFAICS, I just tagged
stable and will backport and evaluate this for any tree that sends me
a notice.

#2 changes what happens during a charge attempt between a task
entering memcg OOM and actually executing the kill.  I had these
charges bypass the limit in the hope that this would expedite the
kill, but there is no real evidence for it and David was worried about
an unecessary breach of isolation.  This was introduced in 3.12.

 mm/memcontrol.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

