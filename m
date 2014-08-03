Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaHCCiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 22:38:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36617 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaHCCiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 22:38:23 -0400
Message-ID: <1407033498.17812.4.camel@phoenix>
Subject: [PATCH 2/2] gpu: ipu-v3: Return proper error on
 ipu_add_client_devices error path
From: Axel Lin <axel.lin@ingics.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 03 Aug 2014 10:38:18 +0800
In-Reply-To: <1407033419.17812.2.camel@phoenix>
References: <1407033419.17812.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpu/ipu-v3/ipu-common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 04e7b2e..e340beb 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1116,8 +1116,10 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 				id++, &reg->pdata, sizeof(reg->pdata));
 		}
 
-		if (IS_ERR(pdev))
+		if (IS_ERR(pdev)) {
+			ret = PTR_ERR(pdev);
 			goto err_register;
+		}
 	}
 
 	return 0;
-- 
1.9.1



