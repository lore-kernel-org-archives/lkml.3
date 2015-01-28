Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbbA1CKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:10:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759893AbbA1B2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.18 06/61] mfd: tps65218: Make INT1 our status_base register
Date: Tue, 27 Jan 2015 17:26:18 -0800
Message-Id: <20150128012637.573034143@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit f29ae369a412942e81035984fa3d7a22ddf91fcb upstream.

If we don't tell regmap-irq that our first status
register is at offset 1, it will try to read offset
zero, which is the chipid register.

Fixes: 44b4dc6 mfd: tps65218: Add driver for the TPS65218 PMIC
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/tps65218.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/tps65218.c
+++ b/drivers/mfd/tps65218.c
@@ -204,6 +204,7 @@ static struct regmap_irq_chip tps65218_i
 
 	.num_regs = 2,
 	.mask_base = TPS65218_REG_INT_MASK1,
+	.status_base = TPS65218_REG_INT1,
 };
 
 static const struct of_device_id of_tps65218_match_table[] = {


