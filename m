Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389Ab3DCM3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:29:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48221 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643Ab3DCM3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:29:07 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] mfd: vexpress: Give the "leds-gpio" device a real parent
Date: Wed,  3 Apr 2013 13:26:27 +0100
Message-Id: <1364991987-6598-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
X-OriginalArrivalTime: 03 Apr 2013 12:29:03.0025 (UTC) FILETIME=[D34E6210:01CE3066]
X-MC-Unique: 113040313290500301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r33CTE4V028011

The registration of the "leds-gpio" device was using
"vexpress_sysreg_dev" as a parent before it was actually
set to something different than NULL.

Trivial fix by reordering the code.

Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-sysreg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index bf75e96..96a020b 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -490,12 +490,12 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	vexpress_sysreg_dev = &pdev->dev;
+
 	platform_device_register_data(vexpress_sysreg_dev, "leds-gpio",
 			PLATFORM_DEVID_AUTO, &vexpress_sysreg_leds_pdata,
 			sizeof(vexpress_sysreg_leds_pdata));
 
-	vexpress_sysreg_dev = &pdev->dev;
-
 	device_create_file(vexpress_sysreg_dev, &dev_attr_sys_id);
 
 	return 0;
-- 
1.7.10.4


