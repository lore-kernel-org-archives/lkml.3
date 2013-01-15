Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3AOSz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:55:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:34596 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab3AOSzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:55:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 030/221] regulator: s2mps11: Fix ramp delay value shift operation
Date: Tue, 15 Jan 2013 10:49:17 -0800
Message-Id: <20130115185000.208416600@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sangbeom Kim <sbkim73@samsung.com>

commit f7ebaaeb0b4b97b20c1816f11884e7bfe610a2fa upstream.

This patch fix the abnormal ramp delay setting.
The shift operation was wrong.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/s2mps11.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -269,16 +269,16 @@ static __devinit int s2mps11_pmic_probe(
 
 	if (ramp_enable) {
 		if (s2mps11->buck2_ramp)
-			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) >> 6;
+			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) << 6;
 		if (s2mps11->buck3_ramp || s2mps11->buck4_ramp)
-			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) >> 4;
+			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) << 4;
 		sec_reg_write(iodev, S2MPS11_REG_RAMP, ramp_reg | ramp_enable);
 	}
 
 	ramp_reg &= 0x00;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay5) >> 6;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) >> 4;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) >> 2;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay5) << 6;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) << 4;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) << 2;
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
 	sec_reg_write(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg);
 


