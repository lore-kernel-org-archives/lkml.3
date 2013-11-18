Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3KRJNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:13:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36873 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3KRJM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:12:56 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-cb-5289da1776ec
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: clean up the do_submit_bio flow
Date: Mon, 18 Nov 2013 18:12:01 +0900
Message-id: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zY13xW51BBj+uiVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXF9xRzmglbBilNX
	77I2MB7j7WLk5JAQMJG4/HonG4QtJnHh3nogm4tDSGAZo0Tz9G9ADgdY0bTFRhDxRYwSH5ds
	BGsQEmhmkjjWlg1SwyagLbF5vwFIWESAWWLB1POMIPXMAhMYJf4ves8CkhAWsJJY9eAHK4jN
	IqAqMflZJyNIL6+Au8SUJ+EQN2hLbHs+EaxXQuAxm8THQ5fZIeoFJL5NPsQCcY+sxKYDzBD1
	khIHV9xgmcAouICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSPhN2MF474D1IcZkoHET
	maVEk/OB4ZtXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYxF26xOv1c7yLBpaeSqovXT1brvL/4bPSXojadReZ2Yx1aBwyV28SeMUzRc72hbeU+P
	E3L4t+ndi3l7Dj01nFVjdGVeXnm+uc+PItt5gvtD715cZxX8Zt5xwfLU1qtCRZ2i24I1/Zsm
	381d3yni1GhcMeHctBSmVYw7t/968GhGe9y/W5Ibfk5VYinOSDTUYi4qTgQAaM3xXFUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAV3xW51BBgv2Cltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxfcUc5oJWwYpTV++yNjAe4+1i5OCQEDCRmLbYqIuRE8gUk7hwbz1bFyMX
	h5DAIkaJj0s2soEkhASamSSOtWWD1LMJaEts3m8AEhYRYJZYMPU8I0g9s8AERon/i96zgCSE
	BawkVj34wQpiswioSkx+1skI0ssr4C4x5Uk4xC5tiW3PJzJOYORewMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4uJ9J72Bc1WBxiFGAg1GJh1cjrDNIiDWxrLgy9xCjBAezkgjvihtA
	Id6UxMqq1KL8+KLSnNTiQ4zJQMsnMkuJJucDIy+vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhgDZjH9a1v2O8vvbUx3V5mPxG4Nea0uo3932vxTjSJr/JR/
	bJKxq3dUUcrz3vmr5bP4Bq737+dleZ/j9XwxXfA4c7B15dkXH8JvLZt27cBdo4rsVNUFa5uS
	nYOtnqlvCj10VfehyXH9SL3VJ+Ys4Dt27zcnv9tHvZn2faq+unEPNq/9fkT4RLwSS3FGoqEW
	c1FxIgD3NOY5sgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces PAGE_TYPE_OF_BIO() and cleans up do_submit_bio() with it.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/segment.c | 39 +++++++++++++++++++++------------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fe5c2fc..1c783fd 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -351,6 +351,7 @@ enum count_type {
  *			with waiting the bio's completion
  * ...			Only can be used with META.
  */
+#define PAGE_TYPE_OF_BIO(type)	(type) > META ? META : (type)
 enum page_type {
 	DATA,
 	NODE,
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1f83999..dad5f1a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -837,32 +837,35 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 				enum page_type type, bool sync)
 {
 	int rw = sync ? WRITE_SYNC : WRITE;
-	enum page_type btype = type > META ? META : type;
+	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+	struct bio *bio = sbi->bio[btype];
+	struct bio_private *p;
+
+	if (!bio)
+		return;
+
+	sbi->bio[btype] = NULL;
 
 	if (type >= META_FLUSH)
 		rw = WRITE_FLUSH_FUA;
-
 	if (btype == META)
 		rw |= REQ_META;
 
-	if (sbi->bio[btype]) {
-		struct bio_private *p = sbi->bio[btype]->bi_private;
-		p->sbi = sbi;
-		sbi->bio[btype]->bi_end_io = f2fs_end_io_write;
+	p = bio->bi_private;
+	p->sbi = sbi;
+	bio->bi_end_io = f2fs_end_io_write;
 
-		trace_f2fs_do_submit_bio(sbi->sb, btype, sync, sbi->bio[btype]);
+	trace_f2fs_do_submit_bio(sbi->sb, btype, sync, bio);
 
-		if (type == META_FLUSH) {
-			DECLARE_COMPLETION_ONSTACK(wait);
-			p->is_sync = true;
-			p->wait = &wait;
-			submit_bio(rw, sbi->bio[btype]);
-			wait_for_completion(&wait);
-		} else {
-			p->is_sync = false;
-			submit_bio(rw, sbi->bio[btype]);
-		}
-		sbi->bio[btype] = NULL;
+	if (type == META_FLUSH) {
+		DECLARE_COMPLETION_ONSTACK(wait);
+		p->is_sync = true;
+		p->wait = &wait;
+		submit_bio(rw, bio);
+		wait_for_completion(&wait);
+	} else {
+		p->is_sync = false;
+		submit_bio(rw, bio);
 	}
 }
 
-- 
1.8.4.474.g128a96c

