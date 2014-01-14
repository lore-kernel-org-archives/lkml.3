Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaANA7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:59:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaANA1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 3.10 49/62] clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg clock
Date: Mon, 13 Jan 2014 16:27:14 -0800
Message-Id: <20140114002711.856247495@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhilash Kesavan <a.kesavan@samsung.com>

commit 2feed5aecf5f367b92bd6b6e92afe9e3de466907 upstream.

The sysreg (system register) generates control signals for various blocks
like disp1blk, i2c, mipi, usb etc. However, it gets disabled as an unused
clock at boot-up. This can lead to failures in operation of above blocks,
because they can not be configured properly if this clock is disabled.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
[t.figa: Updated patch description.]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/samsung/clk-exynos5250.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -377,7 +377,8 @@ struct samsung_gate_clock exynos5250_gat
 	GATE(hsi2c2, "hsi2c2", "aclk66", GATE_IP_PERIC, 30, 0, 0),
 	GATE(hsi2c3, "hsi2c3", "aclk66", GATE_IP_PERIC, 31, 0, 0),
 	GATE(chipid, "chipid", "aclk66", GATE_IP_PERIS, 0, 0, 0),
-	GATE(sysreg, "sysreg", "aclk66", GATE_IP_PERIS, 1, 0, 0),
+	GATE(sysreg, "sysreg", "aclk66",
+			GATE_IP_PERIS, 1, CLK_IGNORE_UNUSED, 0),
 	GATE(pmu, "pmu", "aclk66", GATE_IP_PERIS, 2, CLK_IGNORE_UNUSED, 0),
 	GATE(tzpc0, "tzpc0", "aclk66", GATE_IP_PERIS, 6, 0, 0),
 	GATE(tzpc1, "tzpc1", "aclk66", GATE_IP_PERIS, 7, 0, 0),


