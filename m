Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbbAGCo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:44:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955AbbAGCHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 16/52] dm cache: only use overwrite optimisation for promotion when in writeback mode
Date: Tue,  6 Jan 2015 18:06:44 -0800
Message-Id: <20150107020557.729624894@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit f29a3147e251d7ae20d3194ff67f109d71e501b4 upstream.

Overwrite causes the cache block and origin blocks to diverge, which
is only allowed in writeback mode.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1060,7 +1060,8 @@ static void issue_copy(struct dm_cache_m
 
 		avoid = is_discarded_oblock(cache, mg->new_oblock);
 
-		if (!avoid && bio_writes_complete_block(cache, bio)) {
+		if (writeback_mode(&cache->features) &&
+		    !avoid && bio_writes_complete_block(cache, bio)) {
 			issue_overwrite(mg, bio);
 			return;
 		}


