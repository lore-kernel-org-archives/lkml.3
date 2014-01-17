Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaAQHXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:23:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46009 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaAQHXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:23:30 -0500
X-AuditID: cbfee68e-b7f566d000002344-de-52d8da6ffe6c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: avoid f2fs_balance_fs call during pageout
Date: Fri, 17 Jan 2014 16:22:04 +0900
Message-id: <1389943324-25582-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zQ938WzeCDK6dY7W4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PE/RNsBRP5Ktqn
	H2JpYHzO1cXIySEhYCLR8a2TCcIWk7hwbz1bFyMXh5DAMkaJyzM+ssIUzduyACoxnVFi2+sn
	LBBOE5NE95mbQO0cHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQBLCAg4SnV2N7CA2
	i4CqxKHt/8FW8wq4S7S2zWKG2KYtse35RLBmCYHHbBKnr+1ggWgQkPg2+RALyDIJAVmJTQeg
	6iUlDq64wTKBUXABI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJAg7NvBePOA9SHGZKBx
	E5mlRJPzgUGcVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYKy7xaq1hWCGSuMbNsSQ3d94m0f7vtrPvPF+79t2jerGSyjU+LjX6J5mklYRnNfJ1
	a7fs2rYuwL+hiCUwK8dlv97urVYTy7fOXs5bk+Ew+XO1vNxrFwmbiIBDVQ8jWV9Mla6frdd7
	Ok5QLozHudd79wEdrXfe/ueq2zPrmcvK3xcFmK6Id1ViKc5INNRiLipOBAD7aCwyWAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd38WzeCDG49YbS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjxP0TbAUT+Srapx9iaWB8ztXFyMkhIWAiMW/LAjYIW0ziwr31QDYXh5DA
	dEaJba+fsEA4TUwS3WduMnUxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAs4
	SHR2NbKD2CwCqhKHtv9nArF5BdwlWttmMUNs05bY9nwi4wRG7gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgkP8mfQOxlUNFocYBTgYlXh4JcRvBAmxJpYVV+YeYpTgYFYS4d16EyjE
	m5JYWZValB9fVJqTWnyIMRlo+0RmKdHkfGD85ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDYyHLA88On/vFJ+TYO71eZW09q/Q6JO7g+pesa1rvSHL6N9g9
	EDx5Tfn27QVP1nWm57xtf1D44ueJzg+RUyUVd/zU4Yv6mtQ6z+iQ9DSBBQ0b/kp93Kz5IL/I
	w2jBP71z77YG/70vMK3mwkGBez/7p8q2T1Utdg7jm7gw+/9m0a/TznM63HMrjVJiKc5INNRi
	LipOBAADhlLgtQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should resolve the following bug.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.13.0-rc5.f2fs+ #6 Not tainted
---------------------------------------------------------
kswapd0/41 just changed the state of lock:
 (&sbi->gc_mutex){+.+.-.}, at: [<ffffffffa030503e>] f2fs_balance_fs+0xae/0xd0 [f2fs]
but this lock took another, RECLAIM_FS-READ-unsafe lock in the past:
 (&sbi->cp_rwsem){++++.?}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
Chain exists of:
  &sbi->gc_mutex --> &sbi->cp_mutex --> &sbi->cp_rwsem

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sbi->cp_rwsem);
                               local_irq_disable();
                               lock(&sbi->gc_mutex);
                               lock(&sbi->cp_mutex);
  <Interrupt>
    lock(&sbi->gc_mutex);

 *** DEADLOCK ***

This bug is due to the f2fs_balance_fs call in f2fs_write_data_page.
If f2fs_write_data_page is triggered by wbc->for_reclaim via kswapd, it should
not call f2fs_balance_fs which tries to get a mutex grabbed by original syscall
flow.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 19ad066..e57bde0 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -842,8 +842,10 @@ write:
 	else if (err)
 		goto redirty_out;
 
-	if (wbc->for_reclaim)
+	if (wbc->for_reclaim) {
 		f2fs_submit_merged_bio(sbi, DATA, WRITE);
+		need_balance_fs = false;
+	}
 
 	clear_cold_data(page);
 out:
-- 
1.8.4.474.g128a96c

