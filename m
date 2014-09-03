Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbaICHXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:23:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22669 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaICHXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:20 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e6-5406c1e62f2c
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 3/8] ima: simplify conditional statement to improve performance
Date: Wed, 03 Sep 2014 10:19:56 +0300
Message-id: <0e28e9a1e1bd839f7d551052b33bba6f266bd749.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Vd1nB9lCDPYe17K49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBnnzyoXvGOv6H6Q1MB4ga2LkZNDQsBEYvnN26wQtpjEhXvrgeJcHEICSxkl
	nj+9zgrhdDJJ3Pp1mQWkik1AT2JD8w92EFtEIEdi0pkLzCA2s0C6xKdJvWBxYQF/iWs/3zOB
	2CwCqhIvT10D28YrECfxd/pvqM1yEiePTQZawMHBKWAlMe+oFkhYSMBSov3qMkYcwhMY+Rcw
	MqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAm5LzsYFx+zOsQowMGoxMNboMYWIsSaWFZc
	mXuIUYKDWUmE1zcRKMSbklhZlVqUH19UmpNafIiRiYNTqoGRbYZNy1HBwmd/zFnFePSeT39Z
	ccTDJ2GeRIxST9rrNst8ddWvPCW+bPGcO5U//wucPD9OLvujjYwNy/2vagv3XBFUsBWtupWi
	srpxCovsz97wHzx1ggK1IQJTFmboqXElW1+fFbT2d7hseE/R1e66l2mxWSnHFq3fFHSe92XB
	Rsurr9oz3JRYijMSDbWYi4oTAbsPKW8XAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precede bit testing before string comparison makes code
faster. Also refactor statement as a single line pointer
assignment.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index f82cf9b..f7b85bf 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -206,10 +206,8 @@ static int process_measurement(struct file *file, const char *filename,
 	}
 
 	template_desc = ima_template_desc_current();
-	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
-		if (action & IMA_APPRAISE_SUBMASK)
-			xattr_ptr = &xattr_value;
-	} else
+	if ((action & IMA_APPRAISE_SUBMASK) ||
+		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
 		xattr_ptr = &xattr_value;
 
 	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);
-- 
1.9.1

