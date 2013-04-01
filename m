Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab3DAG6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:58:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45882 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab3DAG5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:57:01 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-a3-51592fb9d897
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 7/9] f2fs: allocate remained free segments in the LFS mode
Date: Mon, 01 Apr 2013 15:55:58 +0900
Message-id: <1364799360-23145-7-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zfd2d+pGBBqcWKVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH84gXGgkvcFXsm
	3mduYDzO2cXIySEhYCLx7NwCNghbTOLCvfVANheHkMAyRomm47fZYIpenv0GlVjEKHF5yTZm
	CKeNSWLFhfvsXYwcHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQGqEBbwkZjz3A6lh
	EVCV+PS+kwnE5hVwl1i58iQLxDJdidX/n7OD2JwCHhKf2z6CxYWAak7tWw110Hc2iXO3TSHm
	CEh8m3wIbLyEgKzEpgPMECWSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7u
	JkZIwPbvYLx7wPoQYzLQuInMUqLJ+cCAzyuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD4wnTFwavZxgYS/1ncjYpjV/ErXdiLn+2SsCVeU+b9WJW
	plRM9HK2KQhWiDmrVVi69o6mh4fa9h92njIS6Yw7/1suUd6iwh9cwdNWKiJzaWPguoOfyplF
	HN996F7QvuiEEd/3R7nyKo8ir5tMKxO807f+ygVeuacx5v8Do7+fMD260WLrp2+2SizFGYmG
	WsxFxYkAyMOFBW4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd2d+pGBBp0rZC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4fvECY8El7oo9E+8zNzAe5+xi5OSQEDCReHn2GxuELSZx4d56IJuLQ0hg
	EaPE5SXbmCGcNiaJFRfus3cxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwGpERbw
	kpjx3A+khkVAVeLT+04mEJtXwF1i5cqTLBDLdCVW/3/ODmJzCnhIfG77CBYXAqo5tW812wRG
	3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiPimfQOxlUNFocYBTgYlXh4Iy5EBAqx
	JpYVV+YeYpTgYFYS4fX5BhTiTUmsrEotyo8vKs1JLT7EmAx01URmKdHkfGC05pXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD4+JP3VYK5e/kn00LiXJPWmzX
	pPP1LIOCyArzSZeflb1337OB/fG8WqP+w7GBd3W3ur24zyVz5KXIlQvXApPmmT88zH+8TT4k
	w/dkz/ynOf0RN3Wn7LlTk59stf15J6doc+jnY7Mm3uG29dCYUfLS6tme1bWO4p7l0lURNtf2
	x4Q2cy7JfFXSrsRSnJFoqMVcVJwIAHuTb+bMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new condition that allocates free segments in the current
active section even if SSR is needed.
Otherwise, f2fs cannot allocate remained free segments in the section since
SSR finds dirty segments only.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d5244f6..fe520d3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -347,6 +347,17 @@ next:
 	return NULL_SEGNO;
 }
 
+static int is_next_segment_free(struct f2fs_sb_info *sbi, int type)
+{
+	struct curseg_info *curseg = CURSEG_I(sbi, type);
+	unsigned int segno = curseg->segno;
+	struct free_segmap_info *free_i = FREE_I(sbi);
+
+	if (segno + 1 < TOTAL_SEGS(sbi) && (segno + 1) % sbi->segs_per_sec)
+		return !test_bit(segno + 1, free_i->free_segmap);
+	return 0;
+}
+
 /*
  * Find a new segment from the free segments bitmap to right order
  * This function should be returned with success, otherwise BUG
@@ -580,6 +591,8 @@ static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
 		change_curseg(sbi, type, false);
 	else if (type == CURSEG_WARM_NODE)
 		new_curseg(sbi, type, false);
+	else if (curseg->alloc_type == LFS && is_next_segment_free(sbi, type))
+		new_curseg(sbi, type, false);
 	else if (need_SSR(sbi) && get_ssr_segment(sbi, type))
 		change_curseg(sbi, type, true);
 	else
-- 
1.8.1.3.566.gaa39828

