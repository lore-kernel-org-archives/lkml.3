Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaBGME1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:04:27 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54727 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaBGMEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:04:23 -0500
Date: Fri, 7 Feb 2014 17:34:18 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: [PATCH 3/9] mm: Mark function as static in mmap.c
Message-ID: <a2b21fa8852f0ee5c8da179240142e5f084154e9.1391167128.git.rashika.kheria@gmail.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in mmap.c because they are not used outside this
file.

This eliminates the following warning in mm/mmap.c:
mm/mmap.c:407:6: warning: no previous prototype for ‘validate_mm’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 834b2d7..4a03790 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -404,7 +404,7 @@ static void validate_mm_rb(struct rb_root *root, struct vm_area_struct *ignore)
 	}
 }
 
-void validate_mm(struct mm_struct *mm)
+static void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
 	int i = 0;
-- 
1.7.9.5

