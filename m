Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3EQNoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:44:39 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36592 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3EQNoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:44:37 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: Mike Turquette <mturquette@linaro.org>, cate@cateee.net
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH] clk: sunxi: "cpu_data" is defined in header files of some architectures
Date: Fri, 17 May 2013 10:43:20 -0300
Message-Id: <1368798200-7063-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <5195D615.70608@cateee.net>
References: <5195D615.70608@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Giacomo A. Catenazzi" <cate@cateee.net>

In some architectures, the #define cpu_data is not a "macro-function",
so the compiler will substitute the identifier with probably something
wrong.

Signed-off-by: Giacomo A. Catenazzi <cate@cateee.net>
Signed-off-by: Emilio López <emilio@elopez.com.ar>
[emilio@elopez.com.ar: use cpu_mux_data instead of this_cpu_data]
---

Hi Giacomo,

I have taken your patch and resent it to linux-arm-kernel and Mike 
Turquette this time, but please try to use git send-email on your next 
patch.

Here is a video from Greg that explains how to use it as well as other 
things (checkpatch.pl, get_maintainer.pl, etc)

http://www.youtube.com/watch?v=LLBrBBImJt4

Thanks! :)

Emilio

 drivers/clk/sunxi/clk-sunxi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 930d36f..412912b 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -239,7 +239,7 @@ struct mux_data {
 	u8 shift;
 };
 
-static const __initconst struct mux_data cpu_data = {
+static const __initconst struct mux_data cpu_mux_data = {
 	.shift = 16,
 };
 
@@ -433,7 +433,7 @@ static const __initconst struct of_device_id clk_div_match[] = {
 
 /* Matches for mux clocks */
 static const __initconst struct of_device_id clk_mux_match[] = {
-	{.compatible = "allwinner,sun4i-cpu-clk", .data = &cpu_data,},
+	{.compatible = "allwinner,sun4i-cpu-clk", .data = &cpu_mux_data,},
 	{.compatible = "allwinner,sun4i-apb1-mux-clk", .data = &apb1_mux_data,},
 	{}
 };
-- 
1.8.2.3

