Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaIXJEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:04:45 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:48286 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752584AbaIXI5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:57:08 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] misc: atmel-ssc: prepare clock only when request
Date: Wed, 24 Sep 2014 16:56:59 +0800
Message-ID: <1411549019-12663-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare SSC clock only when request SSC channel, the clock will be
enabled when initialize the SSC.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 drivers/misc/atmel-ssc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 60843a2..f9807a7 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -57,7 +57,7 @@ struct ssc_device *ssc_request(unsigned int ssc_num)
 	ssc->user++;
 	spin_unlock(&user_lock);
 
-	clk_prepare_enable(ssc->clk);
+	clk_prepare(ssc->clk);
 
 	return ssc;
 }
@@ -77,7 +77,7 @@ void ssc_free(struct ssc_device *ssc)
 	spin_unlock(&user_lock);
 
 	if (disable_clk)
-		clk_disable_unprepare(ssc->clk);
+		clk_unprepare(ssc->clk);
 }
 EXPORT_SYMBOL(ssc_free);
 
-- 
2.1.0.24.g4109c28

