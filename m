Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaDUVsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:48:22 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56500 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaDUVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:48:04 -0400
From: srinivas.kandagatla@linaro.org
To: linux-mmc@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        agross@quicinc.com, linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 05/12] mmc: mmci: use NSEC_PER_SEC macro
Date: Mon, 21 Apr 2014 22:47:58 +0100
Message-Id: <1398116878-31396-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch replaces a constant used in calculating timeout with a proper
macro. This is make code more readable.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 36db31e..4f8d0ba 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -759,7 +759,7 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	data->bytes_xfered = 0;
 
 	clks = (unsigned long long)data->timeout_ns * host->cclk;
-	do_div(clks, 1000000000UL);
+	do_div(clks, NSEC_PER_SEC);
 
 	timeout = data->timeout_clks + (unsigned int)clks;
 
-- 
1.7.9.5

