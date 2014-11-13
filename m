Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbaKMTa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:30:57 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:38977 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbaKMTZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:01 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 02/16] doc: memory-barriers.txt: Document use of lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:08 -0500
Message-Id: <1415906662-4576-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/memory-barriers.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 3d5f49b..841ac36 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -203,7 +203,7 @@ There are some minimal guarantees that may be expected of a CPU:
      and always in that order.  On most systems, smp_read_barrier_depends()
      does nothing, but it is required for DEC Alpha.  The ACCESS_ONCE()
      is required to prevent compiler mischief.  Please note that you
-     should normally use something like rcu_dereference() instead of
+     should normally use something like lockless_dereference() instead of
      open-coding smp_read_barrier_depends().
 
  (*) Overlapping loads and stores within a particular CPU will appear to be
-- 
1.9.1

