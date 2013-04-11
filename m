Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227Ab3DKCFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:05:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18883 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3DKCFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:05:20 -0400
X-AuditID: cbfee690-b7f656d0000007e3-15-51661a5ff69c
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Steven Whitehouse'" <swhiteho@redhat.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] GFS2: Fix unlock of fcntl locks during withdrawn
 state
Date: Thu, 11 Apr 2013 11:05:18 +0900
Message-id: <000601ce3659$042adbf0$0c8093d0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAtXBJYACaKDZQAAM/m2AAACAc8A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zY914qbRAgwWn+SyWNHNbXN41h81i
	wcZHjBa/WpvZHVg83u+7yubRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGRsu/2MtaOeqWNm/
	l6WBcQFHFyMnh4SAiUTTjmnsELaYxIV769m6GLk4hASWMUpcWP+OHabo7OYtTBCJRYwSnZf6
	oKr+MkrsatjIClLFJqArcWz9FjBbRMBb4tSUX8wgNrOAq8SSX3uA4hxADdwSq5uDQMKcAjwS
	6/50gpUIC4RIvNj/iwXEZhFQlZjQ/YgRxOYVsJO4+GozO4QtKPFj8j0WiJFaEut3HmeCsOUl
	Nq95ywwyXkJAXeLRX12ICyIk/l2ewgZRIiKx78U7RpCTJQQOsUtM/fuPGWKXgMS3yYdYIHpl
	JTYdYIb4V1Li4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS9
	5PzcTYyQSJywg/HeAetDjMlA6ycyS4km5wMjOa8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60Ah
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjLHNpUsvdDrzxi3ZEbDjzZyJx3gl7vL2cbC8rVef
	vGT5N+YvzQdsNWWPdt75+35GvPzJ/5PStm3M7pPZEB4Xu+3IK6XGRVXpp8Ra1+T/7VZOMBFJ
	0pI53CTQ75diVH/txZSOp9/yXxwynKBxcNek866npCNjV8efvFw4j09twdQZ8gnZj3beLVBi
	Kc5INNRiLipOBAAZuKET2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd14qbRAg09N3BZLmrktLu+aw2ax
	YOMjRotfrc3sDiwe7/ddZfPo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4
	UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoG1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMI6xowNl/+xFrRzVazs38vSwLiAo4uRk0NCwETi7OYtTBC2mMSFe+vZuhi5OIQE
	FjFKdF7qg3L+MkrsatjIClLFJqArcWz9FjBbRMBb4tSUX8wgNrOAq8SSX3uA4hxADdwSq5uD
	QMKcAjwS6/50gpUIC4RIvNj/iwXEZhFQlZjQ/YgRxOYVsJO4+GozO4QtKPFj8j0WiJFaEut3
	HmeCsOUlNq95ywwyXkJAXeLRX12ICyIk/l2ewgZRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZ
	wMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4zp9J7WBc2WBxiFGAg1GJh/dEQ2qgEGti
	WXFl7iFGCQ5mJRFerp1AId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HpqC8knhDYxMzI0sj
	MwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamBMsT2++JHLrStdNRu38TPUC+oE
	7qsXkFssZWg+X+GF5qyCtSJPVfbJsBWuOhE+I7Ly1exSPmfPYnd9/vOZNhs/veiYwCcWdO1f
	yK7wJiveCad35j/vdPmz52DdAt9J33/ovVizeZfnn0Usyh5ui1bd2WV1qZ+/JPhC7vZJnY1P
	Mr5d3hz9N2+iEktxRqKhFnNRcSIAH40r4TcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Steven Whitehouse <swhiteho@redhat.com>"

commit c2952d202f710d326ac36a8ea6bd216b20615ec8 upstream

When withdraw occurs, we need to continue to allow unlocks of fcntl
locks to occur, however these will only be local, since the node has
withdrawn from the cluster. This prevents triggering a VFS level
bug trap due to locks remaining when a file is closed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 fs/gfs2/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 991ab2d..7af426b 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -924,8 +924,11 @@ static int gfs2_lock(struct file *file, int cmd, struct
file_lock *fl)
 		cmd = F_SETLK;
 		fl->fl_type = F_UNLCK;
 	}
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
+		if (fl->fl_type == F_UNLCK)
+			posix_lock_file_wait(file, fl);
 		return -EIO;
+	}
 	if (IS_GETLK(cmd))
 		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
 	else if (fl->fl_type == F_UNLCK)
-- 
1.7.9.5

