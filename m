Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaF0N0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:26:37 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34843 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbaF0N0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:34 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Olivier Bideau <olivier.bideau@st.com>
Subject: [PATCH v2 09/14] drivers: clk: st: Add quadfs reset handling
Date: Fri, 27 Jun 2014 15:25:06 +0200
Message-Id: <1403875511-7710-10-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support of quadfs reset handling.

Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/clk/st/clkgen-fsyn.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index 43936b6..b2b73f4 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -70,12 +70,14 @@ struct clkgen_quadfs_data {
 	bool powerup_polarity;
 	bool standby_polarity;
 	bool nsdiv_present;
+	bool nrst_present;
 	struct clkgen_field ndiv;
 	struct clkgen_field ref_bw;
 	struct clkgen_field nreset;
 	struct clkgen_field npda;
 	struct clkgen_field lock_status;
 
+	struct clkgen_field nrst[QUADFS_MAX_CHAN];
 	struct clkgen_field nsb[QUADFS_MAX_CHAN];
 	struct clkgen_field en[QUADFS_MAX_CHAN];
 	struct clkgen_field mdiv[QUADFS_MAX_CHAN];
@@ -615,6 +617,9 @@ static int quadfs_fsynth_enable(struct clk_hw *hw)
 
 	CLKGEN_WRITE(fs, nsb[fs->chan], !fs->data->standby_polarity);
 
+	if (fs->data->nrst_present)
+		CLKGEN_WRITE(fs, nrst[fs->chan], 0);
+
 	if (fs->lock)
 		spin_unlock_irqrestore(fs->lock, flags);
 
-- 
1.9.1

