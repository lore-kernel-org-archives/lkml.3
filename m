Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab3E1VYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:24:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab3E1VYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 36/78] dm table: fix write same support
Date: Tue, 28 May 2013 14:19:45 -0700
Message-Id: <1369776027-17859-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit dc019b21fb92d620a3b52ccecc135ac968a7c7ec upstream.

If device_not_write_same_capable() returns true then the iterate_devices
loop in dm_table_supports_write_same() should return false.

Reported-by: Bharata B Rao <bharata.rao@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index daf25d0..62545f6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1443,7 +1443,7 @@ static bool dm_table_supports_write_same(struct dm_table *t)
 			return false;
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_not_write_same_capable, NULL))
+		    ti->type->iterate_devices(ti, device_not_write_same_capable, NULL))
 			return false;
 	}
 
-- 
1.8.1.2

