Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3K1Hmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:42:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36372 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3K1Hmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:42:35 -0500
X-AuditID: cbfee61a-b7f316d000007e34-3e-5296f3e9a802
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 1/5] f2fs: correct type of wait in struct bio_private
Date: Thu, 28 Nov 2013 15:41:39 +0800
Message-id: <003201ceec0d$64b4e5f0$2e1eb1d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7sDD2+vS0KiaDaQCWWCeGxiG51mw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQd2Xn6cFGew9oGdxfddfJotLi9wt
	9uw9yWJxedccNovWheeZHVg9di/4zOTRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGZO/PmIp
	WMlc0f7/KFMD40WmLkZODgkBE4l/q+4yQ9hiEhfurWfrYuTiEBKYzijx9shPdgjnB6PEnXtz
	warYBFQklnf8B+sWEVCU2PB+A1gRs8AMRonDc/+xgiSEBQIkPk7fwQ5iswioSnzecxasgVfA
	UuLPv3VsELagxI/J91hAbGYBDYn+RRvYIGx5ic1r3kKdpCCx4+xrRohlehLPmiezQ9SIS2w8
	cotlAqPALCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7rZ1I7
	GFc2WBxiFOBgVOLhldCZFiTEmlhWXJl7iFGCg1lJhFehGCjEm5JYWZValB9fVJqTWnyIUZqD
	RUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBcdPt6efOBoj5X3i14LHhI3X9w2desQY6yvo/
	E123b5XXhXS2iAbdpxprOzIzdNZYxE349+3ikTtL+auMmATeCvMcme3YOz1v35v0VWrnOFP/
	KTbM2uu8u+Dh673Lzx0VclOWPXmD8UHQ/2upkY6uR1VPTb4lM+//Iu2tx9QuWr79PHtq9KIP
	KgeVWIozEg21mIuKEwF8tqZsZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index b84dd23..5f733ec 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -96,7 +96,7 @@
 struct bio_private {
 	struct f2fs_sb_info *sbi;
 	bool is_sync;
-	void *wait;
+	struct completion *wait;
 };
 
 /*
-- 
1.7.9.5

