Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3BLUfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3BLUfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 03/61] regulator: max8998: fix incorrect min_uV value for ldo10
Date: Tue, 12 Feb 2013 12:34:23 -0800
Message-Id: <20130212203418.445965026@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 36a6f8c035760dcbd0c3acb4c2fd56268588a9cb upstream.

Correct value for minimal voltage for ldo10 output is 950000 uV. This
patch fixes the typo introduced by patch adf6178ad5552a7f2f742a8c85343c50
("regulator: max8998: Use uV in voltage_map_desc"), what solves broken
probe of max8998 in v3.8-rc4.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -65,7 +65,7 @@ static const struct voltage_map_desc ldo
 	.min = 2800000,	.step = 100000,	.max = 3100000,
 };
 static const struct voltage_map_desc ldo10_voltage_map_desc = {
-	.min = 95000,	.step = 50000,	.max = 1300000,
+	.min = 950000,	.step = 50000,	.max = 1300000,
 };
 static const struct voltage_map_desc ldo1213_voltage_map_desc = {
 	.min = 800000,	.step = 100000,	.max = 3300000,


