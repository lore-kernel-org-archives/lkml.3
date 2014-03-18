Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaCRBJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 21:09:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38520 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaCRBJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 21:09:01 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-6d-53279ca42c3b
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH v2] f2fs: fix incorrect parsing with option string
Date: Tue, 18 Mar 2014 09:07:59 +0800
Message-id: <000101cf4246$a047aeb0$e0d70c10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9CRW0a1iDcnw8CT5mNxM+9hZlOPQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd0lc9SDDWb+F7O4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6Nn9wW2gn72ikOH
	H7A3MJ5i7WLk5JAQMJHYfHkvG4QtJnHh3nogm4tDSGA6o8SMw0tYIJwfjBIbXu5gAaliE1CR
	WN7xnwnEFhFQlNjwfgM7iM0skClxr2kGM4gtLOArMbPtK5DNwcEioCpxdW4ESJhXwFLiw5pp
	zBC2oMSPyfdYIFq1JNbvPM4EYctLbF7zlhniIAWJHWdfM0Ks0pOYsWofM0SNuMTGI7dYJjAK
	zEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBAfia1g3Flg8Uh
	RgEORiUe3hds6sFCrIllxZW5hxglOJiVRHiXTgYK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Q
	ah0oJJCeWJKanZpakFoEk2Xi4JRqYGSccVRCmvHaug2aF3Q8Nk5q3SxWt25r9+nD54TMk99H
	r3EuV5X7Ypa2//3P7V7rvNstpOuZt/lut0j+fHufplaf9Dvm/HV/Jy658GzupFWVbko/a/jT
	1y+N9v/u9OJc/tK9H9iXH288u03wuVar9RezoprP907MLtX9+yKLPfPm927nF5u2lWxTYinO
	SDTUYi4qTgQAK14IDGACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously 'background_gc={on***,off***}' is being parsed as correct option,
with this patch we cloud fix the trivial bug in mount process.

Change log from v1:
 o need to check length of parameter suggested by Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 057a3ef..dbe402b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -258,9 +258,9 @@ static int parse_options(struct super_block *sb, char *options)
 
 			if (!name)
 				return -ENOMEM;
-			if (!strncmp(name, "on", 2))
+			if (strlen(name) == 2 && !strncmp(name, "on", 2))
 				set_opt(sbi, BG_GC);
-			else if (!strncmp(name, "off", 3))
+			else if (strlen(name) == 3 && !strncmp(name, "off", 3))
 				clear_opt(sbi, BG_GC);
 			else {
 				kfree(name);
-- 
1.7.9.5


