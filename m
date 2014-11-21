Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbaKUPGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:06:54 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62565 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325AbaKUPGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:06:50 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/9] doc: memory-barriers.txt: Document use of lockless_dereference()
Date: Fri, 21 Nov 2014 10:05:55 -0500
Message-Id: <1416582363-20661-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416582363-20661-1-git-send-email-bobby.prani@gmail.com>
References: <1416582363-20661-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/memory-barriers.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 7ee2ae6..d33aab3 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -203,8 +203,8 @@ There are some minimal guarantees that may be expected of a CPU:
      and always in that order.  On most systems, smp_read_barrier_depends()
      does nothing, but it is required for DEC Alpha.  The ACCESS_ONCE()
      is required to prevent compiler mischief.  Please note that you
-     should normally use something like rcu_dereference() instead of
-     open-coding smp_read_barrier_depends().
+     should normally use something like rcu_dereference() or
+     lockless_dereference() instead of open-coding smp_read_barrier_depends().
 
  (*) Overlapping loads and stores within a particular CPU will appear to be
      ordered within that CPU.  This means that for:
-- 
1.9.1

