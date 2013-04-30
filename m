Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3D3FCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:02:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65313 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3D3FCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:02:01 -0400
X-AuditID: cbfee691-b7fe56d000004b96-e2-517f50475b9a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 6/7] watchdog: riowd: use devm_kzalloc()
Date: Tue, 30 Apr 2013 14:01:59 +0900
Message-id: <001301ce455f$d856f430$8904dc90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FX9eip45Ij1wQR9CTP8Hme6LiuA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zY133gPpAg4eN6hZz1q9hs7i88BKr
	xeVdc9gsbqzbx27xZOEZJotbM16wOrB5XNss5nFixm8Wj53fG9g9+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK+Pvg2uMBeu4Kppf3WdqYFzO0cXIySEhYCJxcP4SdghbTOLCvfVsXYxcHEIC
	yxglFn27zQxTtGzzbFaIxCJGiRlP28ESQgK/GCUefK8BsdkE1CS+fDkMNImDQ0RAX6KtRQOk
	nllgA6PEyf9/wTYIC1hLPH16jxXEZhFQlTj9bzIjSD2vgKXEtT5ZkDCvgKDEj8n3WEBsZgEt
	ifU7jzNB2PISm9e8hbpHQWLH2deMILaIgJ7EzgffGSFqRCT2vXjHCLJXQuASu8TPttVsELsE
	JL5NPsQCsktCQFZi0wGoOZISB1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpReZ
	6hUn5haX5qXrJefnbmKERODEHYz3D1gfYkwGWj+RWUo0OR8YwXkl8YbGZkYWpiamxkbmlmak
	CSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDzIGS8dwXSDbevPUCaNK8KFDZfX
	Luv24Vy9hP/U2XOZ3/Z7PeFdssrDVTODVTNZt2KScIFLF+tXDe5D17SrFQOvNvh2TvL/0xAb
	sXqK5e3fN1kuXGDlymcx5nIxqk7lPnOgIC79cda01FDtIwIp232Cwp5XG+vfE1Cv0nc6cTl7
	jTn7x3ZNJZbijERDLeai4kQAyK5u/tYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAV33gPpAg30blC3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMvw+uMRas46pofnWfqYFxOUcXIyeH
	hICJxLLNs1khbDGJC/fWs3UxcnEICSxilJjxtJ0ZJCEk8ItR4sH3GhCbTUBN4suXw+xdjBwc
	IgL6Em0tGiD1zAIbGCVO/v/LDlIjLGAt8fTpPbChLAKqEqf/TWYEqecVsJS41icLEuYVEJT4
	MfkeC4jNLKAlsX7ncSYIW15i85q3zBD3KEjsOPuaEcQWEdCT2PngOyNEjYjEvhfvGCcwCsxC
	MmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg+H4mvYNxVYPFIUYB
	DkYlHt4dS+oChVgTy4orcw8xSnAwK4nwRjvWBwrxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhy
	PjD15JXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo7jZYp9X
	z6OXBO6Q8ljOKxirZfe0MmgN5xXNvUtNt1xv/Fy8cMq8nGtaqRWiU+yf5ervTrV9WhEQ6Hiu
	8cN30feaN9dvWeIl3j7bN/tfUl7coo9/a63E1vMLX94/mTtxoXnlowMZJc3Vj35Nrrt0/88R
	9cTMBEsW+9+Lv8ReZ6+eFqKWtSY8VYmlOCPRUIu5qDgRAB05OZczAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/watchdog/riowd.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 0040451..13363ad 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -183,7 +183,7 @@ static int riowd_probe(struct platform_device *op)
 		goto out;
 
 	err = -ENOMEM;
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
 	if (!p)
 		goto out;
 
@@ -192,7 +192,7 @@ static int riowd_probe(struct platform_device *op)
 	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
 	if (!p->regs) {
 		pr_err("Cannot map registers\n");
-		goto out_free;
+		goto out;
 	}
 	/* Make miscdev useable right away */
 	riowd_device = p;
@@ -213,9 +213,6 @@ out_iounmap:
 	riowd_device = NULL;
 	of_iounmap(&op->resource[0], p->regs, 2);
 
-out_free:
-	kfree(p);
-
 out:
 	return err;
 }
@@ -226,7 +223,6 @@ static int riowd_remove(struct platform_device *op)
 
 	misc_deregister(&riowd_miscdev);
 	of_iounmap(&op->resource[0], p->regs, 2);
-	kfree(p);
 
 	return 0;
 }
-- 
1.7.2.5


