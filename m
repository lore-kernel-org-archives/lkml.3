Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab3FFLgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:36:54 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62438 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3FFLgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:36:51 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 1/2] clk: samsung: Add MUX_FA macro to pass flag and alias
Date: Thu,  6 Jun 2013 16:52:27 +0530
Message-Id: <1370517749-29892-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370517749-29892-1-git-send-email-tushar.behera@linaro.org>
References: <1370517749-29892-1-git-send-email-tushar.behera@linaro.org>
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

