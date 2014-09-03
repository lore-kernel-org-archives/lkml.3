Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaICHYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:24:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22683 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaICHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:25 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e8-5406c1ebc98f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 5/8] ima: add missing '__init' keywords
Date: Wed, 03 Sep 2014 10:19:58 +0300
Message-id: <d867d0c80076e9f79279e29a3b7fa8c7ba0ea66c.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e/4Vd3XB9lCDDbv4La49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBkLnxxnL2jkq1izfiJ7A+NT7i5GTg4JAROJ3qabzBC2mMSFe+vZuhi5OIQE
	ljJKvP27ihnC6WSS2DL7KiNIFZuAnsSG5h/sILaIQI7EpDMXwLqZBdIlPk3qBYsLC5hLHDjU
	xgJiswioSmycegashlcgTuLT7IVQ2+QkTh6bzNrFyMHBKWAlMe+oFkhYSMBSov3qMkYcwhMY
	+RcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAm7rzsYlx6zOsQowMGoxMMbIcgWIsSa
	WFZcmXuIUYKDWUmE1zcRKMSbklhZlVqUH19UmpNafIiRiYNTqoFx9afjXwOTnq8tiX7sfEJC
	dR2r4fGH13+2W5Uums2rX/Bz5teOb1sZvb0ZFNwZPEoq53P6evRrP6wpbA5QncHsY/Je0/9X
	C19gPRebddqTrPAl76cycdnKWpXvn3jxjXbsx7siafXiapuWPZN45Gt7JS1j0ds+l5fhXsGb
	e5h0JY/t7UrQj1BiKc5INNRiLipOBAB7ZG9kGQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing keywords to the function definition to cleanup
to discard initialization code.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima.h          | 2 --
 security/integrity/ima/ima_crypto.c   | 2 +-
 security/integrity/ima/ima_template.c | 4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index c6990a7..8e4bb88 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -107,8 +107,6 @@ void ima_print_digest(struct seq_file *m, u8 *digest, int size);
 struct ima_template_desc *ima_template_desc_current(void);
 int ima_init_template(void);
 
-int ima_init_template(void);
-
 /*
  * used to protect h_table and sha_table
  */
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 3b26472..d34e7df 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -97,7 +97,7 @@ static int ima_kernel_read(struct file *file, loff_t offset,
 	return ret;
 }
 
-int ima_init_crypto(void)
+int __init ima_init_crypto(void)
 {
 	long rc;
 
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index a076a96..f682606 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -152,7 +152,7 @@ out:
 	return result;
 }
 
-static int init_defined_templates(void)
+static int __init init_defined_templates(void)
 {
 	int i = 0;
 	int result = 0;
@@ -178,7 +178,7 @@ struct ima_template_desc *ima_template_desc_current(void)
 	return ima_template;
 }
 
-int ima_init_template(void)
+int __init ima_init_template(void)
 {
 	int result;
 
-- 
1.9.1

