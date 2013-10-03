Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3JCEQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:16:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3JCEQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:16:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [ 41/52] dm-raid: silence compiler warning on rebuilds_per_group.
Date: Wed,  2 Oct 2013 21:05:59 -0700
Message-Id: <20131003040525.047739188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 3f6bbd3ffd7b733dd705e494663e5761aa2cb9c1 upstream.

This doesn't really need to be initialised, but it doesn't hurt,
silences the compiler, and as it is a counter it makes sense for it to
start at zero.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -380,7 +380,7 @@ static int validate_region_size(struct r
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned i, rebuild_cnt = 0;
-	unsigned rebuilds_per_group, copies, d;
+	unsigned rebuilds_per_group = 0, copies, d;
 	unsigned group_size, last_group_start;
 
 	for (i = 0; i < rs->md.raid_disks; i++)


