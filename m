Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab3LKGM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:12:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47066 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKGM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:12:27 -0500
Message-ID: <52A80210.7060907@huawei.com>
Date: Wed, 11 Dec 2013 14:11:28 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <zohar@us.ibm.com>, <d.kasatkin@samsung.com>, <james.l.morris@oracle.com>,
        <zohar@linux.vnet.ibm.com>, <roberto.sassu@polito.it>
CC: <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] security: ima: new helper: file_inode(file)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
---
 security/integrity/ima/ima_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c38bbce..6d76d4a 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -132,7 +132,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 		       const char *op, const char *cause)
 {
 	struct ima_template_entry *entry;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file_inode(file);
 	int violation = 1;
 	int result;

-- 
1.8.2.2

