Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaBSHOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:14:02 -0500
Received: from SMTPBG254.QQ.COM ([183.60.52.96]:51509 "HELO smtpbg254.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751178AbaBSHOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:14:00 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 02:13:59 EST
X-QQ-SSF: 00000000000000F000000000000000J
X-HAS-ATTACH: no
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 162.105.192.76
X-QQ-STYLE: 
X-QQ-mid: webmail688t1392793575t8618279
From: "=?utf-8?B?WXVhbiBQZW5nZmVp?=" <coolypf@qq.com>
To: "=?utf-8?B?UGV0ZXIgT2JlcnBhcmxlaXRlcg==?=" 
	<oberpar@linux.vnet.ibm.com>
Cc: "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: [PATCH] gcov: fix memory allocation problem in gcov_info_dup
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Date: Wed, 19 Feb 2014 15:06:15 +0800
X-Priority: 3
Message-ID: <tencent_074552B42B4D25D2329613D8@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-SENDSIZE: 520
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1J7E9fQ003451

From: Yuan Pengfei <coolypf@qq.com>

If -fprofile-values option is used, ctr->num and sci_ptr->num
may be zero, resulting in zero size and cv_size, which will
cause ENOMEM when opening gcov data files in debugfs.
Signed-off-by: Yuan Pengfei <coolypf@qq.com>
---
 kernel/gcov/gcc_3_4.c | 2 +-
 kernel/gcov/gcc_4_7.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/gcov/gcc_3_4.c b/kernel/gcov/gcc_3_4.c
index 27bc88a..1c1f425 100644
--- a/kernel/gcov/gcc_3_4.c
+++ b/kernel/gcov/gcc_3_4.c
@@ -269,7 +269,7 @@ struct gcov_info *gcov_info_dup(struct gcov_info *info)
 		dup->counts[i].num = ctr->num;
 		dup->counts[i].merge = ctr->merge;
 		dup->counts[i].values = vmalloc(size);
-		if (!dup->counts[i].values)
+		if (size && !dup->counts[i].values)
 			goto err_free;
 		memcpy(dup->counts[i].values, ctr->values, size);
 	}
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index 2c6e463..7465944 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -290,7 +290,7 @@ struct gcov_info *gcov_info_dup(struct gcov_info *info)
 
 			dci_ptr->values = vmalloc(cv_size);
 
-			if (!dci_ptr->values)
+			if (cv_size && !dci_ptr->values)
 				goto err_free;
 
 			dci_ptr->num = sci_ptr->num;
-- 
1.8.5.3ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
