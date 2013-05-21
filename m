Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3EUHNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:13:36 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1768 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088Ab3EUHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:13:35 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Oskar Andero <oskar.andero@sonymobile.com>,
        Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] mm: vmscan: add VM_BUG_ON on illegal return values from scan_objects
Date: Tue, 21 May 2013 09:13:30 +0200
Message-ID: <1369120410-18180-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a VM_BUG_ON to catch any illegal value from the shrinkers. It's a
potential bug if scan_objects returns a negative other than -1 and
would lead to undefined behaviour.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 mm/vmscan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6bac41e..63fec86 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -293,6 +293,7 @@ shrink_slab_one(struct shrinker *shrinker, struct shrink_control *shrinkctl,
 		ret = shrinker->scan_objects(shrinker, shrinkctl);
 		if (ret == -1)
 			break;
+		VM_BUG_ON(ret < -1);
 		freed += ret;
 
 		count_vm_events(SLABS_SCANNED, nr_to_scan);
-- 
1.8.1.5

