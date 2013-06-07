Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3FGPtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:49:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50229 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3FGPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:49:27 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org,
        Zbigniew Bodek <zbb@semihalf.com>
Subject: [PATCH 2/2] i2c-mv64xxx: Abort the mv64xxx_of_config if clock-frequency is not provided
Date: Fri,  7 Jun 2013 17:49:00 +0200
Message-Id: <1370620140-17177-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370620140-17177-1-git-send-email-gregory.clement@free-electrons.com>
References: <1370620140-17177-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zbigniew Bodek <zbb@semihalf.com>

This commit adds checking whether clock-frequency property acquisition
has succeeded. Do not waste time to find baud factors if there is no
information about the desired bus frequency in dts.

[gregory.clement@free-electrons.com: Reword the commit log]

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Zbigniew Bodek <zbb@semihalf.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 60cac9f..88c2dd0 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -593,7 +593,9 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 		goto out;
 	}
 	tclk = clk_get_rate(drv_data->clk);
-	of_property_read_u32(np, "clock-frequency", &bus_freq);
+	if ((rc = of_property_read_u32(np, "clock-frequency", &bus_freq)) != 0)
+		goto out;
+
 	if (!mv64xxx_find_baud_factors(bus_freq, tclk,
 				       &drv_data->freq_n, &drv_data->freq_m)) {
 		rc = -EINVAL;
-- 
1.8.1.2

