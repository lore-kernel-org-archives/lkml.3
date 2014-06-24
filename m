Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaFXGOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:14:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25736 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaFXGOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:14:07 -0400
X-AuditID: cbfee61a-f79e46d00000134f-48-53a9172b3a7a
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] f2fs: release new entry page correctly in error path of
 f2fs_rename
Date: Tue, 24 Jun 2014 14:13:13 +0800
Message-id: <001601cf8f73$7f4e4280$7deac780$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+PcRYH1pv4DLW5SeOgIDtcEPDppQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jAV0d8ZXBBps/sVhc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	OzadYS9oZK34c/UXUwNjF0sXIweHhICJRNM65y5GTiBTTOLCvfVsILaQwCJGiV/35LoYuYDs
	H4wS869NYARJsAmoSCzv+M8EYosIeElM2n+CBcRmFsiUuNc0gxnEFhaIkuh9/wRsEIuAqsTH
	I5vBenkFLCVmHFrAAmELSvyYfA+qV0ti/c7jTBC2vMTmNW+ZIQ5SkNhx9jUjyJ0iAnoSkyfY
	Q5SIS2w8cotlAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CA7sZ1I7GFc2WBxiFOBgVOLhZfBfESzEmlhWXJl7iFGCg1lJhNfyC1CINyWxsiq1KD++qDQn
	tfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDI59Ruefnf1XLA24qqlxQvc7492bb
	gtAe+3yurqT7izUF91qovbujN01SWjz0i/dTl7WvedxmTFeyvrmSR39ug9Bftw08Vxe1u079
	L7/uVPXyH8Wr1l2c9Gb1lO1ccziOfBKJqwiR+vOhLG+G6pnssK8FwgFHJObsC+wym3F2fq09
	V9z0TcExnUosxRmJhlrMRcWJAFV8IX5oAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch correct releasing code of new_page to avoid BUG_ON in error patch of
f2fs_rename.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 0d55517..f17e34c 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -475,7 +475,8 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return 0;
 
 put_out_dir:
-	f2fs_put_page(new_page, 1);
+	kunmap(new_page);
+	f2fs_put_page(new_page, 0);
 out_dir:
 	if (old_dir_entry) {
 		kunmap(old_dir_page);
-- 
1.7.9.5


