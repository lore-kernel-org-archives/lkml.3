Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3J2GSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:18:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3J2GSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:18:51 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-cc-526f5349f358
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: fix calculating incorrect free size when
 update xattr in __f2fs_setxattr
Date: Tue, 29 Oct 2013 14:17:05 +0800
Message-id: <001e01ced46e$b9f538f0$2ddfaad0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7UblyR3d8bDuxKQACDYNRcP/qO2w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jQV3P4Pwgg5UfdS2u7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY+VL8YIO
	tortr08wNjA+YOli5OSQEDCRWDR7EjOELSZx4d56ti5GLg4hgemMEn3/GlggnB+MEl0NF1lB
	qtgEVCSWd/xnArFFBBQlNrzfwA5iMwvMYJR43CfRxcjBISyQI/F1iQFImEVAVeLTn4uMIDav
	gKXEwuOHWCFsQYkfk++xQLRqSPQv2sAGYctLbF7zFuogBYkdZ18zgowUEdCTuLI3D6JEXGLj
	kVssExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnA4P5Pe
	wbiqweIQowAHoxIPrwVbfpAQa2JZcWXuIUYJDmYlEd79m/OChHhTEiurUovy44tKc1KLDzFK
	c7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTByrJx77TPP8affH8genb6OQ5Nn4i+/Vo7A
	tdlCCx/cL2d/97hj7cyKV48OO3w5+X23bNaOKtVPpYEP1izW2fHOXHS6EPu5JbYlIXLMvSdV
	urPjvqzt81/5aN/V3Zsi3QQc9zddOxRVyv9DtDb6V+wVW/GHKduSpQp9jpwW9P21t+vny4sB
	RWkvlFiKMxINtZiLihMBBL2LtGMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During xattr updating, free size should be corrected to remainder free size
+ old entry size.
It can avoid ENOSPC error when we update old entry with the same size new
entry at fully filled xattr.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index f685138..35eb478 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -520,7 +520,7 @@ static int __f2fs_setxattr(struct inode *inode, int
name_index,
 		 */
 		free = MIN_OFFSET(inode) - ((char *)last - (char
*)base_addr);
 		if (found)
-			free = free - ENTRY_SIZE(here);
+			free = free + ENTRY_SIZE(here);
 
 		if (free < newsize) {
 			error = -ENOSPC;
-- 
1.7.9.5

