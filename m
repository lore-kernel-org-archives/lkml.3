Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaKDCZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:25:42 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37380 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaKDCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:37 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 22/27] musb: musb_dsps: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:29 +0530
Message-Id: <1415067694-9473-23-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
References: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>

Sanity check on resource happening with devm_ioremap_resource().

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/usb/musb/musb_dsps.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 48bc09e..965c552 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -447,9 +447,6 @@ static int dsps_musb_init(struct musb *musb)
 	int ret;
 
 	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
-	if (!r)
-		return -EINVAL;
-
 	reg_base = devm_ioremap_resource(dev, r);
 	if (IS_ERR(reg_base))
 		return PTR_ERR(reg_base);
-- 
1.7.9.5

