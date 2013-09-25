Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3IYAQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:16:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab3IYAQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>,
        Kamil Debski <k.debski@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 080/110] media: media: coda: Fix DT driver data pointer for i.MX27
Date: Tue, 24 Sep 2013 17:15:18 -0700
Message-Id: <20130925001332.085410512@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

commit 7b0dd9e60e714951b5400dd0740b3c4c3c3cb76f upstream.

The data pointer should point to DT data, and not to the ID
array.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/coda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1933,7 +1933,7 @@ MODULE_DEVICE_TABLE(platform, coda_platf
 
 #ifdef CONFIG_OF
 static const struct of_device_id coda_dt_ids[] = {
-	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
+	{ .compatible = "fsl,imx27-vpu", .data = &coda_devdata[CODA_IMX27] },
 	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
 	{ /* sentinel */ }
 };


