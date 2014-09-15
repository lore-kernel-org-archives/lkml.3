Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbaIOVG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:06:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaIOT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 034/158] regulator: tps65218: fix DCDC4 linear voltage range
Date: Mon, 15 Sep 2014 12:24:33 -0700
Message-Id: <20140915192543.910677835@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 42ab0f3915f22728f54bb1f3c0dcf38ab2335b5b upstream.

The second range of this particular regulator,
starts at 1.60V, not as 1.55V as it was originally
implied by code.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/tps65218-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -68,7 +68,7 @@ static const struct regulator_linear_ran
 
 static const struct regulator_linear_range dcdc4_ranges[] = {
 	REGULATOR_LINEAR_RANGE(1175000, 0x0, 0xf, 25000),
-	REGULATOR_LINEAR_RANGE(1550000, 0x10, 0x34, 50000),
+	REGULATOR_LINEAR_RANGE(1600000, 0x10, 0x34, 50000),
 };
 
 static struct tps_info tps65218_pmic_regs[] = {


