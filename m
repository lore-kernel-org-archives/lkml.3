Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbbAFNoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:44:21 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:65163 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbAFNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:44:20 -0500
Date: Tue, 6 Jan 2015 15:44:15 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dm bufio: fix time comparison
Message-ID: <20150106134415.GA15873@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparison
modified to use time_after_eq() instead of plain, error-prone math.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/md/dm-bufio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index c33b497..86dbbc7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -11,6 +11,7 @@
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 #include <linux/vmalloc.h>
 #include <linux/shrinker.h>
 #include <linux/module.h>
@@ -1739,7 +1740,7 @@ static unsigned get_max_age_hz(void)
 
 static bool older_than(struct dm_buffer *b, unsigned long age_hz)
 {
-	return (jiffies - b->last_accessed) >= age_hz;
+	return time_after_eq(jiffies, b->last_accessed + age_hz);
 }
 
 static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
-- 
1.7.0.4

