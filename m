Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaAXPOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:14:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbaAXPOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:14:10 -0500
From: Aaron Tomlin <atomlin@redhat.com>
To: mingo@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, mingo@redhat.com, oleg@redhat.com,
        riel@redhat.com, bmr@redhat.com, akpm@linux-foundation.org,
        atomlin@redhat.com
Subject: [PATCH] mm: Document improved handling of swappiness==0
Date: Fri, 24 Jan 2014 15:13:28 +0000
Message-Id: <1390576408-16673-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to upstream commit fe35004f ("[mm] avoid swapping out
with swappiness==0") setting swappiness to 0, reclaim code
could still evict recently used user anonymous memory to swap
even though there is a significant amount of RAM used for page
cache.

The behaviour of setting swappiness to 0 has since changed.
When set, the reclaim code does not initiate swap until the
amount of free pages and file-backed pages, is less than the
high water mark in a zone.

Let's update the documentation to reflect this.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Bryn M. Reeves <bmr@redhat.com>
---
 Documentation/sysctl/vm.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 9f5481b..38388ee 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -696,7 +696,9 @@ swappiness
 
 This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase agressiveness, lower values
-decrease the amount of swap.
+decrease the amount of swap.  A value of 0 instructs the kernel not to
+initiate swap until the amount of free and file-backed pages, is less
+than the high water mark in a zone.
 
 The default value is 60.
 
-- 
1.8.4.2

