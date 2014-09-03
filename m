Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbaICHXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:23:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22683 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbaICHX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:28 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f9-5406c1ee1e27
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 8/8] ima: initialize only required template
Date: Wed, 03 Sep 2014 10:20:01 +0300
Message-id: <ee009655866311106c98cdf87371d52f242782af.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Vd13B9lCDH7eMba49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBmLbrxnK/jLXfFgIlcD4yvOLkZODgkBE4mjB98yQ9hiEhfurWfrYuTiEBJY
	yijR9e0cO4TTySTR9PgkO0gVm4CexIbmH2C2iECOxKQzF8C6mQXSJT5N6gWLCwtYSzSsuckK
	YrMIqEr09b1jA7F5BeIkTl98wwKxTU7i5LHJQDUcHJwCVhLzjmqBhIUELCXary5jxCE8gZF/
	ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQoPu6g3HpMatDjAIcjEo8vBGCbCFCrIll
	xZW5hxglOJiVRHh9E4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGFdWeveEX7Y/u1J4e42p3MlF
	FXG7q5W/+W+xOxySbfMgI+m/wjZp/oaFNiyMOcpSpdoajAbbjRXCc1LcH/P69l3acHv2h/hJ
	LTKFCudq9zblMz/9y/o6yMFwVuXx6P6vSx80cKWcZ67yXXjJ1unOe5nXn+Ki9ysKPu554+W5
	UI/7Eke7jPptJZbijERDLeai4kQAt3RZIBgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA uses only one template. This patch initializes only required
template to avoid unnecessary memory allocations.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_template.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index f682606..e854862 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -152,24 +152,6 @@ out:
 	return result;
 }
 
-static int __init init_defined_templates(void)
-{
-	int i = 0;
-	int result = 0;
-
-	/* Init defined templates. */
-	for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
-		struct ima_template_desc *template = &defined_templates[i];
-
-		result = template_desc_init_fields(template->fmt,
-						   &(template->fields),
-						   &(template->num_fields));
-		if (result < 0)
-			return result;
-	}
-	return result;
-}
-
 struct ima_template_desc *ima_template_desc_current(void)
 {
 	if (!ima_template)
@@ -180,11 +162,9 @@ struct ima_template_desc *ima_template_desc_current(void)
 
 int __init ima_init_template(void)
 {
-	int result;
-
-	result = init_defined_templates();
-	if (result < 0)
-		return result;
+	struct ima_template_desc *template = ima_template_desc_current();
 
-	return 0;
+	return template_desc_init_fields(template->fmt,
+					 &(template->fields),
+					 &(template->num_fields));
 }
-- 
1.9.1

