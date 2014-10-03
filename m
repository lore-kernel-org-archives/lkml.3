Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaJCLkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:40:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60584 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaJCLk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:40:26 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-34-542e8b28033f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 1/4] ima: report policy load status
Date: Fri, 03 Oct 2014 14:40:18 +0300
Message-id: <96575e3e010e5911c7f94315369b558a15be9912.1412336062.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4VV2Nbr0QgzczmSxu/d3LbPFlaZ3F
	yxnz2C0u75rDZvGh5xGbxacVk5gd2Dx2zrrL7vHg0GYWj90LPjN59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aFh7IFc9grTmyUaWBsYuti5OSQEDCRaN11GcoWk7hwbz2YLSSwlFHiyGmB
	LkYuILuTSWLlhk0sIAk2AT2JDc0/2EFsEYEciUlnLjCD2MwC6RKfJvWCxYUFzCQmXtkIVs8i
	oCrxcP5ysBpegTiJruvHWSGWyUmcPDYZyObg4BSwkljX5w+x11Ki8+oDNhzCExj5FzAyrGIU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQICbgvOxgXH7M6xCjAwajEw/vxhm6IEGtiWXFl7iFG
	CQ5mJRFe6Sa9ECHelMTKqtSi/Pii0pzU4kOMTBycUg2M5XErlzafM52+xKufP/x87LNj9VEf
	Y68yRpzonPEg70JjTev/9pvWTNnJf9f+c/zvcv+ZxONFHaY9mgssnHLa2QSyT7/rnJNXUMPZ
	YpmuI/qVMc3ah29hxI6GadnWm/Xqp9nVTVAOkFY+8unkfl45AaknBsrK6/T/hm97rnVDnK9F
	XWNx5D0lluKMREMt5qLiRAB39p6UFgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audit messages are rate limited and often policy update info
is not visible. Report policy loading status also using pr_info.

Changes in v2:
* reporting moved to ima_release_policy to notice parsing errors
* reporting both completed and failed status

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index da92fcc..16d8527 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -311,6 +311,8 @@ static int ima_open_policy(struct inode *inode, struct file *filp)
  */
 static int ima_release_policy(struct inode *inode, struct file *file)
 {
+	pr_info("IMA: policy update %s\n",
+		valid_policy ? "completed" : "failed");
 	if (!valid_policy) {
 		ima_delete_rules();
 		valid_policy = 1;
-- 
1.9.1

