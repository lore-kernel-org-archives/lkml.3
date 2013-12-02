Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3LBUVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:21:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3LBTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.12 035/212] i2c: wmt: add missing clk_disable_unprepare() on error
Date: Mon,  2 Dec 2013 11:13:46 -0800
Message-Id: <20131202191252.417000618@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 2dc9688a106886db7191d30f30ffd61fde827efd upstream.

Add the missing clk_disable_unprepare() before return
from wmt_i2c_reset_hardware() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-wmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -349,6 +349,7 @@ static int wmt_i2c_reset_hardware(struct
 	err = clk_set_rate(i2c_dev->clk, 20000000);
 	if (err) {
 		dev_err(i2c_dev->dev, "failed to set clock = 20Mhz\n");
+		clk_disable_unprepare(i2c_dev->clk);
 		return err;
 	}
 


