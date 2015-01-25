Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbbAYSqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:46:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbbAYSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jisheng Zhang <jszhang@marvell.com>,
        Michael Turquette <mturquette@linaro.org>
Subject: [PATCH 3.18 092/183] clk: berlin: bg2q: remove non-exist "smemc" gate clock
Date: Sun, 25 Jan 2015 10:06:54 -0800
Message-Id: <20150125180814.172523775@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@marvell.com>

commit b71e8ecd57c8aae5b1815782c47b74ffe3efc09a upstream.

The "smemc" clock is removed on BG2Q SoCs. In fact, bit19 of clkenable
register is for nfc. Current code use bit19 for non-exist "smemc"
incorrectly, this prevents eMMC from working due to the sdhci's
"core" clk is still gated.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/berlin/bg2q.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -285,7 +285,6 @@ static const struct berlin2_gate_data bg
 	{ "pbridge",	"perif",	15, CLK_IGNORE_UNUSED },
 	{ "sdio",	"perif",	16, CLK_IGNORE_UNUSED },
 	{ "nfc",	"perif",	18 },
-	{ "smemc",	"perif",	19 },
 	{ "pcie",	"perif",	22 },
 };
 


