Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3KPGQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 01:16:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31221 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3KPGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 01:16:38 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-64-52870dc4fe2a
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: use f2fs_put_page to release page for uniform
 style
Date: Sat, 16 Nov 2013 14:15:59 +0800
Message-id: <000201cee293$6137cd80$23a76880$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7g2gR14SGWiU7oRD6ix9A81UH5HA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQd0jvO1BBl+a9S2u7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY8/jJ8wF
	a1gqPh3YzNLAuI+5i5GTQ0LARGLClvWsELaYxIV769m6GLk4hASmM0pMm/oUyvnBKNH7+xYT
	SBWbgIrE8o7/YLaIgKLEhvcb2EGKmAVmMEocnvsPbJSwQLjEqzOXWEBsFgFViV/P7rKB2LwC
	lhL710+DsgUlfky+B1bDLKAh0b9oAxuELS+xec1bqPMUJHacfc0IsUxP4uXG/UwQNeISG4/c
	YpnAKDALyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCw/qZ1A7G
	lQ0WhxgFOBiVeHh3BLQFCbEmlhVX5h5ilOBgVhLh7eZuDxLiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAeOThhwV/Hz5b+8/rkmZO09dUNZ+ar62Hbq7a
	8ER7ws1b6VUMGStfX3OxS7uhv7v+b+C5qTYvUyVWf/934YGW5Ob4c5Nyj8U4L5BduMrpxac3
	ng9z2k/Z3ZZkZIy0uFMYsk/i3TbryymBvyP/mzElv5Lm+WqVGCF/c53Hxrdxf6bkrNhrccQh
	e50SS3FGoqEWc1FxIgDHx0fQZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use f2fs_put_page to release page for uniform style of f2fs code.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa3438c..076a60c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -714,8 +714,7 @@ static int f2fs_write_end(struct file *file,
 		update_inode_page(inode);
 	}
 
-	unlock_page(page);
-	page_cache_release(page);
+	f2fs_put_page(page, 1);
 	return copied;
 }
 
-- 
1.7.9.5


