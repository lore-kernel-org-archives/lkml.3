Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3KFBNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:13:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56956 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3KFBNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:13:11 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-a8-527997a541ac
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: avoid to use a NULL point in
 destroy_segment_manager
Date: Wed, 06 Nov 2013 09:12:04 +0800
Message-id: <000001ceda8d$5b185bd0$11491370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7ai9d7ldkLUJU9T+ma4ZCP42i6Hg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd2l0yuDDGatUbG4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujHPfVrEW
	zGOtOPz7MXsD4zqWLkZODgkBE4k9U2czQ9hiEhfurWfrYuTiEBJYxCgxbeYEVpCEkMAPRolf
	7SIgNpuAisTyjv9MILaIgKLEhvcb2EEamAVmMEocnvsPrEFYIEJi4aOH7CA2i4CqxOLpTWAN
	vAKWEhvbd7JB2IISPybfA7uCWUBDon/RBjYIW15i85q3UBcpSOw4+5oRYpmexPf2w0wQNeIS
	G4/cYpnAKDALyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCg/qZ
	9A7GVQ0WhxgFOBiVeHgT5CuDhFgTy4orcw8xSnAwK4nwKsUBhXhTEiurUovy44tKc1KLDzFK
	c7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTCuzv1Qu+b1k9nz+o/5Kl9xT/y2/4CwpdtB
	7gtqWwor4h0rK70iNHWLXAWPrT+lUXDmsm74N6+H4oe//D2kfDFpezs7/7nz8pXPLtz9ePzo
	4Sknmk79sVX8s3Z9fNGjWY/apgmfUZ7QMn+SK3dLTVh6kKTqVcuVeWtF+t/Ou8XBseDbQa+k
	TPYmJZbijERDLeai4kQAM7Sgk2YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A NULL point should avoid to be used in destroy_segment_manager after allocating memory fail for f2fs_sm_info.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3d4d5fc..ff363e6
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1744,6 +1744,8 @@ static void destroy_sit_info(struct f2fs_sb_info *sbi)
 void destroy_segment_manager(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
+	if (!sm_info)
+		return;
 	destroy_dirty_segmap(sbi);
 	destroy_curseg(sbi);
 	destroy_free_segmap(sbi);
-- 
1.7.9.5

