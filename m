Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3EVDeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 23:34:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11438 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3EVDeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 23:34:17 -0400
X-AuditID: cbfee691-b7fef6d000002d62-58-519c3cb7bd24
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: should not make_bad_inode on f2fs_link failure
Date: Wed, 22 May 2013 12:33:03 +0900
Message-id: <1369193584-2963-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zfd3tNnMCDR4dtrG4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PfjUOMBRdYKu4d
	+8HSwPiEuYuRk0NCwERi/aw1LBC2mMSFe+vZuhi5OIQEljFKNP3czQZTtO3SS2aIxCJGiYW7
	+qGcNiaJzR07gKo4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96DrRAW8JTYM6UBzGYR
	UJX4OnUlmM0r4Cax4XgTE8Q2XYnV/5+zgzRLCNxnk3j56Cc7RIOAxLfJh1hAlkkIyEpsOgD1
	gqTEwRU3WCYwCi5gZFjFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERKEE3cw3j9gfYgxGWjc
	RGYp0eR8YBDnlcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiR
	iYNTqoFRseRNScatuCjX6ZIfeVx3tBz3zM0+usnq4HrB0Ic93MUrJkxm3K6gNXHpDLcmhx7V
	G3fD+TWNS0S6OMtOxG1Qiwt94dr69eAV0ZhPv6Pqf059euW9/c/WHdw1m5nbWX5/XxHuNPNs
	xKIeNRnNML/HTCp+qZ+ZS2QnvjDM79zr6PJTXvMgb7ESS3FGoqEWc1FxIgBTkhgKWAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd3tNnMCDea+sLC4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj341DjAUXWCruHfvB0sD4hLmLkZNDQsBEYtull1C2mMSFe+vZuhi5OIQE
	FjFKLNzVzwzhtDFJbO7YAZTh4GAT0JbYvN8ApEFEgFliwdTzjCA1zAITGCX+L3rPApIQFvCU
	2DOlAcxmEVCV+Dp1JZjNK+AmseF4ExPENl2J1f+fs09g5F7AyLCKUTS1ILmgOCk911CvODG3
	uDQvXS85P3cTIzjEn0ntYFzZYHGIUYCDUYmH90Ht7EAh1sSy4srcQ4wSHMxKIryr1OYECvGm
	JFZWpRblxxeV5qQWH2JMBto+kVlKNDkfGH95JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJI
	TyxJzU5NLUgtgtnCxMEp1cCowD+///gclh+V/C9L3KOZdvTKPtVkuWuqoyOrvrO74LyIs1iG
	1cKV57bd0JThzThku7/7gjTjnZYJiqeF1Z4EZO8TjX/lfj3FKGjG+W+1x09nWlX43jjzry2I
	b7XdIXXbRkOhy46Xgvx/XpHJY7j2noHx/wLj2/WLJi9wqtka8efobZMTDhJKLMUZiYZazEXF
	iQAfqF96tQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If -ENOSPC is met during f2fs_link, we should not make the inode as bad.
The inode is still alive.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 729b285..71aa305 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -191,7 +191,6 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 	return 0;
 out:
 	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
-	make_bad_inode(inode);
 	iput(inode);
 	return err;
 }
-- 
1.8.1.3.566.gaa39828

