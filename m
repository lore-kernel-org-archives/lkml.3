Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3L2Vvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:51:54 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61815 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab3L2Vvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:52 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832523"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/25]  fix error return code
Date: Sun, 29 Dec 2013 23:47:18 +0100
Message-Id: <1388357260-4843-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The rest of the function uses ret to store the return value, even setting
ret to i a few lines before this, so return ret instead of i.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/media/usb/dvb-usb-v2/ec168.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/ec168.c b/drivers/media/usb/dvb-usb-v2/ec168.c
index 5c68f39..0c2b377 100644
--- a/drivers/media/usb/dvb-usb-v2/ec168.c
+++ b/drivers/media/usb/dvb-usb-v2/ec168.c
@@ -170,7 +170,7 @@ static int ec168_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 error:
 	mutex_unlock(&d->i2c_mutex);
-	return i;
+	return ret;
 }
 
 static u32 ec168_i2c_func(struct i2c_adapter *adapter)

