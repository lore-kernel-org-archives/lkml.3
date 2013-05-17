Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3EQViF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:38:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3EQViD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 092/102] ASoC: da7213: Fix setting dmic_samplephase and dmic_clk_rate
Date: Fri, 17 May 2013 14:36:47 -0700
Message-Id: <20130517213253.917196537@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 61559af111e41761f5f4f20ce0897345eb59076e upstream.

When set dmic_samplephase and dmic_clk_rate bits for dmic_cfg,
current code checks pdata->dmic_data_sel which is wrong.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/da7213.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -1488,17 +1488,17 @@ static int da7213_probe(struct snd_soc_c
 				     DA7213_DMIC_DATA_SEL_SHIFT);
 			break;
 		}
-		switch (pdata->dmic_data_sel) {
+		switch (pdata->dmic_samplephase) {
 		case DA7213_DMIC_SAMPLE_ON_CLKEDGE:
 		case DA7213_DMIC_SAMPLE_BETWEEN_CLKEDGE:
-			dmic_cfg |= (pdata->dmic_data_sel <<
+			dmic_cfg |= (pdata->dmic_samplephase <<
 				     DA7213_DMIC_SAMPLEPHASE_SHIFT);
 			break;
 		}
-		switch (pdata->dmic_data_sel) {
+		switch (pdata->dmic_clk_rate) {
 		case DA7213_DMIC_CLK_3_0MHZ:
 		case DA7213_DMIC_CLK_1_5MHZ:
-			dmic_cfg |= (pdata->dmic_data_sel <<
+			dmic_cfg |= (pdata->dmic_clk_rate <<
 				     DA7213_DMIC_CLK_RATE_SHIFT);
 			break;
 		}


