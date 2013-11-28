Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab3K1HpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:45:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58405 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab3K1HpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:45:02 -0500
X-AuditID: cbfee61b-b7f166d000007a34-47-5296f47de1cd
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 4/5] f2fs: check return value of f2fs_readpage in
 find_data_page
Date: Thu, 28 Nov 2013 15:43:43 +0800
Message-id: <003601ceec0d$bcc30330$36490990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7sDJ6+7T4Pprq1TsehLSudF45tug==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd3aL9OCDL61yllc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxuXGE6wF
	k1krvl91aGDsZeli5OSQEDCR2PLrKSuELSZx4d56ti5GLg4hgemMEr83nWAGSQgJ/GCU2LzI
	E8RmE1CRWN7xnwnEFhFQlNjwfgM7SAOzwAxGicNz/4FNEhaIlWhvuc8IYrMIqEp8XXEdbBCv
	gKXE1a7HTBC2oMSPyffArmAW0JDoX7SBDcKWl9i85i0zxEUKEjvOvmaEWKYnsajxNjNEjbjE
	xiO3WCYwCsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgkH4m
	vYNxVYPFIUYBDkYlHl4JnWlBQqyJZcWVuYcYJTiYlUR4FYqBQrwpiZVVqUX58UWlOanFhxil
	OViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhjrDS7mHo6XF7b0dTnDevlwE492+afwe6+7
	JdkOvs00v+m4qrz/vPl83yDvn/w1j5p5quZuOvZQpEdV82bWL1XLucZ5XzbViCvOORjy6o2j
	7f112af/7fybw9S83M+wr+iQy5x/yimn526QrcvOcuVhvvJG22ydwNlntkEGRy5HrJR6yXDo
	1iolluKMREMt5qLiRABsOJSsZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return error if we do not get an updated page in find_date_page
when f2fs_readpage failed.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2d02cf3..85071d6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -240,6 +240,9 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 
 	err = f2fs_readpage(sbi, page, dn.data_blkaddr,
 					sync ? READ_SYNC : READA);
+	if (err)
+		return ERR_PTR(err);
+
 	if (sync) {
 		wait_on_page_locked(page);
 		if (!PageUptodate(page)) {
-- 
1.7.9.5

