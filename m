Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965347Ab3FTLDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:03:02 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34194 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184Ab3FTLC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:02:58 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        patches@linaro.org
Subject: [PATCH RESEND 1/2] clk: samsung: Add MUX_FA macro to pass flag and alias
Date: Thu, 20 Jun 2013 16:17:17 +0530
Message-Id: <1371725238-25437-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371725238-25437-1-git-send-email-tushar.behera@linaro.org>
References: <1371725238-25437-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpufreq driver for some Samsung platforms have not yet been designed as
a platform driver, thereby they can only access clocks with an alias
name.

For EXYNOS4210, one such clock also requires a flag to be set, hence
there is a need to create another macro that can handle both flag and
alias.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/clk/samsung/clk.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index e4ad6ea..2f7dba2 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -144,6 +144,9 @@ struct samsung_mux_clock {
 #define MUX_F(_id, cname, pnames, o, s, w, f, mf)		\
 	__MUX(_id, NULL, cname, pnames, o, s, w, f, mf, NULL)
 
+#define MUX_FA(_id, cname, pnames, o, s, w, f, mf, a)		\
+	__MUX(_id, NULL, cname, pnames, o, s, w, f, mf, a)
+
 /**
  * @id: platform specific id of the clock.
  * struct samsung_div_clock: information about div clock
-- 
1.7.9.5

