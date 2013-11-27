Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3K0AiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:38:24 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50143 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3K0AiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:38:21 -0500
MIME-Version: 1.0
Date: Wed, 27 Nov 2013 08:38:19 +0800
Message-ID: <CAPgLHd9goop9+JTbZE+WsDzeA4nV2DMngcznnLZyQ0XEa7pBJQ@mail.gmail.com>
Subject: [PATCH -next] staging: rts5208: fix error return code in rtsx_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, micky_ching@realsil.com.cn
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM instead of 0 when the memory alloc fail
in probe error handling path.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rts5208/rtsx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 7882f57..8586ac5 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -896,8 +896,10 @@ static int rtsx_probe(struct pci_dev *pci,
 	memset(dev, 0, sizeof(struct rtsx_dev));
 
 	dev->chip = kzalloc(sizeof(struct rtsx_chip), GFP_KERNEL);
-	if (dev->chip == NULL)
+	if (dev->chip == NULL) {
+		err = -ENOMEM;
 		goto errout;
+	}
 
 	spin_lock_init(&dev->reg_lock);
 	mutex_init(&(dev->dev_mutex));

