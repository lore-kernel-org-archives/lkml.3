Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936276Ab3DIUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:16:29 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:41543 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S936073Ab3DIUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:16:07 -0400
Message-ID: <51647703.6060804@semaphore.gr>
Date: Tue, 09 Apr 2013 23:16:03 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alasdair Kergon <agk@redhat.com>
CC: dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] dm-raid: Fix compiler warning
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compiler warning of uninitialized variable

drivers/md/dm-raid.c: In function ‘raid_ctr’:
drivers/md/dm-raid.c:427:160: warning: ‘rebuilds_per_group’ may be used
uninitialized in this function [-Wmaybe-uninitialized]
drivers/md/dm-raid.c:383:11: note: ‘rebuilds_per_group’ was declared
here

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1d3fe1a..8041de8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -380,7 +380,7 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned i, rebuild_cnt = 0;
-	unsigned rebuilds_per_group, copies, d;
+	unsigned copies, d, rebuilds_per_group = 0;
 	unsigned group_size, last_group_start;
 
 	for (i = 0; i < rs->md.raid_disks; i++)
-- 
1.8.1.4

