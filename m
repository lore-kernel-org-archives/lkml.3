Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3KXE4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 23:56:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44940 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3KXE4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 23:56:15 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-a2-529186ed3049
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: avoid lock debugging overhead
Date: Sun, 24 Nov 2013 13:55:17 +0900
Message-id: <1385268917-13853-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zA923bRODDM42yFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTHr9DbWgoPsFefu
	XWdrYFzJ1sXIwSEhYCIx511yFyMnkCkmceHeejYQW0hgGaPEtF3hEHETieO9L5i6GLmA4tMZ
	JVac/soC4TQzSZw8e4wZZBCbgLbE5v0GIA0iAswSC6aeZwSpYRaYwCjxf9F7FpCEMNCkpceP
	sIPYLAKqElfb5oFt4xVwl9g97w0TxDZtiW3PJzJC2LfZJDYezIaoF5D4NvkQC8TRshKbDjBD
	lEhKHFxxg2UCo+ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCHh17eD8eYB60OMyUDj
	JjJLiSbnA8M3ryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUwJnzdt7qj46f6gWTtA6edV5X0P+pS+njb7NbX+zyJCva6UjLm107fFFjTemPrQvEG
	+1OTH1Sv3MYjE1r7x/5q+h//heyXxZRF6nrmuxzhjas7dHD76RssmrdCWdrlXefk7rx1tjG1
	/bnkQ/7GuYtT2Srq5sjWT/y98ceeYtXgj3f+TvyzcabvJCWW4oxEQy3mouJEANePLbBVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd23bRODDD7MkrS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFj1ultrAUH2SvO3bvO1sC4kq2LkZNDQsBE4njvCyYIW0ziwr31QHEuDiGB
	6YwSK05/ZYFwmpkkTp49xtzFyMHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0ngUkIQw0
	denxI+wgNouAqsTVtnlg23gF3CV2z3sDtU1bYtvziYwTGLkXMDKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAgO8WfSOxhXNVgcYhTgYFTi4W10nBgkxJpYVlyZe4hRgoNZSYTXuxUoxJuS
	WFmVWpQfX1Sak1p8iDEZaPtEZinR5Hxg/OWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9
	sSQ1OzW1ILUIZgsTB6dUA2Ot3xu36xmpSoz8SaFSk/wXpMkJN/H9f33wEOujMDGjxKNm+d5t
	207kO2lxlb1uszh9YuPcW/qfnh3z9+28vaH72qPF5w6cYM5YkqneaXvy/lrH9qCAquR/CY/r
	L9ZM7GHPt5IKcWLqE32S8rHkcLvLL4Z2lYO/Li5Wr4xM39v9dOWKE3pLK5VYijMSDbWYi4oT
	AVL+rXO1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_F2FS_CHECK_FS is unset, we don't need to add any debugging overhead.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 72718ef..417280a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -22,8 +22,10 @@
 
 #ifdef CONFIG_F2FS_CHECK_FS
 #define f2fs_bug_on(condition)	BUG_ON(condition)
+#define f2fs_down_write(x, y)	down_write_nest_lock(x, y)
 #else
 #define f2fs_bug_on(condition)
+#define f2fs_down_write(x, y)	down_write(x)
 #endif
 
 /*
@@ -556,7 +558,7 @@ static inline void f2fs_unlock_op(struct f2fs_sb_info *sbi)
 
 static inline void f2fs_lock_all(struct f2fs_sb_info *sbi)
 {
-	down_write_nest_lock(&sbi->cp_rwsem, &sbi->cp_mutex);
+	f2fs_down_write(&sbi->cp_rwsem, &sbi->cp_mutex);
 }
 
 static inline void f2fs_unlock_all(struct f2fs_sb_info *sbi)
-- 
1.8.4.474.g128a96c

